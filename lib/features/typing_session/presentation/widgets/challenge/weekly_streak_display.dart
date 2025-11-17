import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/challenge/restore_streak/restore_streak_page.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/streak_badge.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';
import 'package:kothai_app/features/typing_session/utils/streak_utils.dart';
import 'package:logger/logger.dart';

class WeekilyStreakDisplay extends StatefulWidget {
    const WeekilyStreakDisplay({super.key});

    @override
    State<WeekilyStreakDisplay> createState() => _WeekilyStreakDisplayState();
}

class _WeekilyStreakDisplayState extends State<WeekilyStreakDisplay> {
    final _logger = Logger();
    bool _testInitialized = false;
    // 📃 DECLARATION ----------------------------

    void _handleMissingStreakTap(WidgetRef ref, DateTime dayDate) {
        // _logger.f('Tapped on missing streak for date: ${StreakUtils.ymd(dayDate)}');
        Get.to(
            () => RestoreStreakPage(),
            arguments: {"day": dayDate},
            transition: Transition.fade,
            curve: Curves.easeInOut
        );
    }

    @override
    Widget build(BuildContext context) {
        // ⭐ Widget ---------------------------------
        return Consumer(
            builder: (context, ref, _) {
                final streak = ref.watch(streakControllerProvider);
                // _logger.f('Current streak: ${streak.best}');
                // _logger.f('Streak completed: ${streak.streakCompleted.length} items');

                // 🧪 TESTING: Set up test scenario (only run once)
                // Creates: Today completed, yesterday missing, 2 days ago completed, 3 days ago completed, 4 days ago missing, 5 days ago completed
                if (_testInitialized) {
                    _testInitialized = true;
                    Future.microtask(() async {
                            await ref.read(streakControllerProvider.notifier).resetStreak();

                            // Day 1 (today) - completed
                            await ref.read(streakControllerProvider.notifier).markActiveToday();

                            // Day 2 (yesterday) - missing (skip it to create gap)

                            // Day 3 (2 days ago) - completed
                            final twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
                            await ref
                                .read(streakControllerProvider.notifier)
                                .addStreakForDay(twoDaysAgo);

                            // Day 4 (3 days ago) - completed
                            final threeDaysAgo = DateTime.now().subtract(Duration(days: 3));
                            await ref
                                .read(streakControllerProvider.notifier)
                                .addStreakForDay(threeDaysAgo);

                            // Day 5 (4 days ago) - missing (skip it to create gap)

                            // Day 6 (5 days ago) - completed
                            final fiveDaysAgo = DateTime.now().subtract(Duration(days: 5));
                            await ref
                                .read(streakControllerProvider.notifier)
                                .addStreakForDay(fiveDaysAgo);

                            // Day 7 (6 days ago) - upcoming (not added)

                            // _logger.f(
                            //     '✅ Test setup: Today completed, yesterday missing, 2 days ago completed, 3 days ago completed, 4 days ago missing, 5 days ago completed'
                            // );
                        });
                }

                // Get 7-day window status as objects: {streak: int, date: String} (oldest to newest)
                // streak > 0 = completed, streak = -1 = missing, streak = 0 = upcoming
                final last7Status = StreakUtils.getLast7DaysStatus(
                    streak.streakCompleted,
                    streak.windowStartDate
                );

                // _logger.d(last7Status);

                // Reverse the array so UI shows from left to right (newest to oldest)
                final reversedLast7Status = last7Status.toList();

                // Get the actual dates for the 7-day window (newest to oldest)
                final last7Days = <DateTime>[];
                if (streak.windowStartDate != null) {
                    final windowStart = DateTime.tryParse(streak.windowStartDate!);
                    if (windowStart != null) {
                        final windowStartOnly = DateTime(
                            windowStart.year,
                            windowStart.month,
                            windowStart.day
                        );
                        // Generate 7 days from window start (oldest to newest), then reverse
                        last7Days.addAll(
                            List.generate(7, (index) {
                                    return windowStartOnly.add(Duration(days: 6 - index));
                                }).reversed.toList()
                        );
                    }
                }

                // If no window start, generate empty dates
                if (last7Days.isEmpty) {
                    final today = DateTime.now().toLocal();
                    final todayDateOnly = DateTime(today.year, today.month, today.day);
                    last7Days.addAll(
                        List.generate(7, (index) {
                                return todayDateOnly.subtract(Duration(days: 6 - index));
                            }).reversed.toList()
                    );
                }

                // Find today's index in the reversed array (newest to oldest)
                final today = DateTime.now().toLocal();
                final todayDateDash =
                    '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

                // Find today's index in the reversed array
                int todayIndex = reversedLast7Status.indexWhere(
                    (statusObj) => statusObj['date'] == todayDateDash
                );
                if (todayIndex == -1) {
                    // Today is not in the window (window hasn't started or has expired)
                    todayIndex = 0;
                }

                final todayStatusObj = reversedLast7Status[todayIndex];
                final todayStatus = todayStatusObj['streak'] as int;

                // Determine which badge should be expanded
                // Priority: Find the first completed day after today (skipping missing days)
                // If today is completed, find the next completed day after index 0
                int expandIndex;
                if (todayStatus > 0) {
                    // Today is completed, find the first completed day after today (index > 0)
                    final nextCompletedIndex = reversedLast7Status.indexWhere(
                        (statusObj) {
                            final status = statusObj['streak'] as int;
                            return status > 0;
                        },
                        1 // Start searching from index 1 (skip today)
                    );
                    if (nextCompletedIndex != -1) {
                        // Found a completed day after today (e.g., 3rd day at index 2)
                        expandIndex = nextCompletedIndex;
                    } else {
                        // No other completed days, expand today
                        expandIndex = todayIndex;
                    }
                } else {
                    // Today is not completed, find the first completed day
                    final firstCompletedIndex = reversedLast7Status.indexWhere((
                            statusObj
                        ) {
                            final status = statusObj['streak'] as int;
                            return status > 0;
                        });
                    expandIndex = firstCompletedIndex == -1 ? 0 : firstCompletedIndex;
                }

                // _logger.f('Last 7 days status (original): $last7Status');
                // _logger.f('Last 7 days status (reversed): $reversedLast7Status');
                // _logger.f(
                //     'Today index: $todayIndex, Today status: $todayStatus, Expand index: $expandIndex'
                // );
                // _logger.f('Current streak: ${streak.current}');
                // _logger.f(
                //     'Streak completed list: ${streak.streakCompleted.length} items'
                // );

                // Calculate days remaining based on completed days count
                // Count how many days are completed (streak > 0)
                final completedCount = reversedLast7Status.where((statusObj) {
                        final status = statusObj['streak'] as int;
                        return status > 0;
                    }).length;
                final daysRemaining = (7 - completedCount).clamp(0, 7);

                return Column(
                    children: [
                        // STREAK BADGES
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (index) {
                                    // Get status from object: {streak: int, date: String}
                                    final dayStatusObj = reversedLast7Status[index];
                                    final dayStatus = dayStatusObj['streak'] as int;
                                    final isCompleted = dayStatus > 0;
                                    final isMissing = dayStatus == -1;

                                    // Expand the badge at expandIndex
                                    final shouldExpand = index == expandIndex;

                                    // Calculate the day number: index 0 = day 1, index 1 = day 2, etc.
                                    // The day number represents the position in the 7-day window (1-7)
                                    final dayNumber = index;

                                    // Determine badge status from integer status
                                    final dayDate = last7Days[index];
                                    StreakBadgeStatus badgeStatus;
                                    if (isCompleted) {
                                        badgeStatus = StreakBadgeStatus.completed;
                                    } else if (isMissing) {
                                        badgeStatus = StreakBadgeStatus.missing;
                                    } else {
                                        badgeStatus = StreakBadgeStatus.upcoming;
                                    }

                                    // _logger.f(
                                    //   'Badge $index: completed=${reversedLast7[index]}, dayNumber=$dayNumber, shouldExpand=$shouldExpand, status=$badgeStatus',
                                    // );

                                    return SizedBox(
                                        child: StreakBadge(
                                            status: badgeStatus,
                                            day: dayNumber, // Use calculated day number
                                            isCollapsed: !shouldExpand,
                                            onTap: badgeStatus == StreakBadgeStatus.missing
                                                ? () {
                                                    // Handle missing streak tap
                                                    _handleMissingStreakTap(ref, dayDate);
                                                }
                                                : null
                                        )
                                    );
                                })
                        ),

                        SizedBox(height: Gap(context).gap(5)),

                        // BOTTOM TEXT
                        RichText(
                            text: TextSpan(
                                style: TextStyle(fontSize: KxScale(context).sp(12)).copyWith(
                                    color: getFigmaColor(context, 'Schemes/Secondary Container')
                                ),
                                children: [
                                    const TextSpan(text: 'Only '),
                                    TextSpan(
                                        text: daysRemaining == 0
                                            ? '0 more days'
                                            : '$daysRemaining more day${daysRemaining == 1 ? '' : 's'}',
                                        style: const TextStyle(fontWeight: FontWeight.bold)
                                    ),
                                    const TextSpan(text: ' to earn the '),
                                    TextSpan(
                                        text: 'Week Warrior badge!',
                                        style: const TextStyle(fontWeight: FontWeight.bold)
                                    )
                                ]
                            )
                        )
                    ]
                );
            }
        );
    }
}
