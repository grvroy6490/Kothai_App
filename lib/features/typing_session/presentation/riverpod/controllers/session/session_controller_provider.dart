import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visai/di/providers/auth/auth_provider.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';
import 'package:visai/enums/StreakModeEnum.dart';
import 'package:visai/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';
import 'package:visai/features/notifications/presentation/riverpod/in_app_notifications_controller.dart';
import 'package:visai/features/typing_session/domain/entities/challenge/challenge_tracking_entity.dart';
import 'package:visai/features/typing_session/domain/entities/session/session_entity.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/presentation/pages/challenge/failed/challenge_failed.dart';
import 'package:visai/features/typing_session/presentation/pages/session/complete/session_complete_page.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/streak_mode_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/score/score_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_state_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/providers/challenge/challenge_tracking_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/providers/session/session_repo_provider.dart';
import 'package:visai/features/user_profile/presentation/riverpod/providers/user_stats_provider.dart';
import 'package:visai/features/typing_session/usecases/score/score_calculation.dart';
// import 'package:logger/logger.dart';
// import 'package:logger/logger.dart';
import 'package:visai/features/keyboard/presentation/tamil_keyboard/letters.dart';
import 'package:visai/features/typing_session/domain/typing_cluster_progress.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'session_controller_provider.g.dart';

@riverpod
class SessionController extends _$SessionController {
  // final _logger = Logger();
  bool _isCompleting = false; // Guard to prevent duplicate completion calls

  @override
  SessionState build() {
    // Mirror the engine state so widgets watching `sessionControllerProvider`
    // receive live updates (e.g., elapsed time ticking every second).
    ref.listen<SessionState>(sessionStateNotifierProvider, (prev, next) {
      state = next;
    });
    return ref.read(sessionStateNotifierProvider);
  }

  SessionMode get _mode => ref.read(sessionStatusControllerProvider).mode;
  DifficultyEnum get _difficulty => _mode == SessionMode.practice
      ? ref.read(practiceConfigurationProvider).difficulty
      : ref.read(challengeDifficultyControllerProvider);

  Future<void> start() async {
    final paragraph = ref.read(textContentControllerProvider);
    if (paragraph == null) return;
    // reset metrics
    ref.read(metricsStateControllerProvider.notifier).reset();
    ref
        .read(metricsStateControllerProvider.notifier)
        .setTotalChars(
          TypingClusterProgress.assess('', paragraph.content).totalTargetClusters,
        );

    // start engine (same [paragraph.content] the editor uses for nfcPara)
    ref
        .read(sessionStateNotifierProvider.notifier)
        .start(target: paragraph.content);
  }

  void pause() {
    ref.read(sessionStateNotifierProvider.notifier).pause();
  }

  void resume() {
    ref.read(sessionStateNotifierProvider.notifier).resume();
  }

  void reset() {
    _isCompleting = false; // Reset completion flag when resetting
    ref.read(sessionStateNotifierProvider.notifier).reset();
    ref.read(metricsStateControllerProvider.notifier).reset();
    ref.read(userInputProvider.notifier).clear();
  }

  void restart() {
    _isCompleting = false; // Reset completion flag when restarting
    ref.read(sessionStateNotifierProvider.notifier).restart();
    ref.read(metricsStateControllerProvider.notifier).reset();
    ref.read(userInputProvider.notifier).clear();
  }

  Future<void> stop() async {
    // stop engine
    final engine = ref.read(sessionStateNotifierProvider.notifier);
    engine.stop();

    // Do not clear [userInputProvider] here. The practice/challenge editor must
    // run `if (typingProgress >= 1.0) { ... }` after the last onKey; clearing
    // here would make progress 0 and skip clearing the TextEditingController.
    // User input is cleared in those editors (or via session status reset when
    // the user stops manually).
  }

