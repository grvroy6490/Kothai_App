import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';
import 'package:visai/domain/entities/gamification/gamification_entity.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_state_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/typing_progress_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/animated_context_board.dart';
import 'package:visai/features/typing_session/presentation/widgets/main_metrics_bar.dart';
import 'package:visai/features/typing_session/presentation/widgets/typing_progress.dart';
import 'package:logger/logger.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:visai/features/keyboard/presentation/tamil_keyboard/letters.dart';

class ChallengeEditor extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final GamificationEntity? gamificationData;

  const ChallengeEditor({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.gamificationData,
  });

  @override
  ConsumerState<ChallengeEditor> createState() => _ChallengeEditorState();
}

class _ChallengeEditorState extends ConsumerState<ChallengeEditor> {
  final _logger = Logger();
  late String paragraph;
  int _lastLen = 0;
  // Mutex: only one async listener invocation runs at a time.
  // Any invocations that arrive while processing is in progress are dropped;
  // the outer while-loop picks up any characters that arrived during an await.
  bool _processingKeys = false;
  // Pending left-diacritic awaiting its right-diacritic to form a composed vowel.
  String? _compositionPending;
  late VoidCallback _controllerListener;
  late DifficultyCriteriaEntity? difficultyCriteria;

  @override
  void initState() {
    super.initState();

    _controllerListener = () async {
      // Only one async processing chain runs at a time.
      // If another invocation fires while we are inside an await, it exits
      // here. The outer while-loop below will drain any characters that
      // arrived during that await, so nothing is lost.
      if (!mounted || _processingKeys) return;
      _processingKeys = true;

      try {
        final ctrl = ref.read(sessionControllerProvider.notifier);

        while (mounted) {
          final textNow = widget.controller.text;
          final from = _lastLen;
          final to = textNow.length;

          if (to < from) {
            // Text was deleted. Two cases:
            // (a) Normal backspace: roll back cursor/metrics for each deleted char.
            // (b) External reset: the controller was cleared programmatically
            //     (e.g. Try Again). In this case just sync _lastLen and don't
            //     emit any onBackspace calls — the session state was already
            //     reset via the Riverpod providers.
            final sessionRunning =
                ref.read(sessionStateNotifierProvider).running;
            final deletedCount = from - to;
            _lastLen = to;
            _compositionPending = null;
            ref.read(userInputProvider.notifier).set(textNow);
            if (sessionRunning) {
              for (int d = 0; d < deletedCount; d++) {
                ctrl.onBackspace();
              }
            }
            break;
          }
          if (to == from) {
            if (_compositionPending != null && to > 0) {
              const composedVowelForms = {'\u0BCA', '\u0BCB', '\u0BCC'};
              final substituted = textNow[to - 1];
              if (composedVowelForms.contains(substituted)) {
                final nfcPara =
                    unorm.nfc(_applyTamilCompositions(paragraph));
                final expectedCursor =
                    ref.read(sessionStateNotifierProvider).cursor;
                final expected = (expectedCursor < nfcPara.length)
                    ? nfcPara[expectedCursor]
                    : null;
                final correct = expected != null && substituted == expected;
                _compositionPending = null;
                ref.read(userInputProvider.notifier).set(textNow);
                await ctrl.onKey(correct: correct);
              }
            }
            break;
          }

          _lastLen = to;
          ref.read(userInputProvider.notifier).set(textNow);

          final nfcPara = unorm.nfc(_applyTamilCompositions(paragraph));

          // Read cursor AFTER any previous onKey has had a chance to
          // call advanceCursor — safe because we are the only async invocation.
          var expectedCursor = ref.read(sessionStateNotifierProvider).cursor;

          int i = from;
          while (i < to) {
            if (!mounted) break;
            final received = textNow[i];

            // ── Tamil vowel composition ────────────────────────────────────────
            // The keyboard sends ொ/ோ/ௌ as two decomposed code units
            // (e.g. ெ U+0BC6 + ா U+0BBE), but the paragraph stores them as a
            // single precomposed code point (ொ U+0BCA). Compose before comparing.
            String charToCompare;
            int codUnitsConsumed = 1;

            const composedVowelForms = {'\u0BCA', '\u0BCB', '\u0BCC'}; // ொ, ோ, ௌ
            const leftDiacritics = {'\u0BC6', '\u0BC7'}; // ெ, ே

            if (_compositionPending != null) {
              final pair = _compositionPending! + received;
              _compositionPending = null;
              final composed =
                  Letters.diacriticCombos[pair] ?? unorm.nfc(pair);
              if (composed.length == 1) {
                charToCompare = composed;
              } else {
                await ctrl.onKey(correct: false);
                charToCompare = received;
              }
            } else {
              final expectedAtCursor = (expectedCursor < nfcPara.length)
                  ? nfcPara[expectedCursor]
                  : null;
              final needsComposition = leftDiacritics.contains(received) &&
                  expectedAtCursor != null &&
                  composedVowelForms.contains(expectedAtCursor);

              if (needsComposition) {
                if (i + 1 < to) {
                  final next = textNow[i + 1];
                  final pair = received + next;
                  final composed =
                      Letters.diacriticCombos[pair] ?? unorm.nfc(pair);
                  if (composed.length == 1) {
                    charToCompare = composed;
                    codUnitsConsumed = 2;
                  } else {
                    charToCompare = received;
                  }
                } else {
                  _compositionPending = received;
                  i++;
                  continue;
                }
              } else {
                charToCompare = received;
              }
            }

            final expected = (expectedCursor < nfcPara.length)
                ? nfcPara[expectedCursor]
                : null;
            final correct = expected != null && charToCompare == expected;
            await ctrl.onKey(correct: correct);
            if (correct) expectedCursor++;

            if (kDebugMode) {
              final m = ref.read(metricsStateControllerProvider);
              _logger.d(
                '[KEY i=$i] '
                'received="${charToCompare}"(U+${charToCompare.codeUnitAt(0).toRadixString(16).toUpperCase()}) '
                'expected="${expected ?? "∅"}"'
                '${expected != null ? "(U+${expected.codeUnitAt(0).toRadixString(16).toUpperCase()})" : ""} '
                'correct=$correct | '
                'typed=${m.typed} correct=${m.correct} errors=${m.errors} '
                'accuracy=${(m.accuracy * 100).toStringAsFixed(1)}% '
                'wpm=${m.wpm.toStringAsFixed(1)} '
                'cursor=$expectedCursor',
              );
            }

            i += codUnitsConsumed;
          }

          // If more characters arrived during the awaits above, the while
          // loop will process them in the next iteration.
          if (widget.controller.text.length <= _lastLen) break;
        }

        if (mounted && ref.read(typingProgressProvider) >= 1.0) {
          // Reset _lastLen BEFORE clear() so that the clear-triggered listener
          // invocation (rejected by the mutex) leaves _lastLen at 0.
          _lastLen = 0;
          _compositionPending = null;
          widget.controller.clear();
        }
      } finally {
        _processingKeys = false;
      }

      if (mounted) setState(() {});
    };

    widget.controller.addListener(_controllerListener);
  }

