import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';
import 'package:visai/features/user_profile/presentation/widgets/stats_card.dart';
import 'package:visai/features/user_profile/presentation/riverpod/providers/user_stats_provider.dart';
import 'package:logger/logger.dart';

class UserScore extends ConsumerStatefulWidget {
    const UserScore({super.key});

    @override
    ConsumerState<UserScore> createState() => _UserScoreState();
}

class _UserScoreState extends ConsumerState<UserScore> {
    final _logger = Logger();

    @override
    Widget build(BuildContext context) {
        final streak = ref.read(streakControllerProvider);
        final statsAsync = ref.watch(userStatsProvider);

        statsAsync.when(
            data: (stats) {
                _logger.d('UserStats: '
                    'bestWpm=${stats.bestWpm}, '
                    'bestAccuracy=${stats.bestAccuracy}, '
                    'achievements=${stats.achievements}, '
                    'challengesCompleted=${stats.challengesCompleted}, '
                    'practiceSessions=${stats.practiceSessions}');
                return null;
            },
            loading: () {
                _logger.d('UserStats: loading');
                return null;
            },
            error: (error, stack) {
                _logger.e('UserStats error: $error');
                return null;
            },
        );

        return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: getFigmaColor(context, 'Schemes/Surface Container')
            ),
            padding: EdgeInsets.symmetric(
                horizontal: Gap(context).gap(12),
                vertical: Gap(context).gap(10)
            ),
            child: statsAsync.when(
                data: (stats) => Column(
                    spacing: 10,
                    children: [
                        Row(
                            spacing: 10,
                            children: [
                                Expanded(
                                    child: StatCard(
                                        value: stats.bestWpm.toStringAsFixed(0),
                                        label: 'Best WPM',
                                        icon: Icons.bolt
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: '${stats.bestAccuracy.toStringAsFixed(1)}%',
                                        label: 'Best Accuracy',
                                        icon: Icons.gps_fixed
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: stats.achievements.toString(),
                                        label: 'Achievements',
                                        icon: Icons.military_tech
                                    )
                                )
                            ]
                        ),
                        Row(
                            spacing: 10,
                            children: [
                                Expanded(
                                    child: StatCard(
                                        value: stats.challengesCompleted.toString(),
                                        label: 'Challenges Completed',
                                        icon: Icons.done_all
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: stats.practiceSessions.toString(),
                                        label: 'Practise Sessions',
                                        icon: Icons.keyboard
                                    )
                                )
                            ]
                        )
                    ]
                ),
                loading: () => Column(
                    spacing: 10,
                    children: [
                        Row(
                            spacing: 10,
                            children: [
                                Expanded(
                                    child: StatCard(
                                        value: '...',
                                        label: 'Best WPM',
                                        icon: Icons.bolt
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: '...',
                                        label: 'Best Accuracy',
                                        icon: Icons.gps_fixed
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: '...',
                                        label: 'Achievements',
                                        icon: Icons.military_tech
                                    )
                                )
                            ]
                        ),
                        Row(
                            spacing: 10,
                            children: [
                                Expanded(
                                    child: StatCard(
                                        value: '...',
                                        label: 'Challenges Completed',
                                        icon: Icons.done_all
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: '...',
                                        label: 'Practise Sessions',
                                        icon: Icons.keyboard
                                    )
                                )
                            ]
                        )
                    ]
                ),
                error: (error, stack) => Column(
                    spacing: 10,
                    children: [
                        Row(
                            spacing: 10,
                            children: [
                                Expanded(
                                    child: StatCard(
                                        value: '0',
                                        label: 'Best WPM',
                                        icon: Icons.bolt
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: '0',
                                        label: 'Best Accuracy',
                                        icon: Icons.gps_fixed
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: '0',
                                        label: 'Achievements',
                                        icon: Icons.military_tech
                                    )
                                )
                            ]
                        ),
                        Row(
                            spacing: 10,
                            children: [
                                Expanded(
                                    child: StatCard(
                                        value: '0',
                                        label: 'Challenges Completed',
                                        icon: Icons.done_all
                                    )
                                ),
                                Expanded(
                                    child: StatCard(
                                        value: '0',
                                        label: 'Practise Sessions',
                                        icon: Icons.keyboard
                                    )
                                )
                            ]
                        )
                    ]
                )
            )
        );
    }
}
