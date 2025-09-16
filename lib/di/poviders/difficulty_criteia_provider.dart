

import 'package:kothai_app/di/poviders/shared_prefs_provider.dart';
import 'package:kothai_app/features/typing_session/data/repositories_impl/difficulty_criteria/difficulty_criteria_repository_impl.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/difficulty_criteria/difficulty_criteria_cache.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/difficulty_criteria/difficulty_criteria_repository.dart';
import 'package:riverpod/riverpod.dart';

final difficultyCriteriaCacheProvider = Provider<DifficultyCriteriaCache>((ref) {
        final prefs = ref.watch(sharedPrefsServiceProvider);
        return DifficultyCriteriaCache(prefs);
    });

final difficultyCriteriaRepositoryProvider = Provider<DifficultyCriteriaRepository>((ref) {
        return DifficultyCriteriaRepositoryImpl(ref.watch(difficultyCriteriaCacheProvider));
    });
