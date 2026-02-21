



import 'package:visai/features/typing_session/domain/entities/score/score_entity.dart';

abstract class ScoreLocalDBRepository {
    Future<ScoreEntity> loadScores();
    Future<void> saveScore(ScoreEntity totals);
    Future<void> addEntryToDB(ScoreEntry entry);
    Future<List<ScoreEntry>> listEntriesFromDB({bool onlyPending = false, int? limit});
    Future<void> markSynced(List<String> ids);
}