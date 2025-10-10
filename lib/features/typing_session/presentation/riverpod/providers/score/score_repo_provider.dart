


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/di/providers/db/db_provider.dart';
import 'package:kothai_app/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:kothai_app/features/typing_session/data/repositories_impl/score/score_local_db_repo_impl.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/score/score_dao.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/score/score_local_db_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'score_repo_provider.g.dart';

@riverpod
ScoreDao scoreDao(Ref ref) {
  final db = ref.watch(databaseProvider).requireValue;
  return ScoreDao(db);
}

@riverpod
ScoreLocalDBRepository scoreLocalRepository(Ref ref) {
  final prefs = ref.watch(sharedPrefsServiceProvider);
  return ScoreLocalDBRepositoryImpl(ref.watch(scoreDaoProvider), prefs);
}



// final xpCloudRepoProvider = Provider((ref) => _NoopXpCloudRepo());
//
// class _NoopXpCloudRepo {
//   Future<void> uploadEntries(List entries) async {
//     // no-op; replace with Firebase later
//   }
// }