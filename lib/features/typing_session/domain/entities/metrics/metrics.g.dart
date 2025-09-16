// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Metrics _$MetricsFromJson(Map<String, dynamic> json) => _Metrics(
  typed: (json['typed'] as num?)?.toInt() ?? 0,
  correct: (json['correct'] as num?)?.toInt() ?? 0,
  errors: (json['errors'] as num?)?.toInt() ?? 0,
  elapsedMs: (json['elapsedMs'] as num?)?.toInt() ?? 0,
  totalChars: (json['totalChars'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MetricsToJson(_Metrics instance) => <String, dynamic>{
  'typed': instance.typed,
  'correct': instance.correct,
  'errors': instance.errors,
  'elapsedMs': instance.elapsedMs,
  'totalChars': instance.totalChars,
};
