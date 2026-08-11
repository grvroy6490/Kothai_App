import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:logger/logger.dart';
import 'package:visai/services/notifications/local_notification_service.dart';

class StreakCompleted {
  final int streak;
  final String date; // 'yyyy-MM-dd' format

  StreakCompleted({required this.streak, required this.date});

  Map<String, dynamic> toJson() => {'streak': streak, 'date': date};

  factory StreakCompleted.fromJson(Map<String, dynamic> json) =>
      StreakCompleted(
        streak: json['streak'] as int,
        date: json['date'] as String,
      );
}

class StreakState {
  final int current;
  final int best;
  final String? lastYmd; // 'yyyyMMdd'
  final List<StreakCompleted>
  streakCompleted; // List of completed streaks with cap of 7
  final String? windowStartDate; // 'yyyy-MM-dd' - when the 7-day window started

  const StreakState({
    this.current = 0,
    this.best = 0,
    this.lastYmd,
    this.streakCompleted = const [],
    this.windowStartDate,
  });

  StreakState copyWith({
    int? current,
    int? best,
    String? lastYmd,
    List<StreakCompleted>? streakCompleted,
    String? windowStartDate,
  }) => StreakState(
    current: current ?? this.current,
    best: best ?? this.best,
    lastYmd: lastYmd ?? this.lastYmd,
    streakCompleted: streakCompleted ?? this.streakCompleted,
    windowStartDate: windowStartDate ?? this.windowStartDate,
  );
}

class StreakController extends Notifier<StreakState> {
  late final _prefs = ref.read(sharedPrefsServiceProvider);
  final _logger = Logger();

  @override
  StreakState build() {
    final cur = _prefs.getInt(kStreakCurrentKey) ?? 0;
    final best = _prefs.getInt(kStreakBestKey) ?? 0;
    final last = _prefs.getString(kStreakLastYmdKey);
    final windowStart = _prefs.getString(kStreakWindowStartKey);

    // Load streak completed list from JSON
    List<StreakCompleted> streakCompleted = [];
    final streakJson = _prefs.getString(kStreakDaysKey);
    if (streakJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(streakJson);
        streakCompleted = decoded
            .map(
              (item) => StreakCompleted.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } catch (e) {
        _logger.e('Error parsing streak completed: $e');
      }
    }

    return StreakState(
      current: cur,
      best: best,
      lastYmd: last,
      streakCompleted: streakCompleted,
      windowStartDate: windowStart,
    );
  }

  String _ymd(DateTime d) {
    final local = d.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    return '$y$m$dd';
  }

  String _ymdDash(DateTime d) {
    final local = d.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    return '$y-$m-$dd';
  }

  Future<void> _persist(StreakState s) async {
    await _prefs.setInt(kStreakCurrentKey, s.current);
    await _prefs.setInt(kStreakBestKey, s.best);
    if (s.lastYmd != null) {
      await _prefs.setString(kStreakLastYmdKey, s.lastYmd!);
    }
    if (s.windowStartDate != null) {
      await _prefs.setString(kStreakWindowStartKey, s.windowStartDate!);
    }
    // Store streak completed list as JSON
    final streakJson = jsonEncode(
      s.streakCompleted.map((e) => e.toJson()).toList(),
    );
    await _prefs.setString(kStreakDaysKey, streakJson);
  }

