// lib/features/session/metrics_provider.dart
import 'dart:math' as math;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kothai_app/data/models/session/metrics.dart';

part 'metrics_provider.g.dart';

@Riverpod(keepAlive: true)
class MetricsNotifier extends _$MetricsNotifier {
    @override
    Metrics build() {
        return Metrics(
            totalWords: 0,
            correctWords: 0,
            incorrectWords: 0,
            totalCharacters: 0,
            correctCharacters: 0,
            incorrectCharacters: 0,
            accuracy: 0.0,
            wpm: 0.0,
            cpm: 0.0,
            duration: Duration.zero,
        );
    }

    void reset() {
        state = build();
    }

    /// Bulk setter — useful when you compute counts externally
    void setCounts({
        int? totalWords,
        int? correctWords,
        int? incorrectWords,
        int? totalCharacters,
        int? correctCharacters,
        int? incorrectCharacters,
    }) {
        state = state.copyWith(
            totalWords: totalWords ?? state.totalWords,
            correctWords: correctWords ?? state.correctWords,
            incorrectWords: incorrectWords ?? state.incorrectWords,
            totalCharacters: totalCharacters ?? state.totalCharacters,
            correctCharacters: correctCharacters ?? state.correctCharacters,
            incorrectCharacters: incorrectCharacters ?? state.incorrectCharacters,
        );
        _recompute();
    }

    /// Incremental updates (keystroke-level)
    void addChars({required int total, required int correct}) {
        final incorrect = math.max(0, total - correct);
        state = state.copyWith(
            totalCharacters: state.totalCharacters + total,
            correctCharacters: state.correctCharacters + correct,
            incorrectCharacters: state.incorrectCharacters + incorrect,
        );
        _recompute();
    }

    void addWords({required int total, required int correct}) {
        final incorrect = math.max(0, total - correct);
        state = state.copyWith(
            totalWords: state.totalWords + total,
            correctWords: state.correctWords + correct,
            incorrectWords: state.incorrectWords + incorrect,
        );
        _recompute();
    }

    /// Typically called by a ticker/timer from the session
    void setDuration(Duration d) {
        state = state.copyWith(duration: d);
        _recompute();
    }

    /// Recompute accuracy, WPM, CPM from the current counters + duration
    void _recompute() {
        final secs = state.duration.inMilliseconds / 1000.0;
        final mins = secs > 0 ? (secs / 60.0) : 0.0;

        // Accuracy = correct chars / total chars * 100
        final acc = state.totalCharacters > 0
            ? (state.correctCharacters / state.totalCharacters) * 100.0
            : 0.0;

        // WPM = (total characters / 5) / minutes
        final wpm = (mins > 0 && state.totalCharacters > 0)
            ? ((state.totalCharacters / 5.0) / mins)
            : 0.0;

        // CPM = total characters / minutes
        final cpm = (mins > 0 && state.totalCharacters > 0)
            ? (state.totalCharacters / mins)
            : 0.0;

        state = state.copyWith(
            accuracy: acc,
            wpm: wpm,
            cpm: cpm,
        );
    }
}
