


import 'package:visai/features/typing_session/domain/entities/score/score_entity.dart';

abstract class XpCloudRepository {
    Future<void> uploadEntries(List<ScoreEntry> entries);
}