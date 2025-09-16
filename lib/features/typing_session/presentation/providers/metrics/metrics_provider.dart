import 'package:kothai_app/features/typing_session/domain/entities/metrics/metrics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metrics_provider.g.dart';

@Riverpod(keepAlive: true)
class MetricsNotifier extends _$MetricsNotifier {
    @override
    Metrics build() => const Metrics();

    void reset() => state = const Metrics();

    /// Call this once at session start with paragraph.length
    void setTotalChars(int total) {
        if (total < 0) total = 0;
        state = state.copyWith(totalChars: total);
    }

    /// If you have a timer elsewhere (SessionState), sync elapsed here
    void setElapsed(Duration d) {
        state = state.copyWith(elapsedMs: d.inMilliseconds);
    }

    /// Or keep using your incremental tick if you prefer
    void tick(Duration by) {
        state = state.copyWith(elapsedMs: state.elapsedMs + by.inMilliseconds);
    }

    /// Record a keystroke
    void commit({required bool correct}) {
        state = state.copyWith(
            typed: state.typed + 1,
            correct: state.correct + (correct ? 1 : 0),
            errors: state.errors + (correct ? 0 : 1),
        );
    }

    /// Undo last keystroke (for backspace/“take backs”)
    void rollbackLast() {
        if (state.typed == 0) return;

        if (state.errors > 0) {
            state = state.copyWith(
                typed: state.typed - 1,
                errors: state.errors - 1,
            );
        } else if (state.correct > 0) {
            state = state.copyWith(
                typed: state.typed - 1,
                correct: state.correct - 1,
            );
        } else {
            state = state.copyWith(typed: state.typed - 1);
        }
    }
}
