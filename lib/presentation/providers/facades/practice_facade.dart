

import 'package:kothai_app/data/models/session/difficulty.dart';
import 'package:kothai_app/enums/SessionMode.dart';
import 'package:kothai_app/presentation/providers/session/difficulty_provider.dart';
import 'package:kothai_app/presentation/providers/session/session_state_provider.dart';
import 'package:kothai_app/presentation/providers/session/typing_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'practice_facade.g.dart';

@riverpod
class PracticeFacade extends _$PracticeFacade {
    @override
    void build() {
        // no state to hold; this is a command facade
    }

    void setDifficulty(Difficulty d) {
        // if you also keep thresholds/xp by difficulty, pass those here
        ref.read(difficultyNotifierProvider.notifier).setDifficulty(level: d.level, accuracyThreshold: d.accuracyThreshold, wpmThreshold: d.wpmThreshold, timeLimit: d.timeLimit);
    }

    void startSession({
        required String target,
        required Difficulty difficulty,
        SessionMode mode = SessionMode.practice,
    }) {
        // set chosen difficulty first (if UI hasn't)
        ref.read(difficultyNotifierProvider.notifier).setDifficulty(level: difficulty.level, accuracyThreshold: difficulty.accuracyThreshold, wpmThreshold: difficulty.wpmThreshold, timeLimit: difficulty.timeLimit);
        // boot the session
        ref.read(sessionStateProvider.notifier).start(target: target);
        ref.read(typingSessionNotifierProvider.notifier).startSession(mode: mode, difficulty: difficulty);
    }



    void endSession() {
        ref.read(sessionStateProvider.notifier).stop();
        ref.read(typingSessionNotifierProvider.notifier).endSession();
    }


    //
    // Future<void> endSessionAndPersist({
    //     required SessionMode mode,
    //     required Difficulty difficulty,
    // }) async {
    //     // end session (updates elapsed)
    //     ref.read(typingSessionProvider.notifier).stop();
    //
    //     // snapshot -> build final TypingSession model (from your other provider)
    //     // if you already have a TypingSessionNotifier that builds the model, call it here.
    //     // or, reuse the one we made earlier:
    //     ref.read(typingSessionNotifierProvider.notifier).endSession();
    //     final finalSession = ref.read(typingSessionNotifierProvider);
    //     if (finalSession != null) {
    //         await ref.read(sessionHistoryProvider.notifier).add(finalSession);
    //     }
    // }

    // convenience write-throughs to lower layers
    // void typeChar(String ch) => ref.read(typingSessionProvidernotifier).typeChar(ch);
    // void backspace() => ref.read(typingSessionProvider.notifier).backspace();
    // void pause() => ref.read(typingSessionProvider.notifier).pause();
    // void resume() => ref.read(typingSessionProvider.notifier).resume();
}
