

import 'package:kothai_app/core/constants/typing_session_constants.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_handler_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_state_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/typing_progress_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_controller_provider.g.dart';

@riverpod
class SessionController extends _$SessionController {

    @override
    SessionState build() {
        return SessionState();
    }

    SessionMode get _mode => ref.watch(sessionHandlerControllerProvider.select((value) => value.mode));

    Future<void> start() async {
        final paragraph = await ref.read(textContentControllerProvider);

        // reset metrics
        ref.read(metricsStateControllerProvider.notifier).reset();
        ref.read(metricsStateControllerProvider.notifier).setTotalChars(paragraph!.content.length);

        // start engine
        ref.read(sessionStateNotifierProvider.notifier).start(target: paragraph.content ?? placeholderText);

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

        final st = ref.read(sessionStateNotifierProvider);

        // snapshot metrics
        final m = ref.read(metricsStateControllerProvider);
        final ended = DateTime.now();
        final started = ended.subtract(st.elapsed);

        // TODO: SAVE SESSION TO DB & STORE LAST SESSION TO PREFS
        // final session = TypingSession(
        //     id: const Uuid().v4(),
        //     mode: _mode,
        //     difficulty: _difficulty,
        //     startedAt: started,
        //     endedAt: ended,
        //     metrics: m.copyWith(elapsedMs: st.elapsed.inMilliseconds)
        // );
        //
        // // save last session
        // await ref.read(lastSessionStoreProvider).save(session);
        // // save to local DB (FIFO = 7)
        // await ref.read(sessionLocalRepoProvider).add(session);

        // clear user input
        final userInput = ref.read(userInputProvider.notifier);
        userInput.clear();
    }

    // Future<void> startIfNotRunning() async {
    //     final s = ref.read(sessionStateNotifierProvider);
    //     if (s.running || s.cursor != 0) return;
    //
    //     // Ensure we have a paragraph
    //     var para = ref.read(textContentControllerProvider); // TextParagraph? in your app
    //     if (para == null) {
    //
    //         final list = _mode == SessionMode.challenge
    //             ? await ref.read(preloadChallengeInitialContentControllerProvider.future)
    //             : await ref.read(preloadPracticeInitialContentControllerProvider.future);
    //
    //         // ✅ Fix: Check if list exists and is not empty
    //         if (list != null && list.isNotEmpty) {
    //             final firstParagraph = list.first;
    //
    //             // Set paragraph into controller
    //             ref.read(textContentControllerProvider.notifier).setTextContent(firstParagraph);
    //
    //             // Update local variable (not using return value of setTextContent)
    //             para = firstParagraph;
    //         } else {
    //             // ✅ Fallback: placeholder to avoid null
    //             final difficulty = ref.watch(practiceConfigurationProvider).difficulty;
    //
    //             final placeholder = TextContent(
    //                 difficulty: difficulty,
    //                 content: "Placeholder text"
    //             );
    //
    //             ref.read(textContentControllerProvider.notifier).setTextContent(placeholder);
    //             para = placeholder;
    //         }
    //     }
    //
    //     await start(); // now we definitely have target text
    // }

    void onBackspace() {
        final cfg = ref.read(practiceConfigurationProvider);
        if (!cfg.allowTakeBacks) return;

        ref.read(sessionStateNotifierProvider.notifier).rollbackCursor();
        ref.read(metricsStateControllerProvider.notifier).rollbackLast();
    }

    // Keystroke bridge:
    void onKey({required bool correct}) {
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
        }
    }

}
