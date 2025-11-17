class StreakUtils {
  /// Convert DateTime to YYYYMMDD format
  static String ymd(DateTime d) {
    final local = d.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    return '$y$m$dd';
  }

  /// Parse YYYYMMDD string to DateTime
  static DateTime? parseYmd(String? ymd) {
    if (ymd == null || ymd.length != 8) return null;
    final y = int.tryParse(ymd.substring(0, 4));
    final m = int.tryParse(ymd.substring(4, 6));
    final d = int.tryParse(ymd.substring(6, 8));
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  /// Check if a date is today
  static bool isToday(String ymd) => ymd == StreakUtils.ymd(DateTime.now());

  /// Check if a date is yesterday
  static bool isYesterday(String ymd) {
    final yest = DateTime.now().toLocal().subtract(const Duration(days: 1));
    return ymd == StreakUtils.ymd(yest);
  }

  /// Get the last 7 days as a list of YYYYMMDD strings (oldest to newest)
  static List<String> getLast7Days() {
    final today = DateTime.now().toLocal();
    return List.generate(7, (index) {
      final day = today.subtract(Duration(days: 6 - index));
      return ymd(day);
    });
  }

  /// Convert date from yyyy-MM-dd to yyyyMMdd format
  static String ymdDashToYmd(String dateDash) {
    return dateDash.replaceAll('-', '');
  }

  /// Convert date from yyyyMMdd to yyyy-MM-dd format
  static String ymdToYmdDash(String ymd) {
    if (ymd.length != 8) return ymd;
    return '${ymd.substring(0, 4)}-${ymd.substring(4, 6)}-${ymd.substring(6, 8)}';
  }

  /// Get the last 7 days completion status (oldest to newest)
  static List<bool> getLast7DaysCompletion(Set<String> completedDays) {
    return getLast7Days().map((day) => completedDays.contains(day)).toList();
  }

  /// Get the 7-day window status as objects (oldest to newest)
  /// Returns: List of maps with 'streak' (int) and 'date' (String) keys
  /// Status: streak > 0 = completed, streak = -1 = missing, streak = 0 = upcoming
  /// Accepts List<StreakCompleted> and windowStartDate (yyyy-MM-dd format)
  static List<Map<String, dynamic>> getLast7DaysStatus(
    List streakCompleted,
    String? windowStartDate,
  ) {
    final now = DateTime.now().toLocal();
    final todayDateOnly = DateTime(now.year, now.month, now.day);

    // If no window start date, return empty/upcoming days
    if (windowStartDate == null) {
      return List.generate(7, (index) {
        return {'streak': 0, 'date': ''};
      });
    }

    // Parse window start date
    final windowStart = DateTime.tryParse(windowStartDate);
    if (windowStart == null) {
      return List.generate(7, (index) {
        return {'streak': 0, 'date': ''};
      });
    }

    // Normalize window start to midnight
    final windowStartOnly = DateTime(
      windowStart.year,
      windowStart.month,
      windowStart.day,
    );

    // Get 7 days starting from window start date (oldest to newest)
    final last7DaysDash = <String>[];
    for (int i = 0; i < 7; i++) {
      final day = windowStartOnly.add(Duration(days: i));
      final y = day.year.toString().padLeft(4, '0');
      final m = day.month.toString().padLeft(2, '0');
      final d = day.day.toString().padLeft(2, '0');
      last7DaysDash.add('$y-$m-$d');
    }

    // Convert streakCompleted to a map for quick lookup (date -> streak)
    final completedDatesMap = <String, int>{};
    for (final item in streakCompleted) {
      final dateStr = item.date as String;
      completedDatesMap[dateStr] = item.streak;
    }

    // Debug: Log the dates being compared (uncomment for debugging)
    // print('DEBUG: Completed dates: $completedDatesMap');
    // print('DEBUG: Last 7 days: $last7DaysDash');
    // print('DEBUG: Today date only: $todayDateOnly');

    // Only mark days as missing if there's an active streak
    final hasActiveStreak = streakCompleted.isNotEmpty;

    return last7DaysDash.asMap().entries.map((entry) {
      final index = entry.key;
      final dayDateDash = entry.value;
      final dayDate = DateTime.tryParse(dayDateDash);
      if (dayDate == null) {
        return {
          'streak': 0,
          'date': dayDateDash,
        }; // Default to upcoming if parsing fails
      }

      // Check if this day is completed
      final streak = completedDatesMap[dayDateDash];
      if (streak != null && streak > 0) {
        // Debug: Log when a day is found as completed (uncomment for debugging)
        // print(
        //   'DEBUG: Day $dayDateDash (index $index) is completed with streak $streak',
        // );
        return {'streak': streak, 'date': dayDateDash}; // Completed
      }

      // Check if this day is in the future (beyond today)
      final dayDateOnly = DateTime(dayDate.year, dayDate.month, dayDate.day);
      final isFuture = dayDateOnly.isAfter(todayDateOnly);

      // If it's a future date, mark as upcoming
      if (isFuture) {
        return {
          'streak': 0,
          'date': dayDateDash,
        }; // Future date, always upcoming
      }

      // Check if this day should be marked as missing
      if (!hasActiveStreak) {
        return {
          'streak': 0,
          'date': dayDateDash,
        }; // No active streak, all are upcoming
      }

      // A day is missing only if it creates a gap between completed days
      // i.e., there are completed days both BEFORE and AFTER this day
      bool hasCompletedBefore = false;
      bool hasCompletedAfter = false;

      // Check days before (older dates, higher indices in the list)
      for (int i = index + 1; i < last7DaysDash.length; i++) {
        if (completedDatesMap.containsKey(last7DaysDash[i]) &&
            completedDatesMap[last7DaysDash[i]]! > 0) {
          hasCompletedBefore = true;
          break;
        }
      }

      // Check days after (newer dates, lower indices in the list)
      for (int i = index - 1; i >= 0; i--) {
        if (completedDatesMap.containsKey(last7DaysDash[i]) &&
            completedDatesMap[last7DaysDash[i]]! > 0) {
          hasCompletedAfter = true;
          break;
        }
      }

      // Mark as missing only if there are completed days on BOTH sides
      // This means the day is in the middle of a broken streak
      if (hasCompletedBefore && hasCompletedAfter) {
        return {'streak': -1, 'date': dayDateDash}; // Missing (gap in streak)
      }

      return {'streak': 0, 'date': dayDateDash}; // Upcoming
    }).toList();
  }
}
