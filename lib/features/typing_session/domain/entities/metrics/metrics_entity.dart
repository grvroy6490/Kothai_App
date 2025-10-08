

import 'package:freezed_annotation/freezed_annotation.dart';

part 'metrics_entity.freezed.dart';
part 'metrics_entity.g.dart';

@freezed
abstract class MetricsEntity with _$MetricsEntity {
    const factory MetricsEntity({
        @Default(0) int typed,       // total keystrokes (correct + errors)
        @Default(0) int correct,     // correct chars
        @Default(0) int errors,      // wrong chars
        @Default(0) int elapsedMs,   // elapsed in ms
        @Default(0) int totalChars  // 👈 length of the target paragraph
    }) = _MetricsEntity;

    const MetricsEntity._();

    /// 0..1
    double get accuracy => typed == 0 ? 1.0 : correct / typed;

    /// words per minute (5 chars = 1 word)
    double get wpm {
        final minutes = elapsedMs / 60000.0;
        if (minutes <= 0) return 0;
        final words = correct / 5.0;
        return words / minutes;
    }

    /// 0..1 (how much of target finished)
    // double get progress => totalChars == 0 ? 0.0 : (correct / totalChars).clamp(0.0, 1.0);

    /// "Xm Ys" (or "Hh Mm Ss" if hours > 0)
    String get elapsedFormatted {
        final d = Duration(milliseconds: elapsedMs);
        final h = d.inHours;
        final m = d.inMinutes % 60;
        final s = d.inSeconds % 60;
        if (h > 0) return '${h}h ${m}m ${s}s';
        return '${m}m ${s}s';
    }

    factory MetricsEntity.fromJson(Map<String, dynamic> json) => _$MetricsEntityFromJson(json);
}