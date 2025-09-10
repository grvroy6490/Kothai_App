import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/data/models/session/difficulty.dart';
import 'package:kothai_app/data/models/session/metrics.dart';
import 'package:kothai_app/enums/SessionMode.dart';

part 'typing_session.freezed.dart';
part 'typing_session.g.dart';

@freezed
abstract class TypingSession with _$TypingSession {
  const factory TypingSession({
    required String sessionId,
    required SessionMode mode,
    required Difficulty difficulty,
    required DateTime startedAt,
    required DateTime endedAt,
    required Metrics metrics,
  }) = _TypingSession;

  factory TypingSession.fromJson(Map<String, dynamic> json) =>
      _$TypingSessionFromJson(json);
}
