import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';
import 'package:visai/domain/entities/gamification/gamification_entity.dart';
// import 'package:visai/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
// import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_state_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/typing_progress_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/animated_context_board.dart';
import 'package:visai/features/typing_session/presentation/widgets/main_metrics_bar.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/practice_start_button.dart';
import 'package:visai/features/typing_session/presentation/widgets/typing_progress.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:logger/logger.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:visai/features/keyboard/presentation/tamil_keyboard/letters.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:visai/features/keyboard/presentation/providers/keyboard_provider.dart';

class PracticeEditorPage extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final GamificationEntity? gamificationData;

  const PracticeEditorPage({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.gamificationData,
  });

  @override
  ConsumerState<PracticeEditorPage> createState() => _PracticeEditorPage();
}

class _PracticeEditorPage extends ConsumerState<PracticeEditorPage> {
  final _logger = Logger();
  late String paragraph;
  int _lastLen = 0;
  // Mutex: only one async listener invocation runs at a time.
  bool _processingKeys = false;
  // Pending left-diacritic awaiting its right-diacritic to form a composed vowel.
  // e.g. ெ (U+0BC6) waiting for ா (U+0BBE) to compose into ொ (U+0BCA).
  String? _compositionPending;
  late VoidCallback _controllerListener;
  late DifficultyCriteriaEntity? difficultyCriteria;
  AudioPlayer? _fallbackAudioPlayer;
  bool _fallbackAudioLoaded = false;

