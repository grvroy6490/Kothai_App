



import 'package:kothai_app/data/models/session/typing_session.dart';

abstract class ISessionHistoryRepository {
    Future<List<TypingSession>> getAll();
    Future<void> add(TypingSession session, {int maxKeep = 500});
    Future<void> replaceAll(List<TypingSession> sessions);
    Future<void> clear();
}
