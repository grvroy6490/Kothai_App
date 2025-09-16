
import 'package:kothai_app/features/typing_session/data/sources/local/session/session_dao.dart';
import 'package:kothai_app/features/typing_session/domain/entities/session/typing_session.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/session/session_local_repository.dart';

class SessionLocalRepositoryImpl implements SessionLocalRepository {
    final SessionDao dao;
    final int cap;
    SessionLocalRepositoryImpl(this.dao, {this.cap = 7});

    @override
    Future<void> add(TypingSession s) async {
        final count = await dao.count();
        if (count >= cap) {
            final over = count - cap + 1;
            if (over > 0) await dao.deleteOldest(over);
        }
        await dao.insert(s);
    }

    @override
    Future<List<TypingSession>> list({int? limit}) => dao.list(limit: limit);

    // @override
    // Future<void> purgeOldestIfOverCap(int cap) async {
    //     final c = await dao.count();
    //     final over = c - cap + 1; // +1 if we are about to insert
    //     if (over > 0) {
    //         await dao.deleteOldest(over);
    //     }
    // }
}