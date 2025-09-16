import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/entities/metrics/metrics.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';

part 'typing_session.freezed.dart';
part 'typing_session.g.dart';

@freezed
abstract class TypingSession with _$TypingSession {
    const factory TypingSession({
        required String id,                // unique id (uuid)
        required SessionMode mode,
        required DifficultyEnum difficulty,
        required DateTime startedAt,
        required DateTime endedAt,
        required Metrics metrics
    }) = _TypingSession;

    factory TypingSession.fromJson(Map<String, dynamic> json) =>
    _$TypingSessionFromJson(json);
}