  Future<void> markActiveToday() async {
    final today = _ymd(DateTime.now());
    final todayDateDash = _ymdDash(DateTime.now());
    final todayDate = DateTime.now().toLocal();
    final todayDateOnly = DateTime(
      todayDate.year,
      todayDate.month,
      todayDate.day,
    );

    // Check if already completed today
    final existingIndex = state.streakCompleted.indexWhere(
      (item) => item.date == todayDateDash,
    );
    if (existingIndex != -1) {
      // _logger.e('Already completed today: $today');
      return;
    }

    // Check if we need to reset the window (7 days have passed since window start)
    // After this block, `windowStartDate` is guaranteed to be non-null.
    String windowStartDate = state.windowStartDate ?? todayDateDash;
    bool shouldResetWindow = false;

    final windowStart = DateTime.tryParse(windowStartDate);
    if (windowStart != null) {
      final windowStartOnly = DateTime(
        windowStart.year,
        windowStart.month,
        windowStart.day,
      );
      final daysSinceStart =
          todayDateOnly.difference(windowStartOnly).inDays;
      if (daysSinceStart >= 7) {
        // Window expired, reset
        shouldResetWindow = true;
        windowStartDate = todayDateDash; // Start new window from today
      }
    }

    // If window is reset, clear old entries
    List<StreakCompleted> newStreakCompleted;
    if (shouldResetWindow) {
      newStreakCompleted = [];
    } else {
      newStreakCompleted = List<StreakCompleted>.from(state.streakCompleted);
    }

    // Calculate current streak within the window
    int currentStreak = 0;
    final windowStartForStreak = DateTime.tryParse(windowStartDate);
    if (windowStartForStreak != null) {
      final windowStartOnly = DateTime(
        windowStartForStreak.year,
        windowStartForStreak.month,
        windowStartForStreak.day,
      );
      final completedDates = newStreakCompleted.map((e) => e.date).toSet();

      // Count consecutive days from window start
      for (int i = 0; i < 7; i++) {
        final checkDate = windowStartOnly.add(Duration(days: i));
        final checkDateDash = _ymdDash(checkDate);

        if (completedDates.contains(checkDateDash) ||
            (checkDateDash == todayDateDash)) {
          currentStreak++;
        } else {
          break; // Streak broken
        }
      }
    }

    // Add today's entry
    newStreakCompleted.add(
      StreakCompleted(streak: currentStreak, date: todayDateDash),
    );

    // Keep only entries within the current 7-day window
    final windowStartForFilter = DateTime.tryParse(windowStartDate);
    if (windowStartForFilter != null) {
      final windowStartOnly = DateTime(
        windowStartForFilter.year,
        windowStartForFilter.month,
        windowStartForFilter.day,
      );
      final windowDays = <String>[];
      for (int i = 0; i < 7; i++) {
        final day = windowStartOnly.add(Duration(days: i));
        windowDays.add(_ymdDash(day));
      }

      // Keep only entries within the window and sort by date (oldest first)
      final cleanedStreakCompleted = newStreakCompleted
          .where((item) => windowDays.contains(item.date))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      newStreakCompleted = cleanedStreakCompleted;
    }

    // Update best streak if current is better
    final newBest = currentStreak > state.best ? currentStreak : state.best;

    // _logger.f('New streak: $currentStreak (best: $newBest)');
    // _logger.f('Window start: $windowStartDate');

    final next = state.copyWith(
      current: currentStreak,
      best: newBest,
      lastYmd: today,
      streakCompleted: newStreakCompleted,
      windowStartDate: windowStartDate,
    );

    state = next;
    await _persist(next);
    await LocalNotificationService.instance.onPracticedToday(_prefs);
    // _logger.f('Persisted streak: $next');
  }

  Future<void> resetStreak() async {
    state = const StreakState();
    await _prefs.remove(kStreakCurrentKey);
    await _prefs.remove(kStreakBestKey);
    await _prefs.remove(kStreakLastYmdKey);
    await _prefs.remove(kStreakDaysKey);
    await _prefs.remove(kStreakWindowStartKey);
  }

  /// Add a missing day to the streak (fills in a gap)
  /// This is typically called when a user taps on a missing streak badge
  Future<void> addMissingDay(DateTime day) async {
    final dayYmd = _ymd(day);
    final dayDateDash = _ymdDash(day);
    // _logger.f('Adding missing day to streak: $dayYmd');

    // Check if already completed
    final existingIndex = state.streakCompleted.indexWhere(
      (item) => item.date == dayDateDash,
    );
    if (existingIndex != -1) {
      // _logger.f('Day already completed: $dayYmd');
      return;
    }

    // Calculate the streak number for this day
    // Find the highest streak number before this day and add 1
    final dayDate = day.toLocal();
    final dayDateOnly = DateTime(dayDate.year, dayDate.month, dayDate.day);

    // Find the highest streak number from completed days before this date
    int maxStreakBefore = 0;
    for (final item in state.streakCompleted) {
      final itemDate = DateTime.tryParse(item.date);
      if (itemDate != null) {
        final itemDateOnly = DateTime(
          itemDate.year,
          itemDate.month,
          itemDate.day,
        );
        if (itemDateOnly.isBefore(dayDateOnly) &&
            item.streak > maxStreakBefore) {
          maxStreakBefore = item.streak;
        }
      }
    }

    final streakForDay = maxStreakBefore + 1;

    // Create new streak completed list
    final newStreakCompleted = List<StreakCompleted>.from(
      state.streakCompleted,
    );
    newStreakCompleted.add(
      StreakCompleted(streak: streakForDay, date: dayDateDash),
    );

    // Calculate current streak by finding consecutive days from today backwards
    int currentStreak = 0;
    final todayDate = DateTime.now().toLocal();
    final completedDates = newStreakCompleted.map((e) => e.date).toSet();

    for (int i = 0; i < 7; i++) {
      final checkDate = todayDate.subtract(Duration(days: i));
      final checkDateDash = _ymdDash(checkDate);

      if (completedDates.contains(checkDateDash)) {
        currentStreak++;
      } else {
        break; // Streak broken
      }
    }

    // Clean up old entries (keep only last 7 days)
    final last7Days = <String>[];
    for (int i = 0; i < 7; i++) {
      final checkDay = todayDate.subtract(Duration(days: i));
      last7Days.add(_ymdDash(checkDay));
    }

    // Keep only the last 7 days and sort by date (oldest first)
    final cleanedStreakCompleted =
        newStreakCompleted
            .where((item) => last7Days.contains(item.date))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    // Cap at 7 entries
    final cappedStreakCompleted = cleanedStreakCompleted.length > 7
        ? cleanedStreakCompleted.sublist(cleanedStreakCompleted.length - 7)
        : cleanedStreakCompleted;

    // Update best streak if current is better
    final newBest = currentStreak > state.best ? currentStreak : state.best;

    // _logger.f('Missing day added. New streak: $currentStreak (best: $newBest)');
    // _logger.f('Updated streak completed: ${cappedStreakCompleted.length}');

    final next = state.copyWith(
      current: currentStreak,
      best: newBest,
      lastYmd: dayYmd,
      streakCompleted: cappedStreakCompleted,
    );

    state = next;
    await _persist(next);
    // _logger.f('Persisted streak after adding missing day: $next');
  }