  @override
  void initState() {
    super.initState();

    // Roll a new paragraph explicitly when starting
    ref.read(textContentControllerProvider.notifier).rollNewContent();

    // Pre-load fallback audio for low latency playback
    _initializeFallbackAudio();

    _controllerListener = () async {
      // Only one async processing chain runs at a time.
      // If another invocation fires while we are inside an await, it exits
      // here. The outer while-loop below will drain any characters that
      // arrived during that await, so nothing is lost.
      if (!mounted || _processingKeys) return;
      _processingKeys = true;

      if (kDebugMode) {
        final preview = paragraph.length > 20 ? paragraph.substring(0, 20) : paragraph;
        _logger.d('[LISTEN] _lastLen=$_lastLen ctrl.text.len=${widget.controller.text.length} para="${preview.replaceAll('\n', '↵')}"');
      }

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
            //     (e.g. Try Again / Reset). Just sync _lastLen — the session
            //     state was already reset via Riverpod providers.
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
            // In-place edit: keep [userInput] in sync so
            // [typingProgressProvider] and session end detection stay aligned.
            ref.read(userInputProvider.notifier).set(textNow);
            // The keyboard may have done an in-place substitution with the same
            // text length — e.g. replacing "தெ" (U+0BA4+U+0BC6) with "தொ"
            // (U+0BA4+U+0BCA) when ா is pressed after a held left-diacritic.
            // Length didn't change, so the normal append path never runs.
            if (_compositionPending != null && to > 0) {
              const composedVowelForms = {'\u0BCA', '\u0BCB', '\u0BCC'};
              final substituted = textNow[to - 1];
              if (composedVowelForms.contains(substituted)) {
                final nfcPara = Letters.normalizeTypingText(paragraph);
                final expectedCursor =
                    ref.read(sessionStateNotifierProvider).cursor;
                final expected = (expectedCursor < nfcPara.length)
                    ? nfcPara[expectedCursor]
                    : null;
                final correct = expected != null && substituted == expected;
                _compositionPending = null;
                await ctrl.onKey(correct: correct);
              }
            } else {
              await ctrl.catchUpCursorAfterInPlaceEdit(
                paragraph: paragraph,
                typedText: textNow,
              );
            }
            break;
          }

          _lastLen = to;
          ref.read(userInputProvider.notifier).set(textNow);

          // Normalize the paragraph: first apply Tamil-specific vowel compositions
          // (ே+ா→ோ, ெ+ா→ொ, ெ+ௗ→ௌ) then general NFC.  unorm.nfc alone does
          // not reliably compose these Tamil pairs in the Dart runtime.
          final nfcPara = unorm.nfc(Letters.applyDiacriticCompositions(paragraph));

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
            // single precomposed code point (ொ U+0BCA). We compose them here
            // before comparing so the match works correctly.
            String charToCompare;
            int codUnitsConsumed = 1;

            // Composed vowel signs that are formed from two decomposed code units.
            // The keyboard sends these as two separate code units (e.g. ெ+ா for ொ),
            // but the paragraph stores them as the single precomposed NFC code point.
            const composedVowelForms = {'\u0BCA', '\u0BCB', '\u0BCC'}; // ொ, ோ, ௌ
            const leftDiacritics = {'\u0BC6', '\u0BC7'}; // ெ, ே

            if (_compositionPending != null) {
              // Previous invocation left a pending left-diacritic; try to
              // complete the composition with the current code unit.
              final pair = _compositionPending! + received;
              _compositionPending = null;
              // Use Letters.diacriticCombos as the authoritative Tamil composition
              // table — more reliable than unorm.nfc for these specific pairs.
              final composed = Letters.diacriticCombos[pair] ?? unorm.nfc(pair);
              if (composed.length == 1) {
                charToCompare = composed;
              } else {
                // No composition — emit an error for the pending diacritic
                // then fall through to process `received` normally below.
                await ctrl.onKey(correct: false);
                if (!ref.read(sessionStateNotifierProvider).running) break;
                charToCompare = received;
              }
            } else {
              // Only defer as a composition-start when the EXPECTED character is
              // a composed vowel form (ொ/ோ/ௌ). When ெ/ே is itself the expected
              // character (e.g. in "செ"), compare it directly — don't defer.
              final expectedAtCursor = (expectedCursor < nfcPara.length)
                  ? nfcPara[expectedCursor]
                  : null;
              final needsComposition = leftDiacritics.contains(received) &&
                  expectedAtCursor != null &&
                  composedVowelForms.contains(expectedAtCursor);

              if (needsComposition) {
                if (i + 1 < to) {
                  // Look ahead in the same batch.
                  final next = textNow[i + 1];
                  final pair = received + next;
                  final composed =
                      Letters.diacriticCombos[pair] ?? unorm.nfc(pair);
                  if (composed.length == 1) {
                    charToCompare = composed;
                    codUnitsConsumed = 2; // consume both code units
                  } else {
                    charToCompare = received;
                  }
                } else {
                  // Next code unit arrives in the next invocation — defer.
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
            if (correct) expectedCursor += codUnitsConsumed;
            // Session may have ended (completed) inside onKey. Stop processing
            // remaining characters — otherwise the next onKey call would see
            // running=false and restart the session from scratch.
            if (!ref.read(sessionStateNotifierProvider).running) break;

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

            _playKeypressSoundIfEnabled();
            i += codUnitsConsumed;
          }

          // If more characters arrived during the awaits above, the while
          // loop will process them in the next iteration. Also stop if the
          // session ended mid-batch (completed inside onKey above).
          if (widget.controller.text.length <= _lastLen) break;
          if (!ref.read(sessionStateNotifierProvider).running) break;
        }

        // One more sync: field can differ from [userInput] (e.g. same-length Tamil edits).
        final textNow = widget.controller.text;
        ref.read(userInputProvider.notifier).set(textNow);
        final sessionApi = ref.read(sessionControllerProvider.notifier);
        await sessionApi.maybeFinishSessionByProgress();

        if (mounted &&
            sessionApi.isNormalizedTextEqualToSessionTarget(
                widget.controller.text)) {
          // Reset _lastLen BEFORE clear() so that the clear-triggered listener
          // invocation (rejected by the mutex) leaves _lastLen at 0.  Without
          // this, the next session's first character is skipped because
          // _lastLen still holds the old session's length.
          _lastLen = 0;
          _compositionPending = null;
          ref.read(userInputProvider.notifier).clear();
          ref.read(keyboardControllerProvider(widget.controller))
              .resetCompositionState();
          widget.controller.clear();
        }
      } finally {
        _processingKeys = false;
      }

      if (mounted) setState(() {});
    };

