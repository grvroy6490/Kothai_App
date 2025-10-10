

import 'dart:async';

import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_state_provider.g.dart';

class SessionState {
    final bool running;
    final String target;
    final int cursor;
    final Duration elapsed;
    const SessionState({
        this.running = false,
        this.target = '',
        this.cursor = 0,
        this.elapsed = Duration.zero
    });

    SessionState copyWith({bool? running, String? target, int? cursor, Duration? elapsed}) {
        return SessionState(
            running: running ?? this.running,
            target: target ?? this.target,
            cursor: cursor ?? this.cursor,
            elapsed: elapsed ?? this.elapsed
        );
    }
}


@riverpod
class SessionStateNotifier extends _$SessionStateNotifier {
    Timer? _timer;
    final _logger = Logger();

    @override
    SessionState build() {
        // automatically cancel when provider is disposed
        ref.onDispose(() {
                _timer?.cancel();
            });
        return const SessionState();
    }

    // 👇 Session Start Function
    void start({required String target}) {
        _timer?.cancel();
        state = SessionState(running: true, target: target, cursor: 0, elapsed: Duration.zero);

        // also zero metrics elapsed at start
        ref.read(metricsStateControllerProvider.notifier).setElapsed(Duration.zero);

        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                if (!state.running) return;
                final nextElapsed = state.elapsed + const Duration(seconds: 1);
                state = state.copyWith(elapsed: nextElapsed);

                // 🔁 keep Metrics in sync so WPM updates live
                ref.read(metricsStateControllerProvider.notifier).setElapsed(nextElapsed);
            });
    }

    void pause() => state = state.copyWith(running: false);
    void resume() => state = state.copyWith(running: true);

    void reset() {
        _timer?.cancel();
        state = const SessionState();
        // TODO: If needed to reset the metrics typed to reset WPM
        // zero metrics elapsed as well
        ref.read(metricsStateControllerProvider.notifier).setElapsed(Duration.zero);
        start(target: state.target);
    }

    void stop() {
        _timer?.cancel();
        state = state.copyWith(running: false);
        // push the final elapsed into Metrics once more (defensive)
        ref.read(metricsStateControllerProvider.notifier).setElapsed(state.elapsed);
    }

    void advanceCursor() {
        if (state.cursor < state.target.length) {
            state = state.copyWith(cursor: state.cursor + 1);
        }
    }

    void rollbackCursor() {
        if (state.cursor > 0) {
            state = state.copyWith(cursor: state.cursor - 1);
        }
    }

}