import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';
import 'package:visai/domain/entities/gamification/gamification_entity.dart';
import 'package:visai/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/typing_progress_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/animated_context_board.dart';
import 'package:visai/features/typing_session/presentation/widgets/main_metrics_bar.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/practice_start_button.dart';
import 'package:visai/features/typing_session/presentation/widgets/typing_progress.dart';
import 'package:logger/logger.dart';

class PracticeEditorPage extends ConsumerStatefulWidget {
    final TextEditingController controller;
    final FocusNode focusNode;
    final GamificationEntity? gamificationData;

    const PracticeEditorPage({
        super.key,
        required this.controller,
        required this.focusNode,
        required this.gamificationData
    });

    @override
    ConsumerState<PracticeEditorPage> createState() => _PracticeEditorPage();
}

class _PracticeEditorPage extends ConsumerState<PracticeEditorPage> {
    final _logger = Logger();
    late String paragraph;
    int _lastLen = 0;
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

                    // Play keypress sound if enabled
                    _playKeypressSoundIfEnabled();
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
                'assets/sounds/single keypad click.wav'
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
                stackTrace: stackTrace
            );
            if (mounted) {
                setState(() {
                        _fallbackAudioLoaded = false;
                    });
            }
        }
    }

    // Method to play keypress sound if enabled (using fallback sound primarily)
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
            sessionStatusControllerProvider.notifier
        ); // Session Controller
        final sessionEngineController = ref.read(
            sessionControllerProvider.notifier
        );
        final sessionState = ref.watch(sessionStatusControllerProvider);
        final typingProgress = ref.watch(typingProgressProvider);
        final practiceConfig = ref.watch(
            practiceConfigurationProvider.select((config) => config.difficulty)
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
                    practiceConfig.name.toString().toLowerCase()
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
                                                handleStart: handleStartMain
                                            ) // 👈 PRACTICE BOTTOM START BUTTON
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
