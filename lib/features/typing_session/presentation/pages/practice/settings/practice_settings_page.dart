import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/typing_session/domain/entities/practice/config_switch_option.dart';
import 'package:visai/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/domain/enums/text_size_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/settings/blind_mode.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/settings/segmented_buttons.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/settings/settings_title_bar.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/settings/switch_settings_card.dart';

class PracticeSettingsPage extends ConsumerStatefulWidget {
    const PracticeSettingsPage({super.key});

    @override
    ConsumerState<PracticeSettingsPage> createState() =>
    _PracticeSettingsPageState();
}

class _PracticeSettingsPageState extends ConsumerState<PracticeSettingsPage> {
    @override
    Widget build(BuildContext context) {
        // 🌐 PROVIDERS ------------------------------
        final config = ref.watch(practiceConfigurationProvider);

        // 📃 DECLARATION ----------------------------
        final PracticeConfig configuration = PracticeConfig(
            accuracyEnabled: config.accuracyEnabled,
            allowPauses: config.allowPauses,
            allowTakeBacks: config.allowTakeBacks,
            blindMode: config.blindMode,
            contentFontSize: config.contentFontSize,
            contentLength: config.contentLength,
            difficulty: config.difficulty,
            darkMode: config.darkMode,
            errorsEnabled: config.errorsEnabled,
            hapticEnabled: config.hapticEnabled,
            hapticOnError: config.hapticOnError,
            mode: config.mode,
            randomize: config.randomize,
            soundEnabled: config.soundEnabled,
            soundOnError: config.soundOnError,
            timerEnabled: config.timerEnabled,
            wpmEnabled: config.wpmEnabled
        );

        // 🚀 METHODS --------------------------------
        // 👇 HANDLE UPDATE SETTING - Use specific property updates instead of replacing entire config
        void updateDifficulty(DifficultyEnum difficulty) {
            ref
                .read(practiceConfigurationProvider.notifier)
                .setDifficulty(difficulty);
        }

        void updateContentFontSize(TextSizeEnum fontSize) {
            ref
                .read(practiceConfigurationProvider.notifier)
                .setContentFontSize(fontSize);
        }

        void updateBlindMode() {
            ref.read(practiceConfigurationProvider.notifier).toggleBlindMode();
        }

        void updateWpm() {
            ref.read(practiceConfigurationProvider.notifier).toggleWpm();
        }

        void updateAccuracy() {
            ref.read(practiceConfigurationProvider.notifier).toggleAccuracy();
        }

        void updateTimer() {
            ref.read(practiceConfigurationProvider.notifier).toggleTimer();
        }

        void updateAllowTakeBacks() {
            ref.read(practiceConfigurationProvider.notifier).toggleAllowTakeBacks();
        }

        void updateAllowPauses() {
            ref.read(practiceConfigurationProvider.notifier).toggleAllowPauses();
        }

        void updateHapticEnabled() {
            ref.read(practiceConfigurationProvider.notifier).toggleHaptics();
        }

        void updateHapticOnError() {
            ref.read(practiceConfigurationProvider.notifier).toggleHapticsOnError();
        }

        void updateTypingSound() async {
            final currentState = config.soundEnabled;
            // Toggle the sound setting
            await ref.read(practiceConfigurationProvider.notifier).toggleSound();

            // If enabling sound, show dialog and play test sound
            if (!currentState && mounted) {
                // Play test sound immediately
                try {
                    SystemSound.play(SystemSoundType.click);
                } catch (e) {
                    // Ignore errors, dialog will handle it
                }

                // Show dialog asking user to check system sound settings
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    useRootNavigator: true,
                    builder: (dialogContext) => _SystemSoundCheckDialog()
                );
            }
        }

        final liveStats = <ConfigSwitchOption>[
            ConfigSwitchOption(
                title: 'WPM',
                select: (c) => c.wpmEnabled,
                toggle: (c) {
                    updateWpm();
                    return c;
                }
            ),
            ConfigSwitchOption(
                title: 'Accuracy',
                select: (c) => c.accuracyEnabled,
                toggle: (c) {
                    updateAccuracy();
                    return c;
                }
            ),
            ConfigSwitchOption(
                title: 'Time',
                select: (c) => c.timerEnabled,
                toggle: (c) {
                    updateTimer();
                    return c;
                }
            )
            // ConfigSwitchOption(title: 'Errors', select: (c) => c.errorsEnabled, toggle: (c) => c.copyWith(errorsEnabled: !c.errorsEnabled))
        ];

