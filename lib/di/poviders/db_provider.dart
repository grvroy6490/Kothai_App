


import 'package:kothai_app/di/poviders/shared_prefs_provider.dart';
import 'package:kothai_app/features/typing_session/data/repositories_impl/XP/xp_local_repository_impl.dart';
import 'package:kothai_app/features/typing_session/data/repositories_impl/session/session_local_repository_impl.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/XP/xp_dao.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/db_helper.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/session/last_session_prefs.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/session/session_dao.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/XP/xp_local_repository.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/session/last_session_store.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/session/session_local_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:kothai_app/features/authentication/presentation/providers/ApplicationState.dart' as auth;
import 'package:sqflite/sqflite.dart';


// SESSION RELATED PROVIDERS
final databaseProvider = FutureProvider<Database>((ref) async {
        return AppDatabase.open();
    });

final sessionDaoProvider = Provider<SessionDao>((ref) {
        final db = ref.watch(databaseProvider).requireValue;
        return SessionDao(db);
    });

final sessionLocalRepoProvider = Provider<SessionLocalRepository>((ref) {
        return SessionLocalRepositoryImpl(ref.watch(sessionDaoProvider), cap: 7);
    });

final lastSessionStoreProvider = Provider<LastSessionStore>((ref) {
        final prefs = ref.watch(sharedPrefsServiceProvider);
        return LastSessionPrefs(prefs);
    });





// XP RELATED PROVIDERS


final xpDaoProvider = Provider<XpDao>((ref) {
        final db = ref.watch(databaseProvider).requireValue;
        return XpDao(db);
    });

final xpLocalRepoProvider = Provider<XpLocalRepository>((ref) {
        final prefs = ref.watch(sharedPrefsServiceProvider);
        return XpLocalRepositoryImpl(ref.watch(xpDaoProvider), prefs);
    });

// Stubs for auth + cloud
final isLoggedInProvider = Provider<bool>((ref) => ref.watch(auth.authIsLoggedInProvider));

final xpCloudRepoProvider = Provider((ref) => _NoopXpCloudRepo());

class _NoopXpCloudRepo {
    Future<void> uploadEntries(List entries) async {
        // no-op; replace with Firebase later
    }
}
