

import 'package:kothai_app/features/typing_session/domain/entities/session/typing_session.dart';

abstract class SessionLocalRepository {
    Future<void> add(TypingSession session);           // must enforce FIFO cap=7
    Future<List<TypingSession>> list({int? limit});
    // Future<void> purgeOldestIfOverCap(int cap);        // helper for FIFO
}