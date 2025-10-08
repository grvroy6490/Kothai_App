// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'difficulty_criteria_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DifficultyCriteriaEntity _$DifficultyCriteriaEntityFromJson(
  Map<String, dynamic> json,
) => _DifficultyCriteriaEntity(
  type: json['type'] as String,
  accuracy: (json['accuracy'] as num).toInt(),
  wpm: (json['wpm'] as num).toInt(),
  timelimit: json['timelimit'] as String,
  xpMultiplier: (json['xpMultiplier'] as num).toDouble(),
  difficultyMultiplier: (json['difficultyMultiplier'] as num).toDouble(),
);

Map<String, dynamic> _$DifficultyCriteriaEntityToJson(
  _DifficultyCriteriaEntity instance,
) => <String, dynamic>{
  'type': instance.type,
  'accuracy': instance.accuracy,
  'wpm': instance.wpm,
  'timelimit': instance.timelimit,
  'xpMultiplier': instance.xpMultiplier,
  'difficultyMultiplier': instance.difficultyMultiplier,
};
