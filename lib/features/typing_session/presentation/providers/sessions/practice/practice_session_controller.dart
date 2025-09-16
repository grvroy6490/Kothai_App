

import 'package:kothai_app/core/constants/typin_session_constants.dart';
import 'package:kothai_app/di/poviders/db_provider.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_paragraph.dart';
import 'package:kothai_app/features/typing_session/domain/entities/session/typing_session.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/content/text_providers.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/metrics/metrics_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practise_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/progress/practice_progress_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/user_input/user_input_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/sessions/session_state/session_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'practice_session_controller.g.dart';

@riverpod
class PracticeSessionController extends _$PracticeSessionController {
    @override
    void build() {
    }

    // wire up whatever config you have; using defaults here for clarity
    DifficultyEnum get _difficulty => DifficultyEnum.easy;
    SessionMode get _mode => SessionMode.practice;

    Future<void> start() async {
        // pick text
        final paragraph = ref.read(textContentProvider);

        // reset metrics
        ref.read(metricsNotifierProvider.notifier).reset();
        ref.read(metricsNotifierProvider.notifier).setTotalChars(paragraph!.content.length);

        // start engine
        ref.read(sessionStateNotifierProvider.notifier).start(target: paragraph.content ?? placeholderText);
    }

    void pause()  => ref.read(sessionStateNotifierProvider.notifier).pause();
    void resume() => ref.read(sessionStateNotifierProvider.notifier).resume();

    void reset() {
        ref.read(sessionStateNotifierProvider.notifier).reset();
        ref.read(metricsNotifierProvider.notifier).reset();
        ref.read(userInputProvider.notifier).clear();
    }

    Future<void> stop() async {
        // stop engine
        final engine = ref.read(sessionStateNotifierProvider.notifier);
        engine.stop();

        final st = ref.read(sessionStateNotifierProvider);

        // snapshot metrics
        final m = ref.read(metricsNotifierProvider);
        final ended = DateTime.now();
        final started = ended.subtract(st.elapsed);

        final session = TypingSession(
            id: const Uuid().v4(),
            mode: _mode,
            difficulty: _difficulty,
            startedAt: started,
            endedAt: ended,
            metrics: m.copyWith(elapsedMs: st.elapsed.inMilliseconds)
        );

        // save last session
        await ref.read(lastSessionStoreProvider).save(session);
        // save to local DB (FIFO = 7)
        await ref.read(sessionLocalRepoProvider).add(session);

        // clear user input
        final userInput = ref.read(userInputProvider.notifier);
        userInput.clear();
    }

    Future<void> startIfNotRunning() async {
        final s = ref.read(sessionStateNotifierProvider);
        if (s.running || s.cursor != 0) return;

        // Ensure we have a paragraph
        var para = ref.read(textContentProvider); // TextParagraph? in your app
        if (para == null) {
            final list = await ref.read(preloadedTextsProvider.future); // your existing Future<List<TextParagraph>>
            if (list.isNotEmpty) {
                ref.read(textContentProvider.notifier).setTextContent(list.first);
                para = list.first;
            } else {
                // Fallback: set any placeholder so progress isn’t null-based
                ref.read(textContentProvider.notifier).setTextContent(
                    TextParagraph(difficulty: ref.watch(practiceConfigurationProvider).difficulty, content: "Placeholder text"),
                );
                para = ref.read(textContentProvider);
            }
        }

        await start(); // now we definitely have target text
    }

    void onBackspace() {
        final cfg = ref.read(practiceConfigurationProvider);
        if (!cfg.allowTakeBacks) return;

        ref.read(sessionStateNotifierProvider.notifier).rollbackCursor();
        ref.read(metricsNotifierProvider.notifier).rollbackLast();
    }

    // Keystroke bridge:
    void onKey({required bool correct}) {
        startIfNotRunning();
        // update metrics
        ref.read(metricsNotifierProvider.notifier).commit(correct: correct);
        // advance cursor if correct
        if (correct) {
            ref.read(sessionStateNotifierProvider.notifier).advanceCursor();
        }

        // check completion
        final progress = ref.read(practiceProgressProvider);
        if (progress >= 1.0) {
            stop();
        }
    }
}