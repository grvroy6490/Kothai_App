import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/di/providers/theme/theme_provider.dart';
import 'package:visai/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/bottom_navigation_bar.dart';
import 'package:visai/features/user_profile/presentation/widgets/badge_display.dart';
import 'package:visai/features/user_profile/presentation/widgets/user_badge_gallery.dart';
import 'package:visai/presentation/shared/app_bar_compact.dart';

class StreakBoardPage extends ConsumerStatefulWidget {
    const StreakBoardPage({super.key});

    @override
    ConsumerState<StreakBoardPage> createState() => _StreakBoardPageState();
}

class _StreakBoardPageState extends ConsumerState<StreakBoardPage> {
    DateTime _selectedMonth = DateTime.now();

    @override
    Widget build(BuildContext context) {
        final badges = ref.read(badgeControllerProvider);
        final streak = ref.watch(streakControllerProvider);
        ref.watch(themeProvider);

        // Create a set of completed dates for quick lookup
        final completedDates = streak.streakCompleted
            .map((item) => item.date)
            .toSet();

        // Calculate month statistics
        final monthStats = _calculateMonthStats(_selectedMonth, completedDates);

        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
            appBar: AppBarCompact(leading: true, title: 'Streak Board'),
            bottomNavigationBar: BottomNavigationBarWidget(),

            body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.only(
                            top: Gap(context).gap(10),
                            left: Gap(context).gap(10),
                            right: Gap(context).gap(10)
                        ),
                        decoration: BoxDecoration(
                            color: getFigmaColor(
                                context,
                                'Schemes/Surface Container Highest'
                            ),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                        ),
                        child: Column(
                            children: [
                                BadgeDisplay(),

                                SizedBox(height: Gap(context).gap(15)),

                                // Calendar Widget
                                Container(
                                    width: double.infinity,

                                    decoration: BoxDecoration(
                                        color: getFigmaColor(
                                            context,
                                            'Schemes/Surface Container Lowest'
                                        ),
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: Column(
                                        children: [
                                            // Month Navigation
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Gap(context).gap(12),
                                                    vertical: Gap(context).gap(5)
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Expanded(
                                                            child: Text(
                                                                'Streak Calendar',
                                                                style: Theme.of(context).textTheme.titleMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/On Surface'
                                                                        ),
                                                                        fontWeight: FontWeight.bold
                                                                    )
                                                            )
                                                        ),

                                                        IconButton(
                                                            icon: Icon(Icons.chevron_left),
                                                            onPressed: () {
                                                                setState(() {
                                                                        _selectedMonth = DateTime(
                                                                            _selectedMonth.year,
                                                                            _selectedMonth.month - 1
                                                                        );
                                                                    });
                                                            },
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Surface'
                                                            )
                                                        ),
                                                        Text(
                                                            '${_getMonthName(_selectedMonth.month)} ${_selectedMonth.year}',
                                                            style: Theme.of(context).textTheme.titleMedium
                                                                ?.copyWith(
                                                                    color: getFigmaColor(
                                                                        context,
                                                                        'Schemes/On Surface'
                                                                    ),
                                                                    fontWeight: FontWeight.bold
                                                                )
                                                        ),
                                                        IconButton(
                                                            icon: Icon(Icons.chevron_right),
                                                            onPressed: () {
                                                                setState(() {
                                                                        _selectedMonth = DateTime(
                                                                            _selectedMonth.year,
                                                                            _selectedMonth.month + 1
                                                                        );
                                                                    });
                                                            },
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Surface'
                                                            )
                                                        )
                                                    ]
                                                )
                                            ),
                                            SizedBox(height: Gap(context).gap(10)),

