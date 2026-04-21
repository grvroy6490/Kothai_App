
import 'package:visai/features/typing_session/domain/entities/session/session_entity.dart';

abstract class SessionLocalDBRepository {
    Future<void> add(SessionEntity session);           // must enforce FIFO cap=7
    Future<List<SessionEntity>> list({int? limit});

    /// Replace all rows (used after cloud restore merge). Does not apply FIFO cap.
    Future<void> replaceAllSessions(List<SessionEntity> sessions);
    // Future<void> purgeOldestIfOverCap(int cap);        // helper for FIFO
}