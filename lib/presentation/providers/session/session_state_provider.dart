// lib/features/practice/session/typing_session_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/domain/entities/session/session_state.dart';
import 'package:visai/presentation/providers/practice/practice_configuration_provider.dart';



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
            startedAt: null,
        );
    }

    void resume() {
        final allowPauses =
            _ref.read(practiceConfigurationProvider).allowPauses;
        if (!state.isRunning || !state.isPaused || !allowPauses) return;
        state = state.copyWith(
            isPaused: false,
            startedAt: DateTime.now(),
        );
    }

    void stop() {
        if (!state.isRunning) return;
        // push any final elapsed
        final now = DateTime.now();
        final extra = state.startedAt == null ? Duration.zero : now.difference(state.startedAt!);
        state = state.copyWith(
            elapsed: state.elapsed + extra,
            isRunning: false,
            isPaused: false,
            startedAt: null,
        );
        _cancelTicker();
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

    // ---------- typing input ----------
    /// Call this for every committed character the user types.
    /// Handles correctness vs expected char; advances cursor on commit.
    void typeChar(String ch) {
        if (!state.isRunning || state.isPaused || state.cursor >= state.target.characters.length) return;

        final expected = state.target.characters.elementAt(state.cursor);
        final isCorrect = ch == expected;

        _history.add(isCorrect);
        state = state.copyWith(
            cursor: (state.cursor + 1).clamp(0, state.target.characters.length),
            typed: state.typed + 1,
            correct: state.correct + (isCorrect ? 1 : 0),
            errors: state.errors + (isCorrect ? 0 : 1),
        );

        if (state.cursor >= state.target.characters.length) stop();
    }

    /// Handle backspace (if allowed). Rewinds cursor and re-accounts metrics.
    void backspace() {
        final allowTakeBacks = _ref.read(practiceConfigurationProvider).allowTakeBacks;
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
}


final sessionStateProvider =
    StateNotifierProvider<SessionStateNotifier, SessionState>(
        (ref) => SessionStateNotifier(ref),
    );
