// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_XpTotals _$XpTotalsFromJson(Map<String, dynamic> json) => _XpTotals(
  totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 1,
  xpIntoLevel: (json['xpIntoLevel'] as num?)?.toInt() ?? 0,
  xpPerLevel: (json['xpPerLevel'] as num?)?.toInt() ?? 200,
);

Map<String, dynamic> _$XpTotalsToJson(_XpTotals instance) => <String, dynamic>{
  'totalXp': instance.totalXp,
  'level': instance.level,
  'xpIntoLevel': instance.xpIntoLevel,
  'xpPerLevel': instance.xpPerLevel,
};

_XpEntry _$XpEntryFromJson(Map<String, dynamic> json) => _XpEntry(
  id: json['id'] as String,
  at: DateTime.parse(json['at'] as String),
  mode: json['mode'] as String,
  amount: (json['amount'] as num).toInt(),
  synced: json['synced'] as bool? ?? false,
  sessionId: json['sessionId'] as String?,
);

Map<String, dynamic> _$XpEntryToJson(_XpEntry instance) => <String, dynamic>{
  'id': instance.id,
  'at': instance.at.toIso8601String(),
  'mode': instance.mode,
  'amount': instance.amount,
  'synced': instance.synced,
  'sessionId': instance.sessionId,
};
