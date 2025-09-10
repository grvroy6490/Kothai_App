// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TypingSession _$TypingSessionFromJson(Map<String, dynamic> json) =>
    _TypingSession(
      sessionId: json['sessionId'] as String,
      mode: $enumDecode(_$SessionModeEnumMap, json['mode']),
      difficulty: Difficulty.fromJson(
        json['difficulty'] as Map<String, dynamic>,
      ),
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      metrics: Metrics.fromJson(json['metrics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TypingSessionToJson(_TypingSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'mode': _$SessionModeEnumMap[instance.mode]!,
      'difficulty': instance.difficulty,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt.toIso8601String(),
      'metrics': instance.metrics,
    };

const _$SessionModeEnumMap = {
  SessionMode.practice: 'practice',
  SessionMode.challenge: 'challenge',
};
