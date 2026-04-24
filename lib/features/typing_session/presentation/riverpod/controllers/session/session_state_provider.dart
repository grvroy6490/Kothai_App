import 'dart:async';

import 'package:visai/features/keyboard/presentation/tamil_keyboard/letters.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
// import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

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
  Duration _accumulatedElapsed = Duration.zero;
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
      return _accumulatedElapsed;
    }
    final now = DateTime.now();
    return _accumulatedElapsed + now.difference(_startTime!);
  }

  // 👇 Session Start Function
  void start({required String target}) {
    _timer?.cancel();
    _startTime = DateTime.now();
    _accumulatedElapsed = Duration.zero;
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

      // Keep the exact elapsed time in session state so all screens
      // read the same source before and after completion.
      final preciseElapsed = getCurrentElapsed();
      state = state.copyWith(elapsed: preciseElapsed);

      // 🔁 keep Metrics in sync with precise elapsed time for real-time WPM updates
      ref
          .read(metricsStateControllerProvider.notifier)
          .setElapsed(preciseElapsed);
    });
  }

  void pause() {
    if (!state.running) return;
    final elapsedSinceStart = getCurrentElapsed();
    _accumulatedElapsed = elapsedSinceStart;
    state = state.copyWith(
      running: false,
      elapsed: elapsedSinceStart,
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
    _accumulatedElapsed = Duration.zero;
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
    _accumulatedElapsed = Duration.zero;
    state = const SessionState();
    // zero metrics elapsed
    ref.read(metricsStateControllerProvider.notifier).setElapsed(Duration.zero);
    // Restart with the same target if it exists
    if (currentTarget.isNotEmpty) {
      start(target: currentTarget);
    }
  }

  void stop() {
    final finalElapsed = getCurrentElapsed();
    _accumulatedElapsed = finalElapsed;
    state = state.copyWith(running: false, elapsed: finalElapsed);
    // push the final elapsed into Metrics
    ref.read(metricsStateControllerProvider.notifier).setElapsed(finalElapsed);
    _startTime = null;
    _timer?.cancel();
  }

  /// Max position must use the same NFC + diacritic pass as
  /// [ChallengeEditor] / [PracticeEditorPage] (`nfcPara` length), not
  /// [String.length] on raw [SessionState.target] (UTF-16 can differ after NFC).
  void advanceCursor() {
    if (state.target.isEmpty) return;
    final nfcLen = unorm.nfc(
      Letters.applyDiacriticCompositions(state.target),
    ).length;
    if (state.cursor < nfcLen) {
      state = state.copyWith(cursor: state.cursor + 1);
    }
  }

  void rollbackCursor() {
    if (state.cursor > 0) {
      state = state.copyWith(cursor: state.cursor - 1);
    }
  }
}
