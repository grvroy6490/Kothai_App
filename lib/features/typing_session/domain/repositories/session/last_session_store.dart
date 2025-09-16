

import 'package:kothai_app/features/typing_session/domain/entities/session/typing_session.dart';

abstract class LastSessionStore {
    Future<void> save(TypingSession session);
    Future<TypingSession?> load();
    Future<void> clear();
}