  // Method for testing - manually add a streak for a specific day
  Future<void> addStreakForDay(DateTime day) async {
    final dayYmd = _ymd(day);
    final dayDateDash = _ymdDash(day);
    // _logger.e('Manually adding streak for day: $dayYmd');

    // Check if already completed
    final existingIndex = state.streakCompleted.indexWhere(
      (item) => item.date == dayDateDash,
    );
    if (existingIndex != -1) {
      return;
    }

    // Calculate the streak number for this day
    // Find the highest streak number before this day and add 1
    final dayDate = day.toLocal();
    final dayDateOnly = DateTime(dayDate.year, dayDate.month, dayDate.day);

    // Find the highest streak number from completed days before this date
    int maxStreakBefore = 0;
    for (final item in state.streakCompleted) {
      final itemDate = DateTime.tryParse(item.date);
      if (itemDate != null) {
        final itemDateOnly = DateTime(
          itemDate.year,
          itemDate.month,
          itemDate.day,
        );
        if (itemDateOnly.isBefore(dayDateOnly) &&
            item.streak > maxStreakBefore) {
          maxStreakBefore = item.streak;
        }
      }
    }

    final streakForDay = maxStreakBefore + 1;

    // Create new streak completed list
    final newStreakCompleted = List<StreakCompleted>.from(
      state.streakCompleted,
    );
    newStreakCompleted.add(
      StreakCompleted(streak: streakForDay, date: dayDateDash),
    );

    // Calculate current streak by finding consecutive days from today backwards
    int currentStreak = 0;
    final todayDate = DateTime.now().toLocal();
    final completedDates = newStreakCompleted.map((e) => e.date).toSet();

    for (int i = 0; i < 7; i++) {
      final checkDate = todayDate.subtract(Duration(days: i));
      final checkDateDash = _ymdDash(checkDate);

      if (completedDates.contains(checkDateDash)) {
        currentStreak++;
      } else {
        break; // Streak broken
      }
    }

    // Clean up old entries (keep only last 7 days)
    final last7Days = <String>[];
    for (int i = 0; i < 7; i++) {
      final checkDay = todayDate.subtract(Duration(days: i));
      last7Days.add(_ymdDash(checkDay));
    }

    // Keep only the last 7 days and sort by date (oldest first)
    final cleanedStreakCompleted =
        newStreakCompleted
            .where((item) => last7Days.contains(item.date))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    // Cap at 7 entries
    final cappedStreakCompleted = cleanedStreakCompleted.length > 7
        ? cleanedStreakCompleted.sublist(cleanedStreakCompleted.length - 7)
        : cleanedStreakCompleted;

    // Update best streak if current is better
    final newBest = currentStreak > state.best ? currentStreak : state.best;

    // _logger.f('Manual streak: $currentStreak (best: $newBest)');
    // _logger.f('Cleaned streak completed: ${cappedStreakCompleted.length}');

    final next = state.copyWith(
      current: currentStreak,
      best: newBest,
      lastYmd: dayYmd,
      streakCompleted: cappedStreakCompleted,
    );

    state = next;
    await _persist(next);
    // _logger.f('Persisted manual streak: $next');
  }
}

final streakControllerProvider =
    NotifierProvider<StreakController, StreakState>(StreakController.new);
