// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TypingSession _$TypingSessionFromJson(Map<String, dynamic> json) =>
    _TypingSession(
      id: json['id'] as String,
      mode: $enumDecode(_$SessionModeEnumMap, json['mode']),
      difficulty: $enumDecode(_$DifficultyEnumEnumMap, json['difficulty']),
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      metrics: Metrics.fromJson(json['metrics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TypingSessionToJson(_TypingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mode': _$SessionModeEnumMap[instance.mode]!,
      'difficulty': _$DifficultyEnumEnumMap[instance.difficulty]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt.toIso8601String(),
      'metrics': instance.metrics,
    };

const _$SessionModeEnumMap = {
  SessionMode.practice: 'practice',
  SessionMode.challenge: 'challenge',
};

const _$DifficultyEnumEnumMap = {
  DifficultyEnum.easy: 'easy',
  DifficultyEnum.medium: 'medium',
  DifficultyEnum.hard: 'hard',
};
