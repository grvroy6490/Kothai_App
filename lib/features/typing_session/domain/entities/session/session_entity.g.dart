// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionEntity _$SessionEntityFromJson(Map<String, dynamic> json) =>
    _SessionEntity(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      mode: $enumDecode(_$SessionModeEnumMap, json['mode']),
      difficulty: $enumDecode(_$DifficultyEnumEnumMap, json['difficulty']),
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      metrics: MetricsEntity.fromJson(json['metrics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionEntityToJson(_SessionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mode': _$SessionModeEnumMap[instance.mode]!,
      'difficulty': _$DifficultyEnumEnumMap[instance.difficulty]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt.toIso8601String(),
      'metrics': instance.metrics,
    };

const _$SessionModeEnumMap = {
  SessionMode.none: 'none',
  SessionMode.practice: 'practice',
  SessionMode.challenge: 'challenge',
};

const _$DifficultyEnumEnumMap = {
  DifficultyEnum.easy: 'easy',
  DifficultyEnum.medium: 'medium',
  DifficultyEnum.hard: 'hard',
};
