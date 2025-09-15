
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/metrics_info_badge.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/metrics_stats_badge.dart';

class PracticeMetricsBar extends ConsumerStatefulWidget {
    const PracticeMetricsBar({super.key});

    @override
    ConsumerState<PracticeMetricsBar> createState() => _PracticeMetricsBarState();
}

class _PracticeMetricsBarState extends ConsumerState<PracticeMetricsBar> {
    late bool startMetrics;

    @override
    void initState() {
        super.initState();
        startMetrics = false;
    }

    @override
    Widget build(BuildContext context) {
        final practiceStatus = ref.watch(practiceStatusProvider);

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(10)),
            child: AnimatedCrossFade(
                firstChild: Row(
                    children: [
                        Expanded(
                            child: MetricsInfoBadge(
                                label: 'Words',
                                value: '90 (~500 Character)'
                            )
                        ),
                        SizedBox(width: Gap(context).gap(12)),
                        Expanded(
                            child: MetricsInfoBadge(
                                label: 'Avg. Time | 40 WPM',
                                value: '~2 mins 20 secs'
                            )
                        )
                    ]
                ), 
                secondChild: Row(
                    children: [
                        Expanded(
                            child: MetricsStatBadge(
                                value: '40',
                                label: 'WPM'
                            )
                        ),
                        SizedBox(width: Gap(context).gap(7)),
                        Expanded(
                            child: MetricsStatBadge(
                                icon: Icons.my_location,
                                value: '98.6%',
                                label: 'Accuracy'
                            )
                        ),
                        SizedBox(width: Gap(context).gap(7)),
                        Expanded(
                            child: MetricsStatBadge(
                                icon: Icons.schedule,
                                value: '2m 3s',
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
        );
    }
}