    widget.controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    _fallbackAudioPlayer?.dispose();
    super.dispose();
  }

  // Initialize fallback audio player with pre-loaded sound for low latency
  Future<void> _initializeFallbackAudio() async {
    try {
      _fallbackAudioPlayer = AudioPlayer();
      // Configure for low latency playback
      await _fallbackAudioPlayer!.setVolume(1.0);
      await _fallbackAudioPlayer!.setSpeed(1.0);

      // Load the asset (this pre-loads it for instant playback)
      await _fallbackAudioPlayer!.setAsset(
        'assets/sounds/single keypad click.wav',
      );

      if (mounted) {
        setState(() {
          _fallbackAudioLoaded = true;
        });
      }
      _logger.d('Fallback audio initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Error initializing fallback audio: $e',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _fallbackAudioLoaded = false;
        });
      }
    }
  }

  void _playKeypressSoundIfEnabled() {
    final config = ref.read(practiceConfigurationProvider);
    if (!config.soundEnabled) return;

    // Try system sound first (non-blocking, may not work on all devices)
    try {
      SystemSound.play(SystemSoundType.click);
    } catch (e) {
      // System sound failed, will use fallback
    }

    // Always play fallback sound for reliability
    _playFallbackSound();
  }

  // Fallback sound using pre-loaded audio player for low latency
  void _playFallbackSound() {
    if (!_fallbackAudioLoaded || _fallbackAudioPlayer == null) {
      // If not loaded yet, try to initialize and play
      if (!_fallbackAudioLoaded) {
        _initializeFallbackAudio().then((_) {
          if (mounted && _fallbackAudioLoaded && _fallbackAudioPlayer != null) {
            _playSoundNow();
          }
        });
      }
      return;
    }

    _playSoundNow();
  }

  // Helper method to actually play the sound
  void _playSoundNow() {
    if (_fallbackAudioPlayer == null || !_fallbackAudioLoaded) return;

    // For rapid keypresses, we need to handle the player state
    // Stop current playback if any, then seek to start and play
    _fallbackAudioPlayer!
        .stop()
        .then((_) {
          return _fallbackAudioPlayer!.seek(Duration.zero);
        })
        .then((_) {
          return _fallbackAudioPlayer!.play();
        })
        .catchError((e) {
          _logger.e('Error in playback chain: $e');
          // If stop/seek fails, try direct play
          try {
            _fallbackAudioPlayer!.play().catchError((playError) {
              _logger.e('Error in direct play fallback: $playError');
            });
          } catch (finalError) {
            _logger.e('Error in direct play fallback (catch): $finalError');
          }
        });
  }

  @override
  Widget build(BuildContext ctx) {
    // 🌐 PROVIDERS ------------------------------
    final textContent = ref.watch(textContentControllerProvider);
    final sessionStatusController = ref.read(
      sessionStatusControllerProvider.notifier,
    ); // Session Controller
    final sessionEngineController = ref.read(
      sessionControllerProvider.notifier,
    );
    final sessionState = ref.watch(sessionStatusControllerProvider);
    final typingProgress = ref.watch(typingProgressProvider);
    final practiceConfig = ref.watch(
      practiceConfigurationProvider.select((config) => config.difficulty),
    );

    // _logger.f(textContent);

    // 📃 DECLARATION ----------------------------
    final practiceStatus = sessionState.mode == SessionMode.practice
        ? sessionState.status
        : false;
    paragraph = textContent != null ? textContent.content : placeholderText;
    difficultyCriteria = widget
        .gamificationData
        ?.difficultyCriteria // Getting difficulty criteria based on difficulty config
        .where(
          (criteria) =>
              criteria.type.toLowerCase() ==
              practiceConfig.name.toString().toLowerCase(),
        )
        .firstOrNull;

    // 🚀 METHODS ---------------------------------

    // 👇 HANDLE START
    void handleStartMain() async {
      sessionStatusController.reset();
      sessionStatusController.updateMode(SessionMode.practice);
      // await ref.read(textContentControllerProvider.notifier).rollNewContent();
      sessionStatusController.updateStatus(SessionStatusEnum.start);
      await sessionEngineController.start();
    }

    // 👇 HANDLE TEXT FIELD FOCUS
    ref.listen(sessionStatusControllerProvider, (prev, next) {
      if (next.mode == SessionMode.practice &&
          next.status == SessionStatusEnum.start) {
        // focus the text field
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.focusNode.requestFocus();
        });
      } else {
        widget.focusNode.unfocus();
      }
    });

    // 👇 LISTEN TO PROGRESS COMPLETION

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
                      ignoring: false, // <- key change: don't intercept taps/scrolls
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

                  AnimatedSlide(
                    offset: practiceStatus == SessionStatusEnum.start
                        ? const Offset(0, 1)
                        : Offset.zero,
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.fastOutSlowIn,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: PracticeStartButton(
                        handleStart: handleStartMain,
                      ), // 👈 PRACTICE BOTTOM START BUTTON
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
