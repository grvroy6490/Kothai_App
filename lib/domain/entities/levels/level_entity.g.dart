// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LevelEntity _$LevelEntityFromJson(Map<String, dynamic> json) => _LevelEntity(
  level: json['level'] as String,
  totalXp: (json['totalXp'] as num).toInt(),
);

Map<String, dynamic> _$LevelEntityToJson(_LevelEntity instance) =>
    <String, dynamic>{'level': instance.level, 'totalXp': instance.totalXp};
