import 'package:visai/features/typing_session/domain/entities/session/session_entity.dart';

/// Cloud backup for profile stats sources: badges + session history (WPM/accuracy/challenge counts derive from sessions).
abstract class UserProgressCloudRepository {
  Future<void> uploadBadges(String uid, Set<String> badgeIds);

  /// Null if never synced.
  Future<Set<String>?> fetchBadges(String uid);

  Future<void> uploadSessions(String uid, List<SessionEntity> sessions);

  Future<List<SessionEntity>> fetchSessions(String uid);
}
