import 'dart:async';

import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
// import 'package:logger/logger.dart';
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
    this.elapsed = Duration.zero,
  });

  SessionState copyWith({
    bool? running,
    String? target,
    int? cursor,
    Duration? elapsed,
  }) {
    return SessionState(
      running: running ?? this.running,
      target: target ?? this.target,
      cursor: cursor ?? this.cursor,
      elapsed: elapsed ?? this.elapsed,
    );
  }
}

@riverpod
class SessionStateNotifier extends _$SessionStateNotifier {
  Timer? _timer;
  DateTime? _startTime;
  // final _logger = Logger();

  @override
  SessionState build() {
    // automatically cancel when provider is disposed
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const SessionState();
  }

  /// Get current elapsed time (calculated on-demand for precision)
  /// This is useful for immediate WPM calculations on keystroke
  Duration getCurrentElapsed() {
    if (_startTime == null || !state.running) {
      return state.elapsed;
    }
    final now = DateTime.now();
    return now.difference(_startTime!);
  }

  // 👇 Session Start Function
  void start({required String target}) {
    _timer?.cancel();
    _startTime = DateTime.now();
    state = SessionState(
      running: true,
      target: target,
      cursor: 0,
      elapsed: Duration.zero,
    );

    // also zero metrics elapsed at start
    ref.read(metricsStateControllerProvider.notifier).setElapsed(Duration.zero);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!state.running || _startTime == null) return;

      // Calculate precise elapsed time
      final now = DateTime.now();
      final preciseElapsed = now.difference(_startTime!);

      // Update state every second (for display purposes)
      final secondsElapsed = preciseElapsed.inSeconds;
      final lastSecondsElapsed = state.elapsed.inSeconds;

      if (secondsElapsed != lastSecondsElapsed) {
        state = state.copyWith(elapsed: Duration(seconds: secondsElapsed));
      }

      // 🔁 keep Metrics in sync with precise elapsed time for real-time WPM updates
      ref
          .read(metricsStateControllerProvider.notifier)
          .setElapsed(preciseElapsed);
    });
  }

  void pause() {
    if (!state.running || _startTime == null) return;
    // Calculate elapsed up to pause point
    final now = DateTime.now();
    final elapsedSinceStart = now.difference(_startTime!);
    state = state.copyWith(
      running: false,
      elapsed: state.elapsed + elapsedSinceStart,
    );
    _startTime = null;
    // Update metrics with final elapsed time
    ref.read(metricsStateControllerProvider.notifier).setElapsed(state.elapsed);
  }

  void resume() {
    if (state.running || _startTime != null) return;
    _startTime = DateTime.now();
    state = state.copyWith(running: true);
  }

  void reset() {
    _timer?.cancel();
    _startTime = null;
    state = const SessionState();
    // TODO: If needed to reset the metrics typed to reset WPM
    // zero metrics elapsed as well
    ref.read(metricsStateControllerProvider.notifier).setElapsed(Duration.zero);
    // Don't restart the timer here - it should only start when explicitly calling start() with a valid target
  }

  void restart() {
    final currentTarget = state.target;
    _timer?.cancel();
    _startTime = null;
    state = const SessionState();
    // zero metrics elapsed
    ref.read(metricsStateControllerProvider.notifier).setElapsed(Duration.zero);
    // Restart with the same target if it exists
    if (currentTarget.isNotEmpty) {
      start(target: currentTarget);
    }
  }

  void stop() {
    // Calculate final elapsed time
    if (_startTime != null && state.running) {
      final now = DateTime.now();
      final elapsedSinceStart = now.difference(_startTime!);
      final finalElapsed = state.elapsed + elapsedSinceStart;
      state = state.copyWith(running: false, elapsed: finalElapsed);
      // push the final elapsed into Metrics
      ref
          .read(metricsStateControllerProvider.notifier)
          .setElapsed(finalElapsed);
    } else {
      state = state.copyWith(running: false);
      // push the final elapsed into Metrics once more (defensive)
      ref
          .read(metricsStateControllerProvider.notifier)
          .setElapsed(state.elapsed);
    }
    _startTime = null;
    _timer?.cancel();
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
