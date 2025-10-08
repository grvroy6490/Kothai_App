

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/entities/metrics/metrics_entity.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';

part 'session_entity.freezed.dart';
part 'session_entity.g.dart';

@freezed
abstract class SessionEntity with _$SessionEntity {
    const factory SessionEntity({
        required String id,                // unique id (uuid)
        String? userId,
        required SessionMode mode,
        required DifficultyEnum difficulty,
        required DateTime startedAt,
        required DateTime endedAt,
        required MetricsEntity metrics
    }) = _SessionEntity;

    factory SessionEntity.fromJson(Map<String, dynamic> json) =>
    _$SessionEntityFromJson(json);
}