  String _applyTamilCompositions(String text) {
    String result = text;
    for (final entry in Letters.diacriticCombos.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🌐 PROVIDERS ------------------------------
    final textContent = ref.watch(textContentControllerProvider);
    // final sessionController = ref.read(
    //     sessionStatusControllerProvider.notifier
    // ); // Session Controller
    // final sessionState = ref.watch(sessionStatusControllerProvider);
    final challengeDifficulty = ref.watch(
      challengeDifficultyControllerProvider,
    );
    final typingProgress = ref.watch(typingProgressProvider);

    // final challengeStatus = sessionState.mode == SessionMode.challenge
    //     ? sessionState.status
    //     : false;
    paragraph = textContent != null ? textContent.content : placeholderText;
    difficultyCriteria = widget
        .gamificationData
        ?.difficultyCriteria // Getting difficulty criteria based on difficulty config
        .where(
          (criteria) =>
              criteria.type.toLowerCase() ==
              challengeDifficulty.name.toString().toLowerCase(),
        )
        .firstOrNull;

    // 🚀 METHODS ---------------------------------

    // 👇 HANDLE TEXT FIELD FOCUS
    ref.listen(sessionStatusControllerProvider, (prev, next) {
      if (next.mode == SessionMode.challenge &&
          next.status == SessionStatusEnum.start) {
        // focus the text field
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.focusNode.requestFocus();
        });
      } else {
        widget.focusNode.unfocus();
      }
    });

    // ⭐ Widget --------------------------------------
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: Gap(context).gap(5)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // TYPING PROGRESS
            Positioned(
              top: -3,
              left: 0,
              right: 0,
              child: TypingProgress(
                width: typingProgress,
              ), // 👈 TYPING PROGRESS // TODO: Dynamic Progress Variable here
            ),

            Container(
              decoration: BoxDecoration(
                color: getFigmaColor(context, 'Schemes/Background'),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: Gap(context).gap(75),
                        width: double.infinity,
                        child: MainMetricsBar(
                          paragraph: paragraph,
                          difficulty: difficultyCriteria,
                        ), // 👈 PRACTICE METRICS BAR
                      ),
                      Flexible(
                        child: AnimatedContentBoard(
                          paragraph: paragraph,
                        ), // 👈 CONTENT BOARD
                      ),
                    ],
                  ),

                  Positioned.fill(
                    top: MediaQuery.of(context).size.height * 1.1,
                    child: IgnorePointer(
                      ignoring:
                          true, // <- key change: don't intercept taps/scrolls
                      child: Opacity(
                        opacity: 0,
                        child: TextFormField(
                          maxLines: 2,
                          controller: widget.controller,
                          focusNode: widget.focusNode,
                          readOnly: true,
                          showCursor: false,
                          enableInteractiveSelection: false,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: getFigmaColor(
                                  context,
                                  'Schemes/On Surface',
                                ),
                              ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black87,
                                width: 1,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
