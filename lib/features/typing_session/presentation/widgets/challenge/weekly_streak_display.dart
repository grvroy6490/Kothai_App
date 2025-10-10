import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
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
    // 📃 DECLARATION ----------------------------

    @override
    Widget build(BuildContext context) {
        // ⭐ Widget ---------------------------------
        return Consumer(
            builder: (context, ref, _) {
                final streak = ref.watch(streakControllerProvider);
                // _logger.f('Current streak: ${streak.current}');
                // _logger.f('Completed days: ${streak.completedDays}');

                // Get last 7 days completion status (oldest to newest)
                final last7 = StreakUtils.getLast7DaysCompletion(streak.completedDays);

                // Reverse the array so UI shows from left to right (newest to oldest)
                final reversedLast7 = last7.reversed.toList();

                // _logger.f('Last 7 days completion (original): $last7');
                // _logger.f('Last 7 days completion (reversed): $reversedLast7');
                // _logger.f('Current streak: ${streak.current}');
                // _logger.f('Completed days set: ${streak.completedDays}');

                // Debug: Show which days are completed
                final last7Days = StreakUtils.getLast7Days();
                // for (int i = 0; i < 7; i++) {
                //     _logger.f('Day $i (${last7Days[i]}): completed=${last7[i]}');
                // }

                // Days remaining to reach 7-day streak (bounded 0..7)
                final currentForGoal = streak.current.clamp(0, 7);
                final daysRemaining = (7 - currentForGoal).clamp(0, 7);

                return Column(
                    children: [
                        // STREAK BADGES
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (index) {
                                    // Find the first completed day to make it non-collapsed
                                    // If no streak, make the first day (index 0) non-collapsed
                                    final firstCompletedIndex = reversedLast7.indexWhere(
                                        (completed) => completed
                                    );
                                    final shouldExpand = firstCompletedIndex == -1
                                        ? index ==
                                            0 // No streak, expand first day
                                        : index ==
                                            firstCompletedIndex; // Expand first completed day

                                    // Calculate the day number based on streak position
                                    // The day number should represent the streak day (1st, 2nd, etc.)
                                    int dayNumber;
                                    if (streak.current == 0) {
                                        // No streak, show position numbers (1-7)
                                        dayNumber = index;
                                    } else {
                                        // For streaks, calculate which day in the streak this represents
                                        if (reversedLast7[index]) {
                                            // This day is completed, find its position in the streak
                                            int streakPosition = 0;
                                            for (int i = 0; i <= index; i++) {
                                                if (reversedLast7[i]) streakPosition++;
                                            }
                                            dayNumber =
                                            streakPosition - 1; // Convert to 0-based for display
                                        } else {
                                            // This day is not completed, show next available position
                                            int completedBeforeThis = 0;
                                            for (int i = 0; i < index; i++) {
                                                if (reversedLast7[i]) completedBeforeThis++;
                                            }
                                            dayNumber = completedBeforeThis;
                                        }
                                    }

                                    // _logger.f(
                                    //   'Badge $index: completed=${reversedLast7[index]}, dayNumber=$dayNumber, shouldExpand=$shouldExpand',
                                    // );

                                    return StreakBadge(
                                        completed: reversedLast7[index],
                                        day: dayNumber, // Use calculated day number
                                        isCollapsed: !shouldExpand
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
