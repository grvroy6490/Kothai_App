import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/constants/typing_session_constants.dart';
import 'package:kothai_app/features/typing_session/domain/entities/challenge/challenge_tracking_entity.dart';
import 'package:kothai_app/features/typing_session/domain/entities/session/session_entity.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/session/complete/session_complete_page.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/score/score_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_state_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/typing_progress_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/challenge/challenge_tracking_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/session/session_repo_provider.dart';
import 'package:kothai_app/features/typing_session/usecases/score/score_calculation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'session_controller_provider.g.dart';

@riverpod
class SessionController extends _$SessionController {
  final _logger = Logger();
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
    final paragraph = await ref.read(textContentControllerProvider);
    // reset metrics
    ref.read(metricsStateControllerProvider.notifier).reset();
    ref
        .read(metricsStateControllerProvider.notifier)
        .setTotalChars(paragraph!.content.length);

    // start engine
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
    ref.read(sessionStateNotifierProvider.notifier).reset();
    ref.read(metricsStateControllerProvider.notifier).reset();
    ref.read(userInputProvider.notifier).clear();
  }

  Future<void> stop() async {
    // stop engine
    final engine = ref.read(sessionStateNotifierProvider.notifier);
    engine.stop();

    // clear user input
    final userInput = ref.read(userInputProvider.notifier);
    userInput.clear();
  }

  Future<void> complete() async {
    final st = ref.read(sessionStateNotifierProvider);
    final gamificationData = ref.read(gamificationDataControllerProvider);
    final difficultyCriteria = gamificationData?.difficultyCriteria
        .where(
          (criteria) =>
              criteria.type.toLowerCase() == _difficulty.name.toLowerCase(),
        )
        .firstOrNull;
    if (_mode == SessionMode.challenge) {
      // mark streak after successful completion
      // Store the current challenge for 24H
      final challenge = ChallengeTrackingEntity(
        difficulty: _difficulty,
        timestamp: DateTime.now().toString(),
      );

      _logger.f(challenge);

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

      // Mark streak for today when challenge is completed
      await ref.read(streakControllerProvider.notifier).markActiveToday();

      // For testing: Add yesterday's streak to create a 2-day streak
      // TODO: Remove this after testing
      // final yesterday = DateTime.now().subtract(const Duration(days: 1));
      // await ref
      //     .read(streakControllerProvider.notifier)
      //     .addStreakForDay(yesterday);

      // Invalidate the challenge tracking providers to trigger UI update
      ref.invalidate(hiddenChallengesProvider);
      ref.invalidate(challengeCompletionTimestampsProvider);
    }

    final xp = _mode == SessionMode.practice
        ? 50
        : calculateXP(
            totalChars: ref.read(metricsStateControllerProvider).totalChars,
            difficultyMultiplier: difficultyCriteria,
            wpm: ref.read(metricsStateControllerProvider).wpm,
            accuracyPercent: ref.read(metricsStateControllerProvider).accuracy,
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

    await ref
        .read(scoreControllerProvider.notifier)
        .award(
          amount: xp.toInt(),
          mode: _mode.toString(),
          sessionId: session.id,
        );
  }

  void onBackspace() {
    final cfg = ref.read(practiceConfigurationProvider);
    if (!cfg.allowTakeBacks) return;

    ref.read(sessionStateNotifierProvider.notifier).rollbackCursor();
    ref.read(metricsStateControllerProvider.notifier).rollbackLast();
  }

  // Keystroke bridge:
  Future<void> onKey({required bool correct}) async {
    // startIfNotRunning();
    // update metrics
    ref.read(metricsStateControllerProvider.notifier).commit(correct: correct);
    // advance cursor if correct
    if (correct) {
      ref.read(sessionStateNotifierProvider.notifier).advanceCursor();
    }

    // check completion
    final progress = ref.read(typingProgressProvider);
    if (progress >= 1.0) {
      stop();
      await complete();
      // mark streak after successful completion
      Get.to(
        () => SessionCompletePage(),
        transition: Transition.fadeIn,
        curve: Curves.easeInOutQuad,
      );
    }
  }
}
