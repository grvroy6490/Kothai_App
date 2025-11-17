import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/session/session_repo_provider.dart';
import 'package:kothai_app/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';

part 'user_stats_provider.g.dart';

class UserStats {
  final double bestWpm;
  final double bestAccuracy;
  final int achievements;
  final int challengesCompleted;
  final int practiceSessions;

  const UserStats({
    this.bestWpm = 0.0,
    this.bestAccuracy = 0.0,
    this.achievements = 0,
    this.challengesCompleted = 0,
    this.practiceSessions = 0,
  });
}

@riverpod
Future<UserStats> userStats(UserStatsRef ref) async {
  final sessionRepo = ref.watch(sessionLocalRepositoryProvider);
  final sessions = await sessionRepo.list();
  final badges = ref.watch(badgeControllerProvider);

  double bestWpm = 0.0;
  double bestAccuracy = 0.0;
  int challengesCompleted = 0;
  int practiceSessions = 0;

  for (final session in sessions) {
    // Calculate WPM and accuracy from metrics
    final metrics = session.metrics;
    final wpm = metrics.wpm;

    // Only calculate accuracy if user actually typed something
    // Skip sessions where typed == 0 (no typing occurred)
    double? accuracy;
    if (metrics.typed > 0) {
      accuracy = metrics.accuracy * 100; // Convert to percentage (0-100)
    }

    // Update best WPM (only if > 0)
    if (wpm > bestWpm) {
      bestWpm = wpm;
    }

    // Update best accuracy (only if accuracy was calculated and > 0)
    if (accuracy != null && accuracy > bestAccuracy) {
      bestAccuracy = accuracy;
    }

    // Count sessions by mode
    if (session.mode == SessionMode.challenge) {
      challengesCompleted++;
    } else if (session.mode == SessionMode.practice) {
      practiceSessions++;
    }
  }

  return UserStats(
    bestWpm: bestWpm,
    bestAccuracy: bestAccuracy,
    achievements: badges.length,
    challengesCompleted: challengesCompleted,
    practiceSessions: practiceSessions,
  );
}
