

import 'package:kothai_app/features/typing_session/domain/entities/difficulty/difficulty_criteria.dart';

abstract class DifficultyCriteriaRepository {
    Future<void> save(DifficultyCriteria criteria);
    Future<DifficultyCriteria?> load(); // null if none saved yet
}