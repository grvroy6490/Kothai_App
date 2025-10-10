import 'package:freezed_annotation/freezed_annotation.dart';

part 'metrics.freezed.dart';
part 'metrics.g.dart';

@freezed
abstract class Metrics with _$Metrics {
    const factory Metrics({
        required int totalWords,
        required int correctWords,
        required int incorrectWords,
        required int totalCharacters,
        required int correctCharacters,
        required int incorrectCharacters,
        required double accuracy,
        required double wpm,
        required double cpm,
        @DurationConverter() required Duration duration,
    }) = _Metrics;

    factory Metrics.fromJson(Map<String, dynamic> json) =>
    _$MetricsFromJson(json);
}

/// Converter to store `Duration` as milliseconds in JSON
class DurationConverter implements JsonConverter<Duration, int> {
    const DurationConverter();

    @override
    Duration fromJson(int json) => Duration(milliseconds: json);

    @override
    int toJson(Duration object) => object.inMilliseconds;
}
