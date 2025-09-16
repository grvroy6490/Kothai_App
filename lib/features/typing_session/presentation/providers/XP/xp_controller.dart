import 'package:kothai_app/di/poviders/db_provider.dart';
import 'package:kothai_app/features/typing_session/domain/entities/XP/xp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';


part 'xp_controller.g.dart';

@Riverpod(keepAlive: true)
class XpController extends _$XpController {
    @override
    XpTotals build() {
        // lazy load totals
        _load();
        return const XpTotals();
    }

    Future<void> _load() async {
        final totals = await ref.read(xpLocalRepoProvider).loadTotals();
        state = totals;
    }

    /// Award XP and persist: totals in prefs + entry in DB.
    Future<void> award({
        required int amount,
        required String mode,
        String? sessionId
    }) async {
        // 1) add entry row
        final entry = XpEntry(
            id: const Uuid().v4(),
            at: DateTime.now(),
            mode: mode,
            amount: amount,
            sessionId: sessionId
        );
        await ref.read(xpLocalRepoProvider).addEntry(entry);

        // 2) update totals & level (linear 200xp/level)
        final xpPerLevel = state.xpPerLevel;
        final nextTotal = state.totalXp + amount;
        final level = 1 + (nextTotal ~/ xpPerLevel);
        final into = nextTotal % xpPerLevel;

        final updated = state.copyWith(
            totalXp: nextTotal,
            level: level,
            xpIntoLevel: into,
            xpPerLevel: xpPerLevel
        );

        state = updated;
        await ref.read(xpLocalRepoProvider).saveTotals(updated);
    }

    /// Upload pending entries if logged in; mark as synced on success.
    Future<void> syncIfLoggedIn() async {
        final isLoggedIn = ref.read(isLoggedInProvider); // TODO: implement your auth flag
        if (!isLoggedIn) return;

        final pending = await ref.read(xpLocalRepoProvider).listEntries(onlyPending: true);
        if (pending.isEmpty) return;

        await ref.read(xpCloudRepoProvider).uploadEntries(pending); // implement
        await ref.read(xpLocalRepoProvider).markSynced(pending.map((e) => e.id).toList());
    }
}
