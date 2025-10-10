// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScoreEntity _$ScoreEntityFromJson(Map<String, dynamic> json) => _ScoreEntity(
  totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 1,
  xpIntoLevel: (json['xpIntoLevel'] as num?)?.toInt() ?? 1000,
  xpNextLevel: (json['xpNextLevel'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ScoreEntityToJson(_ScoreEntity instance) =>
    <String, dynamic>{
      'totalXp': instance.totalXp,
      'level': instance.level,
      'xpIntoLevel': instance.xpIntoLevel,
      'xpNextLevel': instance.xpNextLevel,
    };

_ScoreEntry _$ScoreEntryFromJson(Map<String, dynamic> json) => _ScoreEntry(
  id: json['id'] as String,
  at: DateTime.parse(json['at'] as String),
  mode: json['mode'] as String,
  amount: (json['amount'] as num).toInt(),
  synced: json['synced'] as bool? ?? false,
  sessionId: json['sessionId'] as String?,
);

Map<String, dynamic> _$ScoreEntryToJson(_ScoreEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'at': instance.at.toIso8601String(),
      'mode': instance.mode,
      'amount': instance.amount,
      'synced': instance.synced,
      'sessionId': instance.sessionId,
    };