                                            Container(
                                                color: getFigmaColor(context, 'Schemes/On Secondary'),
                                                child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Gap(context).gap(12),
                                                        vertical: Gap(context).gap(8)
                                                    ),
                                                    child: Row(
                                                        children: [
                                                            Expanded(
                                                                child: Text(
                                                                    '${monthStats['completedDays']} of ${monthStats['totalDays']} days completed',
                                                                    style: Theme.of(context).textTheme.bodyMedium
                                                                        ?.copyWith(
                                                                            color: getFigmaColor(
                                                                                context,
                                                                                'Schemes/Secondary'
                                                                            )
                                                                        )
                                                                )
                                                            ),
                                                            Text(
                                                                '${monthStats['completionPercentage']}% completion',
                                                                style: Theme.of(context).textTheme.bodyMedium
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/Secondary'
                                                                        )
                                                                    )
                                                            )
                                                        ]
                                                    )
                                                )
                                            ),

                                            SizedBox(height: Gap(context).gap(10)),

                                            // Calendar Grid
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Gap(context).gap(12),
                                                    vertical: Gap(context).gap(5)
                                                ),
                                                child: _buildCalendarGrid(
                                                    _selectedMonth,
                                                    completedDates,
                                                    monthStats
                                                )
                                            ),

                                            SizedBox(height: Gap(context).gap(10)),

                                            Divider(
                                                color: getFigmaColor(
                                                    context,
                                                    'Schemes/Outline Variant'
                                                ),
                                                thickness: 1
                                            ),

                                            // Legend
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: Gap(context).gap(10)
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                        _buildLegendItem('Completed', true, false),
                                                        SizedBox(width: Gap(context).gap(20)),
                                                        _buildLegendItem('Missed', false, false),
                                                        SizedBox(width: Gap(context).gap(20)),
                                                        _buildLegendItem('Today', false, true)
                                                    ]
                                                )
                                            ),

                                            SizedBox(height: Gap(context).gap(10))
                                        ]
                                    )
                                ),

                                SizedBox(height: Gap(context).gap(15)),

                                UserBadgeGallery(badges: badges),

                                SizedBox(height: Gap(context).gap(30))
                            ]
                        )
                    )
                )
            )
        );
    }

    String _getMonthName(int month) {
        const months = [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December'
        ];
        return months[month - 1];
    }

    Map<String, dynamic> _calculateMonthStats(
        DateTime month,
        Set<String> completedDates
    ) {
        final lastDay = DateTime(month.year, month.month + 1, 0);
        final daysInMonth = lastDay.day;
        final today = DateTime.now();
        final isCurrentMonth =
            month.year == today.year && month.month == today.month;

        int completedDays = 0;

        for (int day = 1; day <= daysInMonth; day++) {
            final date = DateTime(month.year, month.month, day);
            final dateString =
                '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

            if (completedDates.contains(dateString)) {
                completedDays++;
            }
        }

        // Total days to count (only count days up to today if current month)
        final totalDays = isCurrentMonth ? today.day : daysInMonth;
        final completionPercentage = totalDays > 0
            ? ((completedDays / totalDays) * 100).round()
            : 0;

        return {
            'completedDays': completedDays,
            'totalDays': totalDays,
            'completionPercentage': completionPercentage
        };
    }

    Widget _buildCalendarGrid(
        DateTime month,
        Set<String> completedDates,
        Map<String, dynamic> monthStats
    ) {
        final firstDay = DateTime(month.year, month.month, 1);
        final lastDay = DateTime(month.year, month.month + 1, 0);
        // Convert weekday: DateTime.weekday is 1=Monday, 7=Sunday
        // We want 0=Sunday, 1=Monday, ..., 6=Saturday
        final firstDayWeekday = firstDay.weekday % 7; // 0 = Sunday, 6 = Saturday
        final daysInMonth = lastDay.day;
        final today = DateTime.now();
        final todayDateOnly = DateTime(today.year, today.month, today.day);
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        // Weekday headers (starting with Sunday to match design)
        const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

        return Column(
            children: [
                // Weekday headers
                Row(
                    children: weekdays
                        .map(
                            (day) => Expanded(
                                child: Center(
                                    child: Text(
                                        day,
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: getFigmaColor(
                                                context,
                                                'Schemes/On Surface Variant'
                                            ),
                                            fontWeight: FontWeight.w600
                                        )
                                    )
                                )
                            )
                        )
                        .toList()
                ),
                SizedBox(height: Gap(context).gap(8)),

                // Calendar days
                ...List.generate(6, (weekIndex) {
                        return Padding(
                            padding: EdgeInsets.only(bottom: Gap(context).gap(4)),
                            child: Row(
                                children: List.generate(7, (dayIndex) {
                                        final dayNumber =
                                            (weekIndex * 7) + dayIndex - (firstDayWeekday - 1) + 1;

                                        if (dayNumber < 1 || dayNumber > daysInMonth) {
                                            return Expanded(child: SizedBox());
                                        }

                                        final date = DateTime(month.year, month.month, dayNumber);
                                        final dateString =
                                            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                        final dateOnly = DateTime(date.year, date.month, date.day);
                                        final isCompleted = completedDates.contains(dateString);
                                        final isToday = dateOnly.isAtSameMomentAs(todayDateOnly);
                                        final isPast = dateOnly.isBefore(todayDateOnly);
                                        final isMissed = isPast && !isCompleted && !isToday;

                                        // Determine background color and text color
                                        Color? backgroundColor;
                                        Color textColor;

                                        if (isToday) {
                                            backgroundColor = Colors.white;
                                            textColor = isDarkMode ? getFigmaColor(context, 'Schemes/Secondary') : Colors.white;
                                        } else if (isCompleted) {
                                            backgroundColor = getFigmaColor(
                                                context,
                                                'Schemes/Secondary'
                                            );
                                            textColor = Colors.white;
                                        } else if (isMissed) {
                                            backgroundColor = getFigmaColor(
                                                context,
                                                'Schemes/Outline'
                                            );
                                            textColor = Colors.white;
                                        } else {
                                            backgroundColor = null;
                                            textColor = getFigmaColor(
                                                context,
                                                'Schemes/Outline'
                                            );
                                        }

                                        return Expanded(
                                            child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 2),
                                                height: Gap(context).gap(40),
                                                decoration: BoxDecoration(
                                                    color: backgroundColor,
                                                    shape: BoxShape.circle,
                                                    border: isToday
                                                        ? Border.all(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/Secondary'
                                                            ),
                                                            width: 2
                                                        )
                                                        : null
                                                ),
                                                child: Center(
                                                    child: Text(
                                                        dayNumber.toString(),
                                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                            color: textColor,
                                                            fontWeight: isToday
                                                                ? FontWeight.bold
                                                                : FontWeight.normal
                                                        )
                                                    )
                                                )
                                            )
                                        );
                                    })
                            )
                        );
                    })
            ]
        );
    }

    Widget _buildLegendItem(String label, bool isCompleted, bool isToday) {
        Color? backgroundColor;
        Color? borderColor;

        if (isToday) {
            backgroundColor = Colors.white;
            borderColor = getFigmaColor(context, 'Schemes/Secondary');
        } else if (isCompleted) {
            backgroundColor = getFigmaColor(context, 'Schemes/Secondary');
            borderColor = null;
        } else {
            backgroundColor = getFigmaColor(context, 'Schemes/Outline');
            borderColor = null;
        }

        return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                        border: borderColor != null
                            ? Border.all(color: borderColor, width: 2)
                            : null
                    )
                ),
                SizedBox(width: Gap(context).gap(6)),
                Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: getFigmaColor(context, 'Schemes/On Surface')
                    )
                )
            ]
        );
    }
}
