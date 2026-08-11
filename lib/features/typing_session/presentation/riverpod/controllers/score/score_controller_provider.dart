import 'package:visai/di/providers/auth/auth_provider.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/domain/entities/levels/level_entity.dart';
import 'package:visai/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';
import 'package:visai/features/notifications/presentation/riverpod/in_app_notifications_controller.dart';
import 'package:visai/features/typing_session/domain/entities/score/score_entity.dart';
import 'package:visai/features/typing_session/domain/entities/session/session_entity.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/providers/score/score_repo_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/providers/session/session_repo_provider.dart';
import 'package:visai/features/user_profile/presentation/riverpod/providers/user_stats_provider.dart';
// import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:visai/services/notifications/local_notification_service.dart';


part 'score_controller_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoreController extends _$ScoreController {
    // final _logger = Logger();

    @override
    ScoreEntity build() {
        // lazy load totals
        _load();
        return const ScoreEntity();
    }

    Future<void> _load() async {
        var totals = await ref.read(scoreLocalRepositoryProvider).loadScores();
        final gamification = ref.read(gamificationDataControllerProvider);
        final levels = gamification?.levels;

        if (levels == null || levels.isEmpty) {
            // _logger.w('No gamification levels available, leaving xpNextLevel unchanged.');
            state = totals;
            return;
        }

        final nextLevel = levels.firstWhere(
            (level) => level.totalXp > totals.totalXp,
            orElse: () => levels.last
        );

        totals = totals.copyWith(
            xpNextLevel: nextLevel.totalXp
        );
        state = totals;
    }

    /// Award XP and persist: totals in prefs + entry in DB.
    Future<void> award({
        required int amount,
        required String mode,
        String? sessionId
    }) async {
        // 1) add entry row
        final entry = ScoreEntry(
            id: const Uuid().v4(),
            at: DateTime.now(),
            mode: mode,
            amount: amount,
            sessionId: sessionId
        );
        await ref.read(scoreLocalRepositoryProvider).addEntryToDB(entry);

        // 2) update totals & level (linear 200xp/level)
        final levels = ref.read(gamificationDataControllerProvider)!.levels;
        final previousLevel = state.level;
        final nextTotal = state.totalXp + amount;
        // Find the user's current level based on their new total XP.
        final currentLevel = levels.lastWhere(
            (level) => level.totalXp <= nextTotal,
            orElse: () => levels.first
        );
        // Find the next level to determine XP required for it.
        final nextLevel = levels.firstWhere(
            (level) => level.totalXp > nextTotal,
            orElse: () => levels.last
        );

        final into = nextLevel.totalXp - currentLevel.totalXp;
        final newLevel = int.parse(currentLevel.level);
        final updated = state.copyWith(
            totalXp: nextTotal,
            level: newLevel,
            xpIntoLevel: into,
            xpNextLevel: nextLevel.totalXp
        );

        state = updated;
        await ref.read(scoreLocalRepositoryProvider).saveScore(updated);

        if (newLevel > previousLevel) {
            await ref
                .read(inAppNotificationsControllerProvider.notifier)
                .tryAddLevelUp(newLevel);
            await LocalNotificationService.instance.showLevelUp(
                prefs: ref.read(sharedPrefsServiceProvider),
                level: newLevel,
            );
        }
    }

    /// Upload pending entries if logged in; mark as synced on success.
    Future<void> syncIfLoggedIn() async {
        final isLoggedIn = ref.read(isLoggedInProvider); // TODO: implement your auth flag
        if (!isLoggedIn) return;

        final pending = await ref.read(scoreLocalRepositoryProvider).listEntriesFromDB(onlyPending: true);
        if (pending.isEmpty) return;

        // TODO: Cloud Upload.
        // await ref.read(xpCloudRepoProvider).uploadEntries(pending); // implement
        // await ref.read(xpLocalRepoProvider).markSynced(pending.map((e) => e.id).toList());
    }

    /// Restore totals + entries from Firebase into local cache, merging guest/offline
    /// progress (higher local totals) so login does not wipe device XP.
    Future<void> restoreFirebaseToLocal() async {
        final firebaseUser = ref.read(firebaseAuthProvider).currentUser;
        if (firebaseUser == null) return;

        final uid = firebaseUser.uid;
        final localRepo = ref.read(scoreLocalRepositoryProvider);
        final cloudRepo = ref.read(scoreCloudRepositoryProvider);

        final localTotals = await localRepo.loadScores();
        final pendingLocal = await localRepo.listEntriesFromDB(onlyPending: true);
        final pendingSum = pendingLocal.fold<int>(0, (sum, e) => sum + e.amount);

        final firebaseTotals = await cloudRepo.fetchTotals(uid);
        final cloudXp = firebaseTotals?.totalXp ?? 0;
        final mergedTotalXp = _mergeTotalXp(
            localTotalXp: localTotals.totalXp,
            cloudTotalXp: cloudXp,
            pendingUnsyncedXp: pendingSum,
        );

        await _ensureGamificationLevels();
        final levels = ref.read(gamificationDataControllerProvider)?.levels;
        if (levels == null || levels.isEmpty) {
            await localRepo.saveScore(
                (firebaseTotals ?? const ScoreEntity()).copyWith(
                    totalXp: mergedTotalXp,
                ),
            );
        } else {
            await localRepo.saveScore(
                _computeTotalsFromTotalXp(mergedTotalXp, levels),
            );
        }

        if (firebaseTotals != null) {
            final firebaseEntries = await cloudRepo.fetchEntries(uid);
            final restoredIds = <String>[];

            for (final entry in firebaseEntries) {
                restoredIds.add(entry.id);
                await localRepo.addEntryToDB(entry.copyWith(synced: true));
            }
            await localRepo.markSynced(restoredIds);
        }

        await _restoreProfileFromCloud(uid);
        ref.invalidate(userStatsProvider);
        await _load();
    }

    /// Merges account (Firestore) XP with guest/offline XP on this device.
    ///
    /// [localTotalXp] already includes amounts from pending DB entries (see [award]),
    /// so we must not add [pendingUnsyncedXp] again or XP doubles.
    static int _mergeTotalXp({
        required int localTotalXp,
        required int cloudTotalXp,
        required int pendingUnsyncedXp,
    }) {
        if (localTotalXp > 0) {
            return localTotalXp > cloudTotalXp ? localTotalXp : cloudTotalXp;
        }
        return cloudTotalXp + pendingUnsyncedXp;
    }

    Future<void> _ensureGamificationLevels() async {
        final levels = ref.read(gamificationDataControllerProvider)?.levels;
        if (levels != null && levels.isNotEmpty) return;
        await ref.read(getGamificationDataControllerProvider.future);
    }

    Future<void> _restoreProfileFromCloud(String uid) async {
        final progress = ref.read(userProgressCloudRepositoryProvider);
        final cloudBadges = await progress.fetchBadges(uid);
        if (cloudBadges != null && cloudBadges.isNotEmpty) {
            ref.read(badgeControllerProvider.notifier).mergeFromCloud(cloudBadges);
        }

        final cloudSessions = await progress.fetchSessions(uid);
        final sessionRepo = ref.read(sessionLocalRepositoryProvider);
        final localSessions = await sessionRepo.list();

        final byId = <String, SessionEntity>{};
        for (final s in cloudSessions) {
            byId[s.id] = s;
        }
        for (final s in localSessions) {
            byId[s.id] = s;
        }
        final merged = byId.values.toList()
          ..sort((a, b) => b.endedAt.compareTo(a.endedAt));
        await sessionRepo.replaceAllSessions(merged);
    }

    /// Upload local pending entries + totals to Firebase.
    Future<void> syncLocalToFirebase() async {
        final firebaseUser = ref.read(firebaseAuthProvider).currentUser;
        if (firebaseUser == null) return;

        final uid = firebaseUser.uid;
        final localRepo = ref.read(scoreLocalRepositoryProvider);
        final cloudRepo = ref.read(scoreCloudRepositoryProvider);

        await _load();
        await _ensureGamificationLevels();
        final cloudTotals = await cloudRepo.fetchTotals(uid);
        final pending = await localRepo.listEntriesFromDB(onlyPending: true);
        final pendingSum = pending.fold<int>(0, (sum, e) => sum + e.amount);
        final mergedXp = _mergeTotalXp(
            localTotalXp: state.totalXp,
            cloudTotalXp: cloudTotals?.totalXp ?? 0,
            pendingUnsyncedXp: pendingSum,
        );
        final levels = ref.read(gamificationDataControllerProvider)?.levels;
        final totalsToUpload = (levels == null || levels.isEmpty)
            ? state.copyWith(totalXp: mergedXp)
            : _computeTotalsFromTotalXp(mergedXp, levels);
        if (mergedXp != state.totalXp) {
            state = totalsToUpload;
            await localRepo.saveScore(totalsToUpload);
        }

        await cloudRepo.uploadTotals(uid, totalsToUpload);

        if (pending.isNotEmpty) {
            await cloudRepo.uploadEntries(uid, pending);
            await localRepo.markSynced(pending.map((e) => e.id).toList());
        }

        await _syncProfileArtifactsToCloud(uid);
        ref.invalidate(userStatsProvider);
    }

    Future<void> _syncProfileArtifactsToCloud(String uid) async {
        final progress = ref.read(userProgressCloudRepositoryProvider);
        final badges = ref.read(badgeControllerProvider);
        await progress.uploadBadges(uid, badges);
        final sessions = await ref.read(sessionLocalRepositoryProvider).list();
        await progress.uploadSessions(uid, sessions);
    }

    /// Full sync: merge guest/device progress with Firestore, then upload.
    Future<void> syncAll() async {
        final firebaseUser = ref.read(firebaseAuthProvider).currentUser;
        if (firebaseUser == null) {
            throw StateError('Cannot sync score without a signed-in user.');
        }

        await _load();
        await _ensureGamificationLevels();
        await restoreFirebaseToLocal();
        await syncLocalToFirebase();
        await _load();
    }

    ScoreEntity _computeTotalsFromTotalXp(
        int totalXp,
        List<LevelEntity> levels,
    ) {
        // `levels` comes from GamificationEntity.levels which are `LevelEntity`.
        final currentLevel = levels.lastWhere(
            (level) => level.totalXp <= totalXp,
            orElse: () => levels.first,
        );
        final nextLevel = levels.firstWhere(
            (level) => level.totalXp > totalXp,
            orElse: () => levels.last,
        );

        final into = nextLevel.totalXp - currentLevel.totalXp;
        return ScoreEntity(
            totalXp: totalXp,
            level: int.parse(currentLevel.level),
            xpIntoLevel: into,
            xpNextLevel: nextLevel.totalXp,
        );
    }

}