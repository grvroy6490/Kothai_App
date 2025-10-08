import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/config_switch_option.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/text_size_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/blind_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/segmented_buttons.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/settings_title_bar.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/switch_settings_card.dart';

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

        void updateTypingSound() {
            ref.read(practiceConfigurationProvider.notifier).toggleSound();
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
                }),
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

                                    Divider(),

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
