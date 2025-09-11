// lib/domain/entities/session/session_state.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// NEW: for .characters used below
import 'package:characters/characters.dart';

@immutable
class SessionState {
    final String target;            // full paragraph to type
    final int cursor;               // next expected index (0..target.length)
    final int typed;                // total keys typed (including wrong & corrections)
    final int correct;              // number of correct characters typed
    final int errors;               // number of incorrect characters typed
    final Duration elapsed;         // net elapsed (excludes paused time)
    final bool isRunning;
    final bool isPaused;
    final bool isReset;
    final DateTime? _startedAt;     // internal: current run start (null when paused/stopped)

    const SessionState({
        required this.target,
        required this.cursor,
        required this.typed,
        required this.correct,
        required this.errors,
        required this.elapsed,
        required this.isRunning,
        required this.isPaused,
        required this.isReset,
        required DateTime? startedAt,
    }) : _startedAt = startedAt;

    factory SessionState.idle() => SessionState(
        target: '',
        cursor: 0,
        typed: 0,
        correct: 0,
        errors: 0,
        elapsed: Duration.zero,
        isRunning: false,
        isPaused: false,
        isReset: true,
        startedAt: null,
    );

    String get formattedElapsed {
        final minutes = elapsed.inMinutes;
        final seconds = elapsed.inSeconds % 60;
        return '${minutes}m ${seconds}s';
    }

    // progress based on grapheme clusters (unchanged logic; now ensured correct by provider)
    double get progress =>
    target.isEmpty ? 0 : (cursor / target.characters.length).clamp(0.0, 1.0);

    double get accuracy => typed == 0 ? 100.0 : (correct / typed) * 100.0;

    /// WPM uses the standard definition: (characters/5) per minute.
    double get wpm {
        final secs = elapsed.inMilliseconds / 1000.0;
        if (secs <= 0) return 0;
        final minutes = secs / 60.0;
        return (typed / 5.0) / minutes;
    }

    DateTime? get startedAt => _startedAt;

    SessionState copyWith({
        String? target,
        int? cursor,
        int? typed,
        int? correct,
        int? errors,
        Duration? elapsed,
        bool? isRunning,
        bool? isPaused,
        bool? isReset,
        DateTime? startedAt,
    }) {
        return SessionState(
            target: target ?? this.target,
            cursor: cursor ?? this.cursor,
            typed: typed ?? this.typed,
            correct: correct ?? this.correct,
            errors: errors ?? this.errors,
            elapsed: elapsed ?? this.elapsed,
            isRunning: isRunning ?? this.isRunning,
            isPaused: isPaused ?? this.isPaused,
            isReset: isReset ?? this.isReset,
            startedAt: startedAt ?? this._startedAt,
        );
    }
}

extension SessionStateMetrics on SessionState {
    double get accuracyPercent =>
    typed == 0 ? 100.0 : (correct / typed) * 100.0;

    String get formattedAccuracy => '${accuracyPercent.toStringAsFixed(0)}%';
}
