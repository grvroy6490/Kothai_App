// lib/features/session/typing_session_provider.dart
import 'package:kothai_app/data/models/session/difficulty.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:kothai_app/data/models/session/typing_session.dart';
import 'package:kothai_app/enums/SessionMode.dart';

import 'metrics_provider.dart';

part 'typing_session_provider.g.dart';

const _uuid = Uuid();

@Riverpod(keepAlive: true)
class TypingSessionNotifier extends _$TypingSessionNotifier {
    @override
    TypingSession? build() => null; // null = no active session

    /// Start a new session; resets metrics.
    void startSession({
        required SessionMode mode,
        required Difficulty difficulty,
        String? sessionId,
        DateTime? startedAt,
    }) {
        // reset live metrics
        ref.read(metricsNotifierProvider.notifier).reset();

        final now = DateTime.now();
        state = TypingSession(
            sessionId: sessionId ?? _uuid.v4(),
            mode: mode,
            difficulty: difficulty,
            startedAt: startedAt ?? now,
            endedAt: now, // will be updated on end
            metrics: ref.read(metricsNotifierProvider),
        );
    }

    /// Pulls the latest Metrics into the session snapshot (e.g., on UI ticks)
    void syncMetrics() {
        final current = state;
        if (current == null) return;
        final liveMetrics = ref.read(metricsNotifierProvider);
        state = current.copyWith(metrics: liveMetrics);
    }

    /// End the session; capture final metrics & timestamp
    void endSession() {
        final current = state;
        if (current == null) return;
        final liveMetrics = ref.read(metricsNotifierProvider);
        state = current.copyWith(endedAt: DateTime.now(), metrics: liveMetrics);
    }

    /// Convenience flag
    bool get isActive => state != null;
}
