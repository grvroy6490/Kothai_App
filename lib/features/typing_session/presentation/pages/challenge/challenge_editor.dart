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
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/typing_progress_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/animated_context_board.dart';
import 'package:visai/features/typing_session/presentation/widgets/main_metrics_bar.dart';
import 'package:visai/features/typing_session/presentation/widgets/typing_progress.dart';
// import 'package:logger/logger.dart';

class ChallengeEditor extends ConsumerStatefulWidget {
    final TextEditingController controller;
    final FocusNode focusNode;
    final GamificationEntity? gamificationData;

    const ChallengeEditor({
        super.key,
        required this.controller,
        required this.focusNode,
        required this.gamificationData
    });

    @override
    ConsumerState<ChallengeEditor> createState() => _ChallengeEditorState();
}

class _ChallengeEditorState extends ConsumerState<ChallengeEditor> {
    // final _logger = Logger();
    late String paragraph;
    int _lastLen = 0;
    late VoidCallback _controllerListener;
    late DifficultyCriteriaEntity? difficultyCriteria;

    @override
    void initState() {
        super.initState();

        _controllerListener = () async {
            if (!mounted) return;

            final textNow = widget.controller.text;

            // 1) keep your provider in sync
            ref.read(userInputProvider.notifier).set(textNow);

            // 2) compute deltas and call onKey for new chars
            final ctrl = ref.read(sessionControllerProvider.notifier);
            final progress = ref.read(typingProgressProvider);

            // If user pasted multiple chars, process each new char
            if (textNow.length > _lastLen) {
                for (int i = _lastLen; i < textNow.length; i++) {
                    final received = textNow[i];
                    // Guard against paragraph shorter than input
                    final expected = (i < paragraph.length) ? paragraph[i] : null;
                    final correct = expected != null && received == expected;
                    await ctrl.onKey(correct: correct);
                }
            }
            // If user deleted (backspace), we won't alter metrics here.
            // (If you want to support take-backs: add a ctrl.onBackspace() that adjusts metrics.)

            if (progress >= 1.0) {
                widget.controller.clear();
            }

            _lastLen = textNow.length;
            setState(() {
                }); // if you still need a local rebuild
        };

        widget.controller.addListener(_controllerListener);
    }

    @override
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
            challengeDifficultyControllerProvider
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
                    challengeDifficulty.name.toString().toLowerCase()
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
                                width: typingProgress
                            ) // 👈 TYPING PROGRESS // TODO: Dynamic Progress Variable here
                        ),

                        Container(
                            decoration: BoxDecoration(
                                color: getFigmaColor(context, 'Schemes/Background'),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24))
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
                                                    difficulty: difficultyCriteria
                                                ) // 👈 PRACTICE METRICS BAR
                                            ),
                                            Flexible(
                                                child: AnimatedContentBoard(
                                                    paragraph: paragraph
                                                ) // 👈 CONTENT BOARD
                                            )
                                        ]
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
                                                                'Schemes/On Surface'
                                                            )
                                                        ),
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors.black87,
                                                                width: 1
                                                            )
                                                        ),
                                                        contentPadding: EdgeInsets.zero
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }
}
