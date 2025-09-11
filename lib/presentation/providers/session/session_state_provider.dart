// lib/features/practice/session/typing_session_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/domain/entities/session/session_state.dart';
import 'package:kothai_app/presentation/providers/practice/practice_configuration_provider.dart';
// NEW: grapheme-safe splitting
import 'package:characters/characters.dart';

class SessionStateNotifier extends StateNotifier<SessionState> {
    final Ref _ref;
    Timer? _ticker;

    SessionStateNotifier(this._ref) : super(SessionState.idle());

    // ---------- lifecycle ----------
    void start({required String target}) {
        _cancelTicker();
        state = SessionState(
            target: target,
            cursor: 0,
            typed: 0,
            correct: 0,
            errors: 0,
            elapsed: Duration.zero,
            isRunning: true,
            isPaused: false,
            isReset: false,
            startedAt: DateTime.now(),
        );
        _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    }

    void pause() {
        final allowPauses =
            _ref.read(practiceConfigurationProvider).allowPauses; // settings-aware
        if (!state.isRunning || state.isPaused || !allowPauses) return;
        // accumulate elapsed up to now
        final now = DateTime.now();
        final delta = now.difference(state.startedAt!);
        state = state.copyWith(
            elapsed: state.elapsed + delta,
            isPaused: true,
            isReset: false,
            startedAt: null,
        );
    }

    void resume() {
        final allowPauses =
            _ref.read(practiceConfigurationProvider).allowPauses;
        if (!state.isRunning || !state.isPaused || !allowPauses) return;
        state = state.copyWith(
            isPaused: false,
            isReset: false,
            startedAt: DateTime.now(),
        );
    }

    void stop() {
        if (!state.isRunning) return;
        // push any final elapsed
        final now = DateTime.now();
        final extra =
            state.startedAt == null ? Duration.zero : now.difference(state.startedAt!);
        state = state.copyWith(
            elapsed: state.elapsed + extra,
            isRunning: false,
            isPaused: false,
            isReset: false,
            startedAt: null,
        );
        _cancelTicker();
    }

    /// Reset the session back to the idle state
    /// Clears timers and typing history.
    void reset() {
        _cancelTicker();
        _history.clear();
        state = SessionState.idle();
    }

    @override
    void dispose() {
        _cancelTicker();
        super.dispose();
    }

    void _cancelTicker() {
        _ticker?.cancel();
        _ticker = null;
    }

    void _onTick() {
        if (!state.isRunning || state.isPaused || state.startedAt == null) return;

        final now = DateTime.now();
        final delta = now.difference(state.startedAt!); // ~1s per tick
        state = state.copyWith(
            elapsed: state.elapsed + delta,
            startedAt: now, // <-- advance the peg so next tick adds only the next delta
        );
    }

    final List<bool> _history = [];

    // ---------- NEW: tiny helpers to ensure 1 commit == 1 grapheme ----------
    void _commitGrapheme(String g) {
        if (!state.isRunning || state.isPaused) return;
        final total = state.target.characters.length;
        if (state.cursor >= total) return;

        final expected = state.target.characters.elementAt(state.cursor);
        final isCorrect = g == expected;

        _history.add(isCorrect);
        state = state.copyWith(
            cursor: (state.cursor + 1).clamp(0, total),
            typed: state.typed + 1,
            correct: state.correct + (isCorrect ? 1 : 0),
            errors: state.errors + (isCorrect ? 0 : 1),
        );

        if (state.cursor >= total) stop();
    }

    /// Accepts any string, splits into grapheme clusters, and commits each.
    void typeCommit(String text) {
        if (text.isEmpty) return;
        for (final g in text.characters) {
            _commitGrapheme(g);
            if (!state.isRunning) break; // stop when finished exactly
        }
    }

    // ---------- typing input ----------
    /// Call this for every committed character the user types.
    /// Handles correctness vs expected char; advances cursor on commit.
    /// (kept for compatibility; now delegates to typeCommit to be grapheme-safe)
    void typeChar(String ch) {
        typeCommit(ch);
    }

    /// Handle backspace (if allowed). Rewinds cursor and re-accounts metrics.
    void backspace() {
        final allowTakeBacks =
            _ref.read(practiceConfigurationProvider).allowTakeBacks;
        if (!allowTakeBacks || !state.isRunning || state.isPaused) return;
        if (state.cursor == 0 || _history.isEmpty) return;

        final last = _history.removeLast();
        state = state.copyWith(
            cursor: state.cursor - 1,
            typed: state.typed - 1,
            correct: state.correct - (last ? 1 : 0),
            errors: state.errors - (last ? 0 : 1),
        );
    }

    /// Internal: step back one character for IME-style composition
    /// Ignores user settings like allowTakeBacks, but still maintains history.
    void composeBackspace() {
        if (!state.isRunning || state.isPaused) return;
        if (state.cursor == 0 || _history.isEmpty) return;

        final last = _history.removeLast();
        state = state.copyWith(
            cursor: state.cursor - 1,
            typed: state.typed - 1,
            correct: state.correct - (last ? 1 : 0),
            errors: state.errors - (last ? 0 : 1),
        );
    }
}

final sessionStateProvider =
    StateNotifierProvider<SessionStateNotifier, SessionState>(
        (ref) => SessionStateNotifier(ref),
    );
