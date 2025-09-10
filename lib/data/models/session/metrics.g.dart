// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Metrics _$MetricsFromJson(Map<String, dynamic> json) => _Metrics(
  totalWords: (json['totalWords'] as num).toInt(),
  correctWords: (json['correctWords'] as num).toInt(),
  incorrectWords: (json['incorrectWords'] as num).toInt(),
  totalCharacters: (json['totalCharacters'] as num).toInt(),
  correctCharacters: (json['correctCharacters'] as num).toInt(),
  incorrectCharacters: (json['incorrectCharacters'] as num).toInt(),
  accuracy: (json['accuracy'] as num).toDouble(),
  wpm: (json['wpm'] as num).toDouble(),
  cpm: (json['cpm'] as num).toDouble(),
  duration: const DurationConverter().fromJson(
    (json['duration'] as num).toInt(),
  ),
);

Map<String, dynamic> _$MetricsToJson(_Metrics instance) => <String, dynamic>{
  'totalWords': instance.totalWords,
  'correctWords': instance.correctWords,
  'incorrectWords': instance.incorrectWords,
  'totalCharacters': instance.totalCharacters,
  'correctCharacters': instance.correctCharacters,
  'incorrectCharacters': instance.incorrectCharacters,
  'accuracy': instance.accuracy,
  'wpm': instance.wpm,
  'cpm': instance.cpm,
  'duration': const DurationConverter().toJson(instance.duration),
};
