import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/constants/typing_session_constants.dart';
import 'package:kothai_app/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:logger/logger.dart';

class StreakState {
    final int current;
    final int best;
    final String? lastYmd; // 'yyyyMMdd'
    final Set<String> completedDays; // Set of completed days in YYYYMMDD format

    const StreakState({
        this.current = 0,
        this.best = 0,
        this.lastYmd,
        this.completedDays = const {}
    });

    StreakState copyWith({
        int? current,
        int? best,
        String? lastYmd,
        Set<String>? completedDays
    }) => StreakState(
        current: current ?? this.current,
        best: best ?? this.best,
        lastYmd: lastYmd ?? this.lastYmd,
        completedDays: completedDays ?? this.completedDays
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
        final completedDays = _prefs.getSet(kStreakDaysKey) ?? <String>{};
        return StreakState(
            current: cur,
            best: best,
            lastYmd: last,
            completedDays: completedDays
        );
    }

    String _ymd(DateTime d) {
        final local = d.toLocal();
        final y = local.year.toString().padLeft(4, '0');
        final m = local.month.toString().padLeft(2, '0');
        final dd = local.day.toString().padLeft(2, '0');
        return '$y$m$dd';
    }

    Future<void> _persist(StreakState s) async {
        await _prefs.setInt(kStreakCurrentKey, s.current);
        await _prefs.setInt(kStreakBestKey, s.best);
        if (s.lastYmd != null) {
            await _prefs.setString(kStreakLastYmdKey, s.lastYmd!);
        }
        await _prefs.setSet(kStreakDaysKey, s.completedDays);
    }

    Future<void> markActiveToday() async {
        final today = _ymd(DateTime.now());
        // _logger.e('Checking streak for today: $today');

        // If already completed today, return
        if (state.completedDays.contains(today)) {
            // _logger.e('Already completed today: $today');
            return;
        }

        // Add today to completed days
        final newCompletedDays = Set<String>.from(state.completedDays)..add(today);

        // Calculate current streak by finding consecutive days from today backwards
        int currentStreak = 0;
        final todayDate = DateTime.now().toLocal();

        for (int i = 0; i < 7; i++) {
            final checkDate = todayDate.subtract(Duration(days: i));
            final checkYmd = _ymd(checkDate);

            if (newCompletedDays.contains(checkYmd)) {
                currentStreak++;
            } else {
                break; // Streak broken
            }
        }

        // Clean up old completed days (keep only last 7 days)
        final last7Days = <String>[];
        for (int i = 0; i < 7; i++) {
            final day = todayDate.subtract(Duration(days: i));
            last7Days.add(_ymd(day));
        }

        // Keep only the last 7 days in completed days
        final cleanedCompletedDays = newCompletedDays
            .where((day) => last7Days.contains(day))
            .toSet();

        // Update best streak if current is better
        final newBest = currentStreak > state.best ? currentStreak : state.best;

        // _logger.f('New streak: $currentStreak (best: $newBest)');
        // _logger.f('Cleaned completed days: $cleanedCompletedDays');

        final next = state.copyWith(
            current: currentStreak,
            best: newBest,
            lastYmd: today,
            completedDays: cleanedCompletedDays
        );

        state = next;
        await _persist(next);
        // _logger.f('Persisted streak: $next');
    }

    Future<void> resetStreak() async {
        state = const StreakState();
        await _prefs.remove(kStreakCurrentKey);
        await _prefs.remove(kStreakBestKey);
        await _prefs.remove(kStreakLastYmdKey);
        await _prefs.remove(kStreakDaysKey);
    }

    // Method for testing - manually add a streak for a specific day
    Future<void> addStreakForDay(DateTime day) async {
        final dayYmd = _ymd(day);
        // _logger.e('Manually adding streak for day: $dayYmd');

        // Add the day to completed days
        final newCompletedDays = Set<String>.from(state.completedDays)..add(dayYmd);

        // Calculate current streak by finding consecutive days from today backwards
        int currentStreak = 0;
        final todayDate = DateTime.now().toLocal();

        for (int i = 0; i < 7; i++) {
            final checkDate = todayDate.subtract(Duration(days: i));
            final checkYmd = _ymd(checkDate);

            if (newCompletedDays.contains(checkYmd)) {
                currentStreak++;
            } else {
                break; // Streak broken
            }
        }

        // Clean up old completed days (keep only last 7 days)
        final last7Days = <String>[];
        for (int i = 0; i < 7; i++) {
            final day = todayDate.subtract(Duration(days: i));
            last7Days.add(_ymd(day));
        }

        // Keep only the last 7 days in completed days
        final cleanedCompletedDays = newCompletedDays
            .where((day) => last7Days.contains(day))
            .toSet();

        // Update best streak if current is better
        final newBest = currentStreak > state.best ? currentStreak : state.best;

        // _logger.f('Manual streak: $currentStreak (best: $newBest)');
        // _logger.f('Cleaned completed days: $cleanedCompletedDays');

        final next = state.copyWith(
            current: currentStreak,
            best: newBest,
            lastYmd: dayYmd,
            completedDays: cleanedCompletedDays
        );

        state = next;
        await _persist(next);
        // _logger.f('Persisted manual streak: $next');
    }
}

final streakControllerProvider =
    NotifierProvider<StreakController, StreakState>(StreakController.new);
