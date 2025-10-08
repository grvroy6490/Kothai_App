// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GamificationEntity _$GamificationEntityFromJson(Map<String, dynamic> json) =>
    _GamificationEntity(
      difficultyCriteria: (json['difficultyCriteria'] as List<dynamic>)
          .map(
            (e) => DifficultyCriteriaEntity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      levels: (json['levels'] as List<dynamic>)
          .map((e) => LevelEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GamificationEntityToJson(_GamificationEntity instance) =>
    <String, dynamic>{
      'difficultyCriteria': instance.difficultyCriteria,
      'levels': instance.levels,
    };