        final assistanceOptions = <ConfigSwitchOption>[
            ConfigSwitchOption(
                title: 'Allow Take Backs',
                select: (c) => c.allowTakeBacks,
                toggle: (c) {
                    updateAllowTakeBacks();
                    return c;
                }
            ),
            ConfigSwitchOption(
                title: 'Allow Pause',
                select: (c) => c.allowPauses,
                toggle: (c) {
                    updateAllowPauses();
                    return c;
                }
            )
        ];

        final feedbacks = <ConfigSwitchOption>[
            ConfigSwitchOption(
                title: 'Sound on Typing',
                select: (c) => c.soundEnabled,
                toggle: (c) {
                    updateTypingSound();
                    return c;
                }
            ),
            // ConfigSwitchOption(title: 'Sound on Error', select: (c) => c.soundOnError, toggle: (c) => c.copyWith(soundOnError: !c.soundOnError)),
            ConfigSwitchOption(
                title: 'Typing Vibration',
                select: (c) => c.hapticEnabled,
                toggle: (c) {
                    updateHapticEnabled();
                    return c;
                }
            ),
            ConfigSwitchOption(
                title: 'Error Vibration',
                select: (c) => c.hapticOnError,
                toggle: (c) {
                    updateHapticOnError();
                    return c;
                }
            )
        ];

        // ⭐ Widget ---------------------------------
        return Container(
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)
                )
            ),
            child: Column(
                children: [
                    SettingsTitleBar(),

                    Expanded(
                        child: SingleChildScrollView(
                            padding: EdgeInsets.only(bottom: Gap(context).gap(8)),
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                                children: [
                                    // SET DIFFICULTY
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Gap(context).gap(16),
                                            vertical: Gap(context).gap(10)
                                        ),
                                        child: Row(
                                            children: [
                                                Text(
                                                    'Difficulty',
                                                    style: Theme.of(context).textTheme.bodyMedium
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Surface Variant'
                                                            ),
                                                            fontWeight: FontWeight.w500
                                                        )
                                                ),
                                                SizedBox(width: Gap(context).gap(20)),
                                                Expanded(
                                                    child: SegmentedButtons(
                                                        selected: configuration.difficulty,
                                                        iterable: DifficultyEnum.values,
                                                        onSelected: (option) => updateDifficulty(option)
                                                    )
                                                )
                                            ]
                                        )
                                    ),

                                    Divider(),

                                    // SET SESSION MODE
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Gap(context).gap(16),
                                            vertical: Gap(context).gap(10)
                                        ),
                                        child: Column(
                                            children: [
                                                // Row(
                                                //     children: [
                                                //         Text(
                                                //             'Mode',
                                                //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                //                 color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                //                 fontWeight: FontWeight.w500
                                                //             )
                                                //         ),
                                                //         SizedBox(width: Gap(context).gap(20)),
                                                //         Expanded(
                                                //             child: segmentedButtons(
                                                //                 context,
                                                //                 configuration.mode,
                                                //                 ExpertiseModeEnum.values,
                                                //                 (option) => updateConfiguration(configuration.copyWith(mode: option))
                                                //             )
                                                //         )
                                                //     ]
                                                // ),
                                                // SizedBox(height: Gap(context).gap(5)),
                                                // Align(
                                                //     alignment: Alignment.centerRight,
                                                //     child: Text('Only play at 100% accuracy (Stop on a Error)',
                                                //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                //             color: getFigmaColor(context, 'State Layers/On Background/Opacity-60')
                                                //         )
                                                //     )
                                                // ),
                                                // SizedBox(height: Gap(context).gap(15)),
                                                BlindMode(
                                                    config: configuration,
                                                    updateConfiguration: (config) => updateBlindMode()
                                                )
                                            ]
                                        )
                                    ),

                                    // Divider(),

                                    // SET TEXT LENGTH
                                    // Padding(
                                    //     padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10)),
                                    //     child: Row(
                                    //         children: [
                                    //             Text(
                                    //                 'Text Length',
                                    //                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    //                     color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                    //                     fontWeight: FontWeight.w500
                                    //                 )
                                    //             ),
                                    //             SizedBox(width: Gap(context).gap(20)),
                                    //             Expanded(
                                    //                 child: segmentedButtons(
                                    //                     context,
                                    //                     configuration.contentLength,
                                    //                     TextLengthEnum.values,
                                    //                     (option) => updateConfiguration(configuration.copyWith(contentLength: option))
                                    //                 )
                                    //             )
                                    //         ]
                                    //     )
                                    // ),
                                    Divider(),

                                    // TEXT SIZE
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Gap(context).gap(16),
                                            vertical: Gap(context).gap(10)
                                        ),
                                        child: Row(
                                            children: [
                                                Text(
                                                    'Text Size',
                                                    style: Theme.of(context).textTheme.bodyMedium
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Surface Variant'
                                                            ),
                                                            fontWeight: FontWeight.w500
                                                        )
                                                ),
                                                SizedBox(width: Gap(context).gap(20)),
                                                Expanded(
                                                    child: SegmentedButtons(
                                                        selected: configuration.contentFontSize,
                                                        iterable: TextSizeEnum.values,
                                                        onSelected: (option) =>
                                                        updateContentFontSize(option)
                                                    )
                                                )
                                            ]
                                        )
                                    ),

                                    Divider(),

                                    // LIVE STATS
                                    SwitchSettingsCard(
                                        cardTitle: "Show Live Stats",
                                        options: liveStats,
                                        config: configuration,
                                        updateCofiguration: (config) =>
                                        {} // Options handle their own updates
                                    ),

                                    SizedBox(height: 10),

                                    // ASSISTANCE OPTION
                                    SwitchSettingsCard(
                                        cardTitle: "Assistance Options",
                                        options: assistanceOptions,
                                        config: configuration,
                                        updateCofiguration: (config) =>
                                        {} // Options handle their own updates
                                    ),

                                    SizedBox(height: 10),

                                    // ASSISTANCE OPTION
                                    SwitchSettingsCard(
                                        cardTitle: "Feedbacks",
                                        options: feedbacks,
                                        config: configuration,
                                        updateCofiguration: (config) =>
                                        {} // Options handle their own updates
                                    )
                                ]
                            )
                        )
                    )
                ]
            )
        );
    }
}

