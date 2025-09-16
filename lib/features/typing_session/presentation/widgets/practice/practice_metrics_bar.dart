
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/core/utils/time_utils.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_wpm_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/content/text_providers.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/difficulty/difficulty_criteria_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/metrics/metrics_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practise_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/sessions/session_state/session_state_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/metrics_info_badge.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/metrics_stats_badge.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/toast.dart';

class PracticeMetricsBar extends ConsumerStatefulWidget {
    const PracticeMetricsBar({super.key});

    @override
    ConsumerState<PracticeMetricsBar> createState() => _PracticeMetricsBarState();
}

class _PracticeMetricsBarState extends ConsumerState<PracticeMetricsBar> {
    bool showToast = true;
    String wordsCount = '0 (~0 Character)';
    String avgTime = '~0 mins 0 secs';
    DifficultyWPMEnum wpm = DifficultyWPMEnum.wpmEasy;

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        final practiceStatus = ref.watch(practiceStatusProvider);
        final practiceConfig = ref.watch(practiceConfigurationProvider);
        final engine = ref.watch(sessionStateNotifierProvider);
        final metrics = ref.watch(metricsNotifierProvider);


        // print("wpm " + metrics.wpm.toString());
        // print("cursor " + engine.cursor.toString());
        // print("accuracy " + metrics.accuracy.toString());

        ref.listen(textContentProvider, (prev, next) {
                if (next != null && next != prev) {
                    setState(() {
                            showToast = true;
                            wordsCount = '${next.content.split(' ').length} (~${(next.content.length / 5).round()} Character)';
                            avgTime = '~${(next.content.split(' ').length / 40).round()} mins ${(next.content.split(' ').length % 40 * 1.5).round()} secs';
                        });
                }
            });

        void handleShowToast() {
            setState(() {
                    showToast = true;
                });
            Future.delayed(const Duration(milliseconds: 10000), () {
                    if (mounted) {
                        setState(() {
                                showToast = false;
                            });
                    }
                });
        }

        void hideToast() {
            setState(() {
                    showToast = false;
                });
        }

        return Stack(
            children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10)),
                    child: AnimatedCrossFade(
                        firstChild: Row(
                            children: [
                                Expanded(
                                    child: MetricsInfoBadge(
                                        label: 'Words',
                                        value: wordsCount
                                    )
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
                                        value: practiceConfig.wpmEnabled ? metrics.wpm.toStringAsFixed(0) : '--', // 👈 WPM ENABLED SETTINGS
                                        label: 'WPM'
                                    )
                                ),
                                SizedBox(width: Gap(context).gap(7)),
                                Expanded(
                                    child: MetricsStatBadge(
                                        icon: Icons.my_location,
                                        value: practiceConfig.accuracyEnabled ? '${(metrics.accuracy*100).toStringAsFixed(0)}%' : '--', // 👈 ACCURACY ENABLED SETTINGS
                                        label: 'Accuracy'
                                    )
                                ),
                                SizedBox(width: Gap(context).gap(7)),
                                Expanded(
                                    child: MetricsStatBadge(
                                        icon: Icons.schedule,
                                        value: practiceConfig.timerEnabled ? formatDuration(engine.elapsed) : '--', // 👈 TIMER ENABLED SETTINGS
                                        label: 'Time'
                                    )
                                )
                            ]
                        ),
                        firstCurve: Curves.fastOutSlowIn,
                        secondCurve: Curves.fastOutSlowIn,
                        crossFadeState: practiceStatus == PracticeStatusEnum.start ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
