import 'package:flutter/material.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';

enum StreakBadgeStatus {
    completed, missing, upcoming
}

class StreakBadge extends StatelessWidget {
    final bool isCollapsed;
    final StreakBadgeStatus status;
    final int day;
    final VoidCallback? onTap;

    const StreakBadge({
        super.key,
        this.isCollapsed = true,
        this.status = StreakBadgeStatus.upcoming,
        required this.day,
        this.onTap
    });

    String _getDaySuffix(int day) {
        final dayNumber = day + 1;
        if (dayNumber >= 11 && dayNumber <= 13) {
            return 'th';
        }
        switch (dayNumber % 10) {
            case 1:
                return 'st';
            case 2:
                return 'nd';
            case 3:
                return 'rd';
            default:
            return 'th';
        }
    }

    @override
    Widget build(BuildContext context) {
        // ⭐ Widget ---------------------------------
        final isCompleted = status == StreakBadgeStatus.completed;
        final isMissing = status == StreakBadgeStatus.missing;

        // Determine colors based on status
        Color backgroundColor;
        Color borderColor;
        ColorFilter colorFilter;

        if (isCompleted) {
            backgroundColor = getFigmaColor(
                context,
                'State Layers/Secondary/Opacity-16'
            );
            borderColor = Colors.transparent;
            colorFilter = const ColorFilter.mode(
                Colors.transparent,
                BlendMode.multiply
            );
        } else if (isMissing) {
            // Missing - Black background with red border
            backgroundColor = Colors.black;
            borderColor = Colors.black;
            colorFilter = const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0, // R
                    0.2126, 0.7152, 0.0722, 0, 0, // G
                    0.2126, 0.7152, 0.0722, 0, 0, // B
                    0, 0, 0, 1, 0 // A
                ]);
        } else {
            // Upcoming - Neutral gray (clearly different from missing)
            backgroundColor = getFigmaColor(
                context,
                'State Layers/Background/Opacity-60'
            );
            borderColor = getFigmaColor(
                context,
                'State Layers/On Background/Opacity-08'
            );
            colorFilter = const ColorFilter.matrix(<double>[
                    0.4, 0.4, 0.4, 0, 0, // R - more desaturated
                    0.4, 0.4, 0.4, 0, 0, // G
                    0.4, 0.4, 0.4, 0, 0, // B
                    0, 0, 0, 0.4, 0 // A - more transparent
                ]);
        }

        Widget badgeContent = Container(
            padding: EdgeInsets.all(Gap(context).gap(5)),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(Gap(context).gap(25)),
                border: Border.all(width: 1, color: borderColor)
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    ColorFiltered(
                        colorFilter: colorFilter,
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
                                    '${day + 1}${_getDaySuffix(day)} Day Streak',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: isCompleted
                                            ? getFigmaColor(context, 'Schemes/Secondary')
                                            : isMissing
                                                ? getFigmaColor(context, 'Schemes/Error')
                                                : getFigmaColor(
                                                    context,
                                                    'Schemes/On Surface'
                                                ).withOpacity(0.5)
                                    )
                                )
                            )
                    )
                ]
            )
        );

        // Make missing badges tappable
        if (isMissing && onTap != null) {
            return InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(Gap(context).gap(25)),
                child: badgeContent
            );
        } else {
            return InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(Gap(context).gap(25)),
                child: badgeContent
            );
        }

        // return badgeContent;
    }
}