/// Dialog to inform about sound feedback with fallback mechanism
class _SystemSoundCheckDialog extends StatefulWidget {
    @override
    State<_SystemSoundCheckDialog> createState() =>
    _SystemSoundCheckDialogState();
}

class _SystemSoundCheckDialogState extends State<_SystemSoundCheckDialog> {
    AudioPlayer? _fallbackAudioPlayer;
    bool _fallbackAudioLoaded = false;

    @override
    void initState() {
        super.initState();
        _initializeFallbackAudio();
    }

    @override
    void dispose() {
        _fallbackAudioPlayer?.dispose();
        super.dispose();
    }

    Future<void> _initializeFallbackAudio() async {
        try {
            _fallbackAudioPlayer = AudioPlayer();
            await _fallbackAudioPlayer!.setAsset(
                'assets/sounds/single keypad click.wav'
            );
            setState(() {
                    _fallbackAudioLoaded = true;
                });
        } catch (e) {
            setState(() {
                    _fallbackAudioLoaded = false;
                });
        }
    }

    void _playTestSound() {
        // Try system sound first
        try {
            SystemSound.play(SystemSoundType.click);
        } catch (e) {
            // Fallback to custom sound
            _playFallbackSound();
        }
    }

    void _playFallbackSound() {
        if (_fallbackAudioLoaded && _fallbackAudioPlayer != null) {
            try {
                _fallbackAudioPlayer!.seek(Duration.zero);
                _fallbackAudioPlayer!.play().catchError((e) {
                        // Ignore playback errors
                    });
            } catch (e) {
                // Ignore errors
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        final isAndroid = Platform.isAndroid;

        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        // Icon
                        Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle
                            ),
                            child: Icon(
                                Icons.volume_up,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary
                            )
                        ),
                        SizedBox(height: 24),

                        // Title
                        Text(
                            'Typing Sound Feedback',
                            style: Theme.of(
                                context
                            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center
                        ),
                        SizedBox(height: 16),

                        // Message - Updated to mention fallback
                        Text(
                            'Typing sounds will play on each keystroke. The app will try system sounds first, and automatically use a fallback sound if system sounds are unavailable.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center
                        ),
                        SizedBox(height: 12),

                        // Platform-specific info
                        if (isAndroid) ...[
                            Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Theme.of(
                                        context
                                    ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text(
                                    'Note: System sounds on Android may not work in all cases. The fallback sound will ensure you always get audio feedback.',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(
                                            context
                                        ).colorScheme.onSurface.withOpacity(0.7)
                                    ),
                                    textAlign: TextAlign.left
                                )
                            )
                        ] else ...[
                            Text(
                                'If you don\'t hear the test sound, the fallback will automatically activate during typing.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(
                                        context
                                    ).colorScheme.onSurface.withOpacity(0.7)
                                ),
                                textAlign: TextAlign.center
                            )
                        ],
                        SizedBox(height: 24),

                        // Test sound button
                        OutlinedButton.icon(
                            onPressed: _playTestSound,
                            icon: Icon(Icons.play_arrow),
                            label: Text('Test Sound'),
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                            )
                        ),
                        SizedBox(height: 16),

                        // OK button
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                    )
                                ),
                                child: Text('Got it')
                            )
                        )
                    ]
                )
            )
        );
    }
}
