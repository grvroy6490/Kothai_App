


import 'package:visai/features/typing_session/domain/entities/score/score_entity.dart';

abstract class XpCloudRepository {
    /// Upload current totals document for the user.
    Future<void> uploadTotals(String uid, ScoreEntity totals);

    /// Upload per-session XP entry documents for the user.
    ///
    /// Each entry should be deduped by `entry.id` on the cloud side.
    Future<void> uploadEntries(String uid, List<ScoreEntry> entries);

    /// Fetch totals (level/progress) for the user.
    Future<ScoreEntity?> fetchTotals(String uid);

    /// Fetch per-session XP entries for the user.
    Future<List<ScoreEntry>> fetchEntries(String uid);
}