
import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/streak_badge.dart';

class WeekilyStreakDisplay extends StatefulWidget {
    const WeekilyStreakDisplay({super.key});

    @override
    State<WeekilyStreakDisplay> createState() => _WeekilyStreakDisplayState();
}

class _WeekilyStreakDisplayState extends State<WeekilyStreakDisplay> {
    final completedDays = [1, 3, 5];
    
    @override
    Widget build(BuildContext context) {
        return Column(
            children: [
                // STREAK BADGES
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                        // Example: make day 4 completed, day 5 expanded
                        return StreakBadge(
                            completed: completedDays.contains(index),
                            isCollapsed: index == 4 ? false : true,
                        );
                    }),
                ),

                SizedBox(height: Gap(context).gap(5),),

                // BOTTOM TEXT
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: KxScale(context).sp(12)
                        ).copyWith(
                            color: getFigmaColor(context, 'Schemes/Secondary Container')
                        ),
                        children: [
                            const TextSpan(text: 'Only '),
                            TextSpan(
                                text: '2 more days',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                )
                            ),
                            const TextSpan(text: ' to earn the '),
                            TextSpan(
                                text: 'Week Warrior badge!',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                )
                            ),
                        ]
                    )
                )
            ]
        );
    }
}
