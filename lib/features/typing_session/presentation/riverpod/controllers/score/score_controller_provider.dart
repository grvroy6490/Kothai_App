

import 'package:kothai_app/di/providers/auth/auth_provider.dart';
import 'package:kothai_app/features/typing_session/domain/entities/score/score_entity.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/score/score_repo_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';


part 'score_controller_provider.g.dart';

@Riverpod(keepAlive: true)
class ScoreController extends _$ScoreController {
    final _logger = Logger();

    @override
    ScoreEntity build() {
        // lazy load totals
        _load();
        return const ScoreEntity();
    }

    Future<void> _load() async {
        var totals = await ref.read(scoreLocalRepositoryProvider).loadScores();
        final levels = await ref.read(gamificationDataControllerProvider)?.levels;
        final nextLevel = levels?.firstWhere(
            (level) => level.totalXp > totals.totalXp,
            orElse: () => levels.last
        );
        totals = totals.copyWith(
            xpNextLevel: nextLevel!.totalXp,
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
        final levels = await ref.read(gamificationDataControllerProvider)!.levels;
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
        final updated = state.copyWith(
            totalXp: nextTotal,
            level: int.parse(currentLevel.level),
            xpIntoLevel: into,
            xpNextLevel: nextLevel.totalXp,
        );

        state = updated;
        await ref.read(scoreLocalRepositoryProvider).saveScore(updated);
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

}