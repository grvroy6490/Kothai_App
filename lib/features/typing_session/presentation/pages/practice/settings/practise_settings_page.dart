
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/config_switch_option.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/expertise_mode_enums.dart';
import 'package:kothai_app/features/typing_session/domain/enums/text_length_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/text_size_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practise_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/blind_modee.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/segmented_buttons.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/setting_title_bar.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/switch_setting_card.dart';

class PracticeSettingsPage extends ConsumerStatefulWidget {
    const PracticeSettingsPage({super.key});

    @override
    ConsumerState<PracticeSettingsPage> createState() => _PracticeSettingsPageState();
}

class _PracticeSettingsPageState extends ConsumerState<PracticeSettingsPage> {

    @override
    Widget build(BuildContext context) {
        final config = ref.watch(practiceConfigurationProvider);

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

        final liveStats = <ConfigSwitchOption>[
            ConfigSwitchOption(title: 'WPM', select: (c) => c.wpmEnabled, toggle: (c) => c.copyWith(wpmEnabled: !c.wpmEnabled)),
            ConfigSwitchOption(title: 'Accuracy', select: (c) => c.accuracyEnabled, toggle: (c) => c.copyWith(accuracyEnabled: !c.accuracyEnabled)),
            ConfigSwitchOption(title: 'Time', select: (c) => c.timerEnabled, toggle: (c) => c.copyWith(timerEnabled: !c.timerEnabled)),
            // ConfigSwitchOption(title: 'Errors', select: (c) => c.errorsEnabled, toggle: (c) => c.copyWith(errorsEnabled: !c.errorsEnabled))
        ];

        final assistanceOptions = <ConfigSwitchOption>[
            ConfigSwitchOption(title: 'Allow Take Backs', select: (c) => c.allowTakeBacks, toggle: (c) => c.copyWith(allowTakeBacks: !c.allowTakeBacks)),
            ConfigSwitchOption(title: 'Allow Pause', select: (c) => c.allowPauses, toggle: (c) => c.copyWith(allowPauses: !c.allowPauses))
        ];


        final feedbacks = <ConfigSwitchOption>[
          // ConfigSwitchOption(title: 'Sound on Typing', select: (c) => c.soundEnabled, toggle: (c) => c.copyWith(soundEnabled: !c.soundEnabled)),
          // ConfigSwitchOption(title: 'Sound on Error', select: (c) => c.soundOnError, toggle: (c) => c.copyWith(soundOnError: !c.soundOnError)),
          ConfigSwitchOption(title: 'Typing Vibration', select: (c) => c.hapticEnabled, toggle: (c) => c.copyWith(hapticEnabled: !c.hapticEnabled)),
          ConfigSwitchOption(title: 'Error Vibration', select: (c) => c.hapticOnError, toggle: (c) => c.copyWith(hapticOnError: !c.hapticOnError))
        ];


        // 👇 HANDLE UPDATE SETTING
        void updateConfiguration(PracticeConfig config){
            ref.read(practiceConfigurationProvider.notifier).replace(config);
        }

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
                    settingsTitleBar(context),

                    Expanded(
                        child: SingleChildScrollView(
                            padding: EdgeInsets.only(bottom: Gap(context).gap(8)),
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                                children: [
                                    // SET DIFFICULTY
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10)),
                                        child: Row(
                                            children: [
                                                Text(
                                                    'Difficulty',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                        fontWeight: FontWeight.w500
                                                    )
                                                ),
                                                SizedBox(width: Gap(context).gap(20)),
                                                Expanded(
                                                    child: segmentedButtons(
                                                        context, 
                                                        configuration.difficulty, 
                                                        DifficultyEnum.values, 
                                                        (option) => updateConfiguration(configuration.copyWith(difficulty: option))
                                                    )
                                                )
                                            ]
                                        )
                                    ),

                                    Divider(),

                                    // SET SESSION MODE
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10)),
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

                                                blindMode(context, configuration, updateConfiguration)

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
                                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10)),
                                        child: Row(
                                            children: [
                                                Text(
                                                    'Text Size',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                        fontWeight: FontWeight.w500
                                                    )
                                                ),
                                                SizedBox(width: Gap(context).gap(20)),
                                                Expanded(
                                                    child: segmentedButtons(
                                                        context,
                                                        configuration.contentFontSize,
                                                        TextSizeEnum.values,
                                                        (option) => updateConfiguration(configuration.copyWith(contentFontSize: option))
                                                    )
                                                )
                                            ]
                                        )
                                    ),

                                    Divider(),

                                    // LIVE STATS
                                    switchSettinsCard(
                                        context,
                                        "Show Live Stats",
                                        liveStats,
                                        configuration,
                                        updateConfiguration
                                    ),

                                    SizedBox(height: 10),

                                    // ASSISTANCE OPTION
                                    switchSettinsCard(
                                        context,
                                        "Assistance Options",
                                        assistanceOptions,
                                        configuration,
                                        updateConfiguration
                                    ),

                                    SizedBox(height: 10),

                                    // ASSISTANCE OPTION
                                    switchSettinsCard(
                                        context,
                                        "Feedbacks",
                                        feedbacks,
                                        configuration,
                                        updateConfiguration
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








