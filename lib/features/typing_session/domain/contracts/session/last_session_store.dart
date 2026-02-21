
import 'package:visai/features/typing_session/domain/entities/session/session_entity.dart';

abstract class LastSessionStore {
    Future<void> save(SessionEntity session);
    Future<SessionEntity?> load();
    Future<void> clear();
}