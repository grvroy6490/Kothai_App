

import 'package:kothai_app/features/typing_session/data/sources/local/difficulty_criteria/difficulty_criteria_cache.dart';
import 'package:kothai_app/features/typing_session/domain/entities/difficulty/difficulty_criteria.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/difficulty_criteria/difficulty_criteria_repository.dart';

class DifficultyCriteriaRepositoryImpl implements DifficultyCriteriaRepository {
    final DifficultyCriteriaCache cache;
    DifficultyCriteriaRepositoryImpl(this.cache);

    @override
    Future<void> save(DifficultyCriteria c) => cache.write(c);

    @override
    Future<DifficultyCriteria?> load() async => cache.read();
}