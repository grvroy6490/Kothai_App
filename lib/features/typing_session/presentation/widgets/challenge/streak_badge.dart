
import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class StreakBadge extends StatelessWidget {
    final bool isCollapsed;
    final bool completed;

    const StreakBadge({super.key, this.isCollapsed = true, this.completed = false});

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.all(Gap(context).gap(5)),
            decoration: BoxDecoration(
                color: completed
                    ? getFigmaColor(context, 'State Layers/Secondary/Opacity-16')
                    : getFigmaColor(context, 'State Layers/Background/Opacity-60'),
                borderRadius: BorderRadius.circular(Gap(context).gap(25)),
                border: Border.all(
                    width: 1,
                    color: completed
                        ? Colors.transparent
                        : getFigmaColor(context, 'State Layers/On Background/Opacity-08')
                )
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    ColorFiltered(
                        colorFilter: completed
                            ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                            : const ColorFilter.matrix(<double>[
                                    0.2126, 0.7152, 0.0722, 0, 0, // R
                                    0.2126, 0.7152, 0.0722, 0, 0, // G
                                    0.2126, 0.7152, 0.0722, 0, 0, // B
                                    0,      0,      0,      1, 0 // A
                                ]),
                        child: Image.asset(
                            'assets/images/streak_badge.png',
                            width: Gap(context).gap(22)
                        )
                    ),
                    AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: isCollapsed
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: Gap(context).gap(5),
                                    right: Gap(context).gap(5)
                                ),
                                child: Text(
                                    '5th Day Streak',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/Secondary')
                                    )
                                )
                            )
                    )
                ]
            )
        );
    }
}

