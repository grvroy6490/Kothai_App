
import 'package:visai/features/typing_session/domain/entities/session/session_entity.dart';

abstract class SessionLocalDBRepository {
    Future<void> add(SessionEntity session);           // must enforce FIFO cap=7
    Future<List<SessionEntity>> list({int? limit});
    // Future<void> purgeOldestIfOverCap(int cap);        // helper for FIFO
}