  /// Parse time limit string (e.g., "5m", "4m", "3m" or "5:00") to Duration in milliseconds
  int _parseTimeLimitToMs(String timeLimit) {
    try {
      // Handle format like "5m" or "4m"
      if (timeLimit.endsWith('m')) {
        final minutes = int.parse(timeLimit.substring(0, timeLimit.length - 1));
        return minutes * 60 * 1000;
      }
      // Handle format like "5:00"
      final parts = timeLimit.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return (minutes * 60 + seconds) * 1000;
      }
    } catch (e) {
      // _logger.e('Error parsing time limit: $timeLimit - $e');
    }
    return 5 * 60 * 1000; // Default fallback: 5 minutes
  }

  /// Validate challenge completion against criteria
  bool _validateChallenge(
    DifficultyCriteriaEntity criteria,
    double accuracy,
    double wpm,
    int elapsedMs,
  ) {
    final timeLimitMs = _parseTimeLimitToMs(criteria.timelimit);

    // Convert accuracy from 0.0-1.0 to percentage (0-100)
    final accuracyPercent = accuracy * 100;

    // Validate all three criteria
    final accuracyPassed = accuracyPercent >= criteria.accuracy;
    final wpmPassed = wpm >= criteria.wpm;
    final timePassed = elapsedMs <= timeLimitMs;

    final allPassed = accuracyPassed && wpmPassed && timePassed;

    // _logger.f(
    //   'Challenge validation - '
    //   'Accuracy: ${accuracyPercent.toStringAsFixed(1)}% (min: ${criteria.accuracy}%) - ${accuracyPassed ? "PASSED" : "FAILED"}, '
    //   'WPM: ${wpm.toStringAsFixed(1)} (min: ${criteria.wpm}) - ${wpmPassed ? "PASSED" : "FAILED"}, '
    //   'Time: ${elapsedMs ~/ 60000}:${((elapsedMs % 60000) ~/ 1000).toString().padLeft(2, "0")} (max: ${criteria.timelimit}) - ${timePassed ? "PASSED" : "FAILED"}',
    // );

    return allPassed;
  }

  /// Navigate to success or failure page
  void _navigateToResult(bool passed) {
    Get.to(
      () => passed ? SessionCompletePage() : ChallengeFailed(),
      transition: Transition.fadeIn,
      curve: Curves.easeInOutQuad,
    );
  }

  Future<void> complete({bool challengePassed = false}) async {
    // Prevent duplicate completion calls (e.g., when user pastes multiple chars)
    if (_isCompleting) {
      return;
    }
    _isCompleting = true;

    try {
      final st = ref.read(sessionStateNotifierProvider);
      final gamificationData = ref.read(gamificationDataControllerProvider);

      DifficultyCriteriaEntity? difficultyCriteria;
      if (gamificationData != null) {
        difficultyCriteria = gamificationData.difficultyCriteria
            .where(
              (criteria) =>
                  criteria.type.toLowerCase() == _difficulty.name.toLowerCase(),
            )
            .firstOrNull;
      }

      // Mark streak for today when challenge is completed (regardless of pass/fail)
      if (_mode == SessionMode.challenge) {
        // Mark streak for today - counts as completing a challenge day
        await ref.read(streakControllerProvider.notifier).markActiveToday();

        // BADGE CHECK - Check streak badges after updating streak
        final updatedStreak = ref.read(streakControllerProvider);
        ref
            .read(badgeControllerProvider.notifier)
            .onStreakChanged(Get.context!, updatedStreak.current);

        // Store the current challenge for 24H (regardless of pass/fail) to lock it
        final challenge = ChallengeTrackingEntity(
          difficulty: _difficulty,
          timestamp: DateTime.now().toString(),
        );

        // Save challenge to lock it for 24 hours (even if failed)
        if (_difficulty == DifficultyEnum.easy) {
          await ref
              .read(challengeSessionToPrefsProvider)
              .save(challenge, kEasyChallenge);
        } else if (_difficulty == DifficultyEnum.medium) {
          await ref
              .read(challengeSessionToPrefsProvider)
              .save(challenge, kMediumChallenge);
        } else if (_difficulty == DifficultyEnum.hard) {
          await ref
              .read(challengeSessionToPrefsProvider)
              .save(challenge, kHardChallenge);
        }

        // Invalidate the challenge tracking providers to trigger UI update
        ref.invalidate(hiddenChallengesProvider);
        ref.invalidate(challengeCompletionTimestampsProvider);

        // Only award badge if challenge passed
        if (challengePassed) {
          ref
              .read(badgeControllerProvider.notifier)
              .onChallengeCompleted(Get.context!);
          // _logger.f(challenge);
        }
      }

      final xp = _mode == SessionMode.practice
          ? 50
          : calculateXP(
              totalChars: ref.read(metricsStateControllerProvider).totalChars,
              difficultyMultiplier: difficultyCriteria,
              wpm: ref.read(metricsStateControllerProvider).wpm,
              accuracyPercent: ref
                  .read(metricsStateControllerProvider)
                  .accuracy,
            );

      // Badge check for session completion (for both practice and challenge).
      final liveMetrics = ref.read(metricsStateControllerProvider);
      ref
          .read(badgeControllerProvider.notifier)
          .onSessionComplete(
            Get.context!,
            accuracy: liveMetrics.accuracy,
            wpm: liveMetrics.wpm,
            mode: _mode,
          );

      // snapshot metrics
      final m = ref.read(metricsStateControllerProvider);
      final ended = DateTime.now();
      final started = ended.subtract(st.elapsed);

      final session = SessionEntity(
        id: const Uuid().v4(),
        mode: _mode,
        difficulty: _difficulty,
        startedAt: started,
        endedAt: ended,
        metrics: m.copyWith(elapsedMs: st.elapsed.inMilliseconds),
      );

      // save last session
      await ref.read(lastSessionToPrefsProvider).save(session);
      // save to local DB (FIFO = 7)
      await ref.read(sessionLocalRepositoryProvider).add(session);

      // Invalidate user stats to refresh the UI with new session data
      ref.invalidate(userStatsProvider);

      await ref
          .read(scoreControllerProvider.notifier)
          .award(
            amount: xp.toInt(),
            mode: _mode.toString(),
            sessionId: session.id,
          );

      // XP tier badges (new_learner, focused_student, …) use *cumulative* total XP
      // per BadgeRepository conditions — must run after award().
      final totalXp = ref.read(scoreControllerProvider).totalXp;
      ref
          .read(badgeControllerProvider.notifier)
          .onXPChanged(Get.context!, totalXp);

      await ref
          .read(inAppNotificationsControllerProvider.notifier)
          .tryAddSessionSummary(
            sessionId: session.id,
            wpm: m.wpm,
            accuracy: m.accuracy,
          );

      // Push progress to Firebase when signed in (practice + challenge).
      if (ref.read(firebaseAuthProvider).currentUser != null) {
        try {
          await ref
              .read(scoreControllerProvider.notifier)
              .syncLocalToFirebase();
        } catch (_) {
          // Network / rules errors must not break completion flow; user can sync manually.
        }
      }
    } finally {
      _isCompleting = false;
    }
  }

  void onBackspace() {
    final cfg = ref.read(practiceConfigurationProvider);
    if (!cfg.allowTakeBacks) return;

    ref.read(sessionStateNotifierProvider.notifier).rollbackCursor();
    ref.read(metricsStateControllerProvider.notifier).rollbackLast();
  }

  // Keystroke bridge:
  Future<void> onKey({required bool correct}) async {
    final sessionState = ref.read(sessionStateNotifierProvider);
    // Only auto-start when the session has NEVER been started (target is empty —
    // i.e. first keystroke or after reset). Do NOT restart when the session was
    // stopped by completion: target is set, running is false.
    if (!sessionState.running && sessionState.target.isEmpty) {
      await start();
    }
    // If still not running (content not ready, or already completed), bail.
    if (!ref.read(sessionStateNotifierProvider).running) return;

    // update metrics
    ref.read(badgeControllerProvider.notifier).onFirstKeystroke(Get.context!);
    ref.read(metricsStateControllerProvider.notifier).commit(correct: correct);

    // Immediately update elapsed time after commit to ensure WPM calculates correctly
    // This is especially important when the first character is wrong, as the timer
    // might not have fired yet (100ms interval). We calculate elapsed time on-demand
    // to get the most accurate value for real-time WPM calculation.
    final currentSessionState = ref.read(sessionStateNotifierProvider);
    if (currentSessionState.running) {
      final sessionNotifier = ref.read(sessionStateNotifierProvider.notifier);
      // Get the precise elapsed time calculated on-demand from start time
      final preciseElapsed = sessionNotifier.getCurrentElapsed();
      // Ensure we have at least 1ms to prevent division by zero in WPM calculation
      final minElapsed = preciseElapsed.inMilliseconds > 0
          ? preciseElapsed
          : const Duration(milliseconds: 1);
      ref.read(metricsStateControllerProvider.notifier).setElapsed(minElapsed);
    }

    // advance cursor if correct
    if (correct) {
      ref.read(sessionStateNotifierProvider.notifier).advanceCursor();
    }

    // check completion
    await _completeSessionIfProgressDone();
  }

  /// Idempotent. Call after [onKey] *or* after the practice/challenge text field
  /// has been processed. Finishes when [SessionState.cursor] has reached the end
  /// of the typing line (same NFC+diacritic length as the editor), not when raw
  /// [userInput] string-equals the target.
  Future<void> maybeFinishSessionByProgress() =>
      _completeSessionIfProgressDone();

  /// After a same-length in-place keyboard edit (ொ/ோ/ௌ, pulli merge), advance
  /// the session cursor for every code unit that now matches the target.
  Future<void> catchUpCursorAfterInPlaceEdit({
    required String paragraph,
    required String typedText,
  }) async {
    if (!ref.read(sessionStateNotifierProvider).running) return;

    final nfcPara = Letters.normalizeTypingText(paragraph);
    final nfcIn = Letters.normalizeTypingText(typedText);
    var cursor = ref.read(sessionStateNotifierProvider).cursor;

    while (cursor < nfcPara.length &&
        cursor < nfcIn.length &&
        nfcIn[cursor] == nfcPara[cursor]) {
      await onKey(correct: true);
      if (!ref.read(sessionStateNotifierProvider).running) return;
      cursor = ref.read(sessionStateNotifierProvider).cursor;
    }
  }

  /// True when the engine is [SessionState.running] and [userInput] has reached
  /// the end of [SessionState.target] (see [_isTargetTextFullyTyped]).
  bool isNormalizedSessionTextComplete() {
    if (!ref.read(sessionStateNotifierProvider).running) {
      return false;
    }
    return _isTargetTextFullyTyped();
  }

  /// Whether the line is “done” for the hidden field: cursor at end, or
  /// [text] (when non-null) / [userInput] is the full line plus optional
  /// trailing input (NFC+diacritic, same as editors).
  bool isNormalizedTextEqualToSessionTarget(String? text) {
    return _isLineCompleteByCursorOrBuffer(override: text);
  }

  bool _isLineCompleteByCursorOrBuffer({String? override}) {
    final st = ref.read(sessionStateNotifierProvider);
    if (st.target.isEmpty) return false;

    final String buffer = override ?? ref.read(userInputProvider);
    return TypingClusterProgress.assess(buffer, st.target).isComplete;
  }

  bool _isTargetTextFullyTyped() {
    return _isLineCompleteByCursorOrBuffer();
  }

  Future<void> _completeSessionIfProgressDone() async {
    if (!ref.read(sessionStateNotifierProvider).running) {
      return;
    }
    // Never use [typingProgressProvider] here: it is only input.length/para.length.
    // Completion is driven by [SessionState.cursor] (see [_isTargetTextFullyTyped]).
    if (!_isTargetTextFullyTyped()) {
      return;
    }

    stop();
    final currentMode = _mode;
    // _logger.f('Session completed in mode: $currentMode');

    // For challenge mode, validate before completing
    if (currentMode == SessionMode.challenge) {
      final gamificationData = ref.read(gamificationDataControllerProvider);

      if (gamificationData == null) {
        // _logger.e('Gamification data is null - cannot validate challenge');
        await complete();
        // Don't reset metrics here - let the complete page read them first
        // Reset will happen when user leaves the complete page
        _navigateToResult(false);
        return;
      }

      final difficultyCriteria = gamificationData.difficultyCriteria
          .where(
            (criteria) =>
                criteria.type.toLowerCase() == _difficulty.name.toLowerCase(),
          )
          .firstOrNull;

      if (difficultyCriteria != null) {
        final metrics = ref.read(metricsStateControllerProvider);
        final st = ref.read(sessionStateNotifierProvider);
        final challengePassed = _validateChallenge(
          difficultyCriteria,
          metrics.accuracy,
          metrics.wpm,
          st.elapsed.inMilliseconds,
        );

        // Complete session (saves data, awards XP, marks streak only if passed)
        await complete(challengePassed: challengePassed);

        // If in restore mode and challenge passed, add the missing day
        final streakModeState = ref.read(streakModeProvider);
        if (challengePassed && streakModeState.mode == StreakModeEnum.restore) {
          final missingDayDate = streakModeState.missingDayDate;
          if (missingDayDate != null) {
            await ref
                .read(streakControllerProvider.notifier)
                .addMissingDay(missingDayDate);
            // _logger.f('✅ Missing streak day restored: ${missingDayDate}');

            // BADGE CHECK - Check streak badges after restoring missing day
            final updatedStreak = ref.read(streakControllerProvider);
            ref
                .read(badgeControllerProvider.notifier)
                .onStreakChanged(Get.context!, updatedStreak.current);

            // Reset to normal mode after restoring
            ref.read(streakModeProvider.notifier).setNormalMode();
          }
        }

        // Don't reset metrics here - let the complete page read them first
        // Reset will happen when user leaves the complete page

        // Navigate based on validation result
        _navigateToResult(challengePassed);
        return;
      } else {
        // _logger.e('Difficulty criteria not found for ${_difficulty.name}');
        // Complete without validation if criteria not found
        await complete();
        // Don't reset metrics here - let the complete page read them first
        // Reset will happen when user leaves the complete page
        _navigateToResult(false);
        return;
      }
    }

    // For practice mode or if criteria not found, complete normally
    await complete();
    // Don't reset metrics here - let the complete page read them first
    // Reset will happen when user leaves the complete page
    _navigateToResult(true);
  }
}
