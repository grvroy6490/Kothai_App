// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_tracking_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChallengeTrackingEntity _$ChallengeTrackingEntityFromJson(
  Map<String, dynamic> json,
) => _ChallengeTrackingEntity(
  difficulty: $enumDecode(_$DifficultyEnumEnumMap, json['difficulty']),
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$ChallengeTrackingEntityToJson(
  _ChallengeTrackingEntity instance,
) => <String, dynamic>{
  'difficulty': _$DifficultyEnumEnumMap[instance.difficulty]!,
  'timestamp': instance.timestamp,
};

const _$DifficultyEnumEnumMap = {
  DifficultyEnum.easy: 'easy',
  DifficultyEnum.medium: 'medium',
  DifficultyEnum.hard: 'hard',
};
