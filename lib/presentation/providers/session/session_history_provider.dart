import 'package:visai/data/repositories_impl/session/session_history_repository_impl.dart';
import 'package:visai/domain/repositories/session/session_history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visai/data/models/session/typing_session.dart';

part 'session_history_provider.g.dart';

/// Async cache of all sessions; refresh with `reload()` after changes.
@Riverpod(keepAlive: true)
class SessionHistory extends _$SessionHistory {
    @override
    Future<List<TypingSession>> build() async {
        final repo = ref.read(sessionHistoryRepositoryProvider);
        return repo.getAll();
    }

    Future<void> reload() async {
        state = const AsyncLoading();
        state = await AsyncValue.guard(() async {
                final repo = ref.read(sessionHistoryRepositoryProvider);
                return repo.getAll();
            });
    }

    Future<void> add(TypingSession s) async {
        final repo = ref.read(sessionHistoryRepositoryProvider);
        await repo.add(s);
        await reload();
    }

    Future<void> clear() async {
        final repo = ref.read(sessionHistoryRepositoryProvider);
        await repo.clear();
        await reload();
    }
}


@Riverpod(keepAlive: true)
ISessionHistoryRepository sessionHistoryRepository(SessionHistoryRepositoryRef ref) {
  return const SessionHistoryRepository();
}
