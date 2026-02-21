
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/di/providers/db/db_provider.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/features/typing_session/data/repositories_impl/session/session_local_db_repo_impl.dart';
import 'package:visai/features/typing_session/data/sources/local/session/last_session_to_prefs.dart';
import 'package:visai/features/typing_session/data/sources/local/session/session_dao.dart';
import 'package:visai/features/typing_session/domain/repositories/session/session_local_db_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'session_repo_provider.g.dart';

@riverpod
SessionDao sessionDao(Ref ref) {
    final db = ref.watch(databaseProvider).requireValue;
    return SessionDao(db);
}

@riverpod
SessionLocalDBRepository sessionLocalRepository(Ref ref) {
    return SessionLocalRepositoryImpl(ref.watch(sessionDaoProvider), cap: 7);
}

@riverpod
LastSessionToPrefs lastSessionToPrefs(Ref ref) {
    final prefs = ref.watch(sharedPrefsServiceProvider);
    return LastSessionToPrefs(prefs);
}

