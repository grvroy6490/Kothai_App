import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/core/utils/characters_utils.dart';
import 'package:visai/core/utils/time_utils.dart';
import 'package:visai/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_wpm_enum.dart';
// import 'package:visai/features/typing_session/domain/enums/practice_status_enum.dart';
// import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/metrics_info_badge.dart';
import 'package:visai/features/typing_session/presentation/widgets/metrics_stat_badge.dart';
import 'package:visai/features/typing_session/presentation/widgets/toast.dart';
// import 'package:logger/logger.dart';

class MainMetricsBar extends ConsumerStatefulWidget {
    final String paragraph;
    final DifficultyCriteriaEntity? difficulty;

    const MainMetricsBar({
        super.key, 
        required this.paragraph,
        required this.difficulty
    });

    @override
    ConsumerState<MainMetricsBar> createState() => _MainMetricsBarState();
}

class _MainMetricsBarState extends ConsumerState<MainMetricsBar> {
    // 📃 DECLARATION ----------------------------
    bool showToast = false;
    String wordsCount = '0 (~0 Character)';
    String avgTime = '~0 mins 0 secs';
    DifficultyWPMEnum wpm = DifficultyWPMEnum.wpmEasy;
    DifficultyEnum? previousDifficulty;

    // 🔁 INIT STATE METHODS -------------------------
    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        // final _logger = Logger();
        // 🌐 PROVIDERS ------------------------------
        final sessionState = ref.watch(sessionStatusControllerProvider);
        final practiceConfig = ref.watch(practiceConfigurationProvider);
        final sessionEngineController = ref.watch(sessionControllerProvider);
        final metricsStateController = ref.watch(metricsStateControllerProvider);

        // 📃 DECLARATION ----------------------------
        wordsCount = getWordAndCharacter(widget.paragraph);
        avgTime = widget.difficulty != null ? getAverageTime(widget.paragraph, widget.difficulty!) : '~0 mins 0 secs';
        final sessionStatus = sessionState.status;

        // 🚀 METHODS --------------------------------
        // Listen to difficulty changes specifically
        ref.listen(
            practiceConfigurationProvider.select((config) => config.difficulty),
            (prev, next) {
                if (prev != null && prev != next) {
                    setState(() {
                            showToast = true;
                        });

                    // Auto-hide toast after 10 seconds
                    Future.delayed(const Duration(milliseconds: 10000), () {
                            if (mounted) {
                                setState(() {
                                        showToast = false;
                                    });
                            }
                        });
                }
            }
        );

        // Listen to content changes to detect randomize button usage
        ref.listen(textContentControllerProvider, (prev, next) {
                // Only show toast if content changed and we haven't already shown one for difficulty change
                if (next != prev && next != null && !showToast) {
                    setState(() {
                            showToast = true;
                        });

                    // Auto-hide toast after 10 seconds
                    Future.delayed(const Duration(milliseconds: 10000), () {
                            if (mounted) {
                                setState(() {
                                        showToast = false;
                                    });
                            }
                        });
                }
            });

        void hideToast() {
            setState(() {
                    showToast = false;
                });
        }

        // ⭐ Widget ---------------------------------
        return Stack(
            children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Gap(context).gap(16),
                        vertical: Gap(context).gap(10)
                    ),
                    child: AnimatedCrossFade(
                        firstChild: Row(
                            children: [
                                Expanded(
                                    child: MetricsInfoBadge(label: 'Words', value: wordsCount)
                                ),
                                SizedBox(width: Gap(context).gap(12)),
                                Expanded(
                                    child: MetricsInfoBadge(
                                        //label: 'Avg. Time @ ${wpm.wpm} WPM', // TODO: Generate content based on difficulty criteria of WPM
                                        label: 'Average Time',
                                        value: avgTime
                                    )
                                )
                            ]
                        ),
                        secondChild: Row(
                            children: [
                                Expanded(
                                    child: MetricsStatBadge(
                                        value: practiceConfig.wpmEnabled ? metricsStateController.wpm.toStringAsFixed(0) : '--', // 👈 WPM ENABLED SETTINGS // TODO: Show WPM Value here
                                        label: 'WPM'
                                    )
                                ),
                                SizedBox(width: Gap(context).gap(7)),
                                Expanded(
                                    child: MetricsStatBadge(
                                        icon: Icons.my_location,
                                        value: practiceConfig.accuracyEnabled ? '${(metricsStateController.accuracy*100).toStringAsFixed(0)}%' : '--', // 👈 ACCURACY ENABLED SETTINGS // TODO: Show Accuracy Value here
                                        label: 'Accuracy'
                                    )
                                ),
                                SizedBox(width: Gap(context).gap(7)),
                                Expanded(
                                    child: MetricsStatBadge(
                                        icon: Icons.schedule,
                                        value: practiceConfig.timerEnabled ? formatDuration(sessionEngineController.elapsed) : '--', // 👈 TIMER ENABLED SETTINGS // TODO: Show Timer value here
                                        label: 'Time'
                                    )
                                )
                            ]
                        ),
                        firstCurve: Curves.fastOutSlowIn,
                        secondCurve: Curves.fastOutSlowIn,
                        crossFadeState: sessionStatus == SessionStatusEnum.start
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 600)
                    )
                ),

                if (showToast)
                Toast(
                    label: 'New text is created & ready for your practice',
                    bgColor: getFigmaColor(context, 'Palettes/Secondary 90'),
                    textColor: getFigmaColor(context, 'Schemes/Secondary'),
                    showToast: showToast,
                    animationTime: 2,
                    onClosePressed: hideToast,
                    onCompleted: () {
                        // e.g., tell parent to hide it or log analytics
                        setState(() => showToast = false);
                    },
                    onDismissed: () {
                        setState(() => showToast = false);
                    }
                )
            ]
        );
    }
}
