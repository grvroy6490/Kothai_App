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

  /// Get the last 7 days completion status (oldest to newest)
  static List<bool> getLast7DaysCompletion(Set<String> completedDays) {
    return getLast7Days().map((day) => completedDays.contains(day)).toList();
  }
}
