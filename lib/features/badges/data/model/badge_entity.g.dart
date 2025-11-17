// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BadgeEntity _$BadgeEntityFromJson(Map<String, dynamic> json) => _BadgeEntity(
  id: json['id'] as String,
  name: json['name'] as String,
  tier: json['tier'] as String,
  type: $enumDecode(_$BadgeTypeEnumMap, json['type']),
  condition: json['condition'] as String,
  toastMessage: json['toastMessage'] as String,
  imagePath: json['imagePath'] as String,
);

Map<String, dynamic> _$BadgeEntityToJson(_BadgeEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tier': instance.tier,
      'type': _$BadgeTypeEnumMap[instance.type]!,
      'condition': instance.condition,
      'toastMessage': instance.toastMessage,
      'imagePath': instance.imagePath,
    };

const _$BadgeTypeEnumMap = {
  BadgeType.general: 'general',
  BadgeType.xp: 'xp',
  BadgeType.streak: 'streak',
  BadgeType.speed: 'speed',
  BadgeType.accuracy: 'accuracy',
};
