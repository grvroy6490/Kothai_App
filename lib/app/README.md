

lib/
├─ app/                       # App-wide bootstrapping
│  ├─ app.dart                # MaterialApp / Router config
│  ├─ main_development.dart
│  ├─ main_staging.dart
│  └─ main_production.dart




## Clear boundaries:

- **domain** = pure business rules (no Flutter imports).
- **data** = how you fetch/store things.
- **core** = generic, reusable, UI-agnostic utilities.
- **services** = cross-feature runtime services (auth, analytics).
- **di** = one obvious place to wire dependencies (Riverpod providers).



## DTOs vs Entities (where to put)

- **Entities** → `domain/entities` (UI-agnostic, business truth; Freezed recommended).
- **DTOs** → `data/sources/remote|local` next to the API/cache that produces them.
- **Mappers** → `data/mappers` so you never leak transport shapes into domain/UI.


Barrel files (optional but tidy)

Add `_index.dart` or `*.dart` barrels for commonly imported sets:
- `features/practice/presentation/providers/_providers.dart`
- `core/utils/_utils.dart`
   Only do this where it reduces import noise.


# The Whole Example Map:

lib/
├─ app/
│  └─ app.dart
├─ core/
│  ├─ errors/
│  │  └─ failures.dart
│  ├─ utils/
│  │  └─ time.dart
│  └─ widgets/
│     └─ gap.dart
├─ data/
│  ├─ sources/
│  │  ├─ remote/http_client.dart
│  │  └─ local/shared_prefs_store.dart
│  ├─ repositories/
│  │  └─ typing_session_repo_impl.dart
│  └─ mappers/
│     └─ paragraph_mapper.dart
├─ di/
│  └─ providers.dart
├─ domain/
│  ├─ entities/
│  │  ├─ paragraph.dart
│  │  └─ typing_session.dart
│  ├─ repositories/
│  │  └─ typing_session_repository.dart
│  └─ usecases/
│     ├─ get_paragraphs.dart
│     └─ save_session_result.dart
└─ features/
└─ typing_session/
├─ presentation/
│  ├─ pages/
│  │  └─ typing_page.dart
│  ├─ widgets/
│  │  ├─ wpm_meter.dart
│  │  └─ keyboard_view.dart
│  └─ providers/
│     ├─ typing_controller.dart
│     └─ typing_providers.dart
├─ domain/         # (optional per-feature domain)
└─ data/           # (optional per-feature data)


# Tiny, useful stubs


`domain/entities/paragraph.dart`

``
    import 'package:freezed_annotation/freezed_annotation.dart';
    part 'paragraph.freezed.dart';

    enum Difficulty { easy, medium, hard }

    @freezed
    class Paragraph with _$Paragraph {
        const factory Paragraph({
            required String id,
            required String content,
            required Difficulty difficulty,
            required int wordCount,
        }) = _Paragraph;
    }
``



`domain/entities/typing_session.dart`

``
    import 'package:freezed_annotation/freezed_annotation.dart';
    part 'typing_session.freezed.dart';

    @freezed
    class TypingSession with _$TypingSession {
        const factory TypingSession({
            required String sessionId,
            required String paragraphId,
            required int cursor,
            required int typed,
            required int correct,
            required int errors,
            required Duration elapsed,
            required bool isRunning,
        }) = _TypingSession;
    }
``




`domain/repositories/typing_session_repository.dart`

``
    import '../entities/paragraph.dart';

    abstract class TypingSessionRepository {
        Future<List<Paragraph>> fetchParagraphs({required Difficulty difficulty, int count = 5});
        Future<void> saveResult({
            required String paragraphId,
            required int typed,
            required int correct,
            required int errors,
            required Duration elapsed,
        });
    }
``



`domain/usecases/get_paragraphs.dart`

``
    import '../entities/paragraph.dart';
    import '../repositories/typing_session_repository.dart';

    class GetParagraphs {
        final TypingSessionRepository repo;
        GetParagraphs(this.repo);

        Future<List<Paragraph>> call(Difficulty difficulty, {int count = 5}) {
            return repo.fetchParagraphs(difficulty: difficulty, count: count);
        }
    }
``



`domain/usecases/save_session_result.dart`

``
    import '../repositories/typing_session_repository.dart';

    class SaveSessionResult {
        final TypingSessionRepository repo;
        SaveSessionResult(this.repo);

        Future<void> call({
            required String paragraphId,
            required int typed,
            required int correct,
            required int errors,
            required Duration elapsed,
        }) => repo.saveResult(
            paragraphId: paragraphId,
            typed: typed,
            correct: correct,
            errors: errors,
            elapsed: elapsed,
        );
    }
``



`data/repositories/typing_session_repo_impl.dart`

``
    import 'package:dio/dio.dart';
    import '../../data/mappers/paragraph_mapper.dart';
    import '../../data/sources/remote/http_client.dart';
    import '../../data/sources/local/shared_prefs_store.dart';
    import '../../domain/entities/paragraph.dart';
    import '../../domain/repositories/typing_session_repository.dart';

    class TypingSessionRepositoryImpl implements TypingSessionRepository {
        final Dio http;
        final SharedPrefsStore prefs;
        TypingSessionRepositoryImpl({required this.http, required this.prefs});

        @override
        Future<List<Paragraph>> fetchParagraphs({required Difficulty difficulty, int count = 5}) async {
            final res = await http.get('/paragraphs', queryParameters: {
                'difficulty': difficulty.name,
                'count': count,
            });
            final list = (res.data as List).map((e) => ParagraphMapper.fromJson(e)).toList();
            return list;
        }



        @override
        Future<void> saveResult({
            required String paragraphId,
            required int typed,
            required int correct,
            required int errors,
            required Duration elapsed,
        }) async {
            await http.post('/results', data: {
                paragraphId': paragraphId,
                typed': typed,
                correct': correct,
                errors': errors,
                elapsedMs': elapsed.inMilliseconds,
            });
        }
    }
``



`data/mappers/paragraph_mapper.dart`

``
    import '../../domain/entities/paragraph.dart';

    class ParagraphMapper {
        static Paragraph fromJson(Map<String, dynamic> j) => Paragraph(
            id: j['id'] as String,
            content: j['content'] as String,
            difficulty: Difficulty.values.byName(j['difficulty'] as String),
            wordCount: j['wordCount'] as int,
        );
    }
``



`di/providers.dart (app-wide wiring)`

``
    import 'package:dio/dio.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../data/repositories/typing_session_repo_impl.dart';
    import '../data/sources/local/shared_prefs_store.dart';
    import '../domain/repositories/typing_session_repository.dart';
    import '../domain/usecases/get_paragraphs.dart';
    import '../domain/usecases/save_session_result.dart';

    final dioProvider = Provider<Dio>((ref) => Dio(BaseOptions(baseUrl: 'https://api.example.com')));

    final sharedPrefsStoreProvider = Provider<SharedPrefsStore>((ref) {
        throw UnimplementedError('Override with real instance in main()');
    });

    final typingRepoProvider = Provider<TypingSessionRepository>((ref) {
        return TypingSessionRepositoryImpl(
            http: ref.read(dioProvider),
            prefs: ref.read(sharedPrefsStoreProvider),
        );
    });

    final getParagraphsProvider = Provider<GetParagraphs>((ref) => GetParagraphs(ref.read(typingRepoProvider)));
    final saveSessionResultProvider = Provider<SaveSessionResult>((ref) => SaveSessionResult(ref.read(typingRepoProvider)));
``


`features/typing_session/presentation/providers/typing_controller.dart`

``
    import 'dart:async';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../../../../domain/entities/paragraph.dart';
    import '../../../../domain/usecases/get_paragraphs.dart';
    import '../../../../domain/usecases/save_session_result.dart';

    class TypingState {
        final Paragraph? paragraph;
        final int cursor;
        final int typed;
        final int correct;
        final int errors;
        final Duration elapsed;
        final bool isRunning;

        const TypingState({
            this.paragraph,
            this.cursor = 0,
            this.typed = 0,
            this.correct = 0,
            this.errors = 0,
            this.elapsed = Duration.zero,
            this.isRunning = false,
        });

        double get progress => (paragraph == null || paragraph!.content.isEmpty)
              ? 0
              : cursor / paragraph!.content.length;

        double get accuracy => typed == 0 ? 1.0 : correct / typed;

        /// words per minute (5 chars = 1 word)
        double get wpm => elapsed.inMilliseconds == 0
        ? 0
        : (correct / 5) / (elapsed.inMilliseconds / 60000);

        TypingState copyWith({
            Paragraph? paragraph,
            int? cursor,
            int? typed,
            int? correct,
            int? errors,
            Duration? elapsed,
            bool? isRunning,
        }) => TypingState(
                paragraph: paragraph ?? this.paragraph,
                cursor: cursor ?? this.cursor,
                typed: typed ?? this.typed,
                correct: correct ?? this.correct,
                errors: errors ?? this.errors,
                elapsed: elapsed ?? this.elapsed,
                isRunning: isRunning ?? this.isRunning,
            );
        }

        class TypingController extends AutoDisposeNotifier<TypingState> {
            Timer? _timer;

            @override
            TypingState build() => const TypingState();

            Future<void> load(Difficulty difficulty) async {
                final getParagraphs = ref.read(getParagraphsProvider);
                final list = await getParagraphs(difficulty, count: 1);
                state = state.copyWith(paragraph: list.first, cursor: 0, typed: 0, correct: 0, errors: 0, elapsed: Duration.zero, isRunning: false);
            }

            void start() {
                if (state.paragraph == null || state.isRunning) return;
                state = state.copyWith(isRunning: true);
                _timer?.cancel();
                _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                    state = state.copyWith(elapsed: state.elapsed + const Duration(seconds: 1));
                });
            }

            void pause() {
                _timer?.cancel();
                state = state.copyWith(isRunning: false);
            }

        void reset() {
            _timer?.cancel();
            state = state.copyWith(cursor: 0, typed: 0, correct: 0, errors: 0, elapsed: Duration.zero, isRunning: false);
        }

        void input(String ch) {
            if (state.paragraph == null) return;
            final target = state.paragraph!.content;
            final nextIndex = state.cursor;
            if (nextIndex >= target.length) return;

            final isCorrect = target.codeUnitAt(nextIndex) == ch.codeUnitAt(0);
            state = state.copyWith(
                cursor: nextIndex + (isCorrect ? 1 : 0),
                typed: state.typed + 1,
                correct: state.correct + (isCorrect ? 1 : 0),
                errors: state.errors + (isCorrect ? 0 : 1),
            );
        }

        Future<void> finish() async {
            _timer?.cancel();
            final s = state;
            if (s.paragraph == null) return;
            await ref.read(saveSessionResultProvider).call(
            paragraphId: s.paragraph!.id,
            typed: s.typed,
            correct: s.correct,
            errors: s.errors,
            elapsed: s.elapsed,
        );
        state = s.copyWith(isRunning: false);
    }


    @override
    void dispose() {
        _timer?.cancel();
        super.dispose();
    }
}



`features/typing_session/presentation/providers/typing_providers.dart`

``
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'typing_controller.dart';

    final typingControllerProvider =
    AutoDisposeNotifierProvider<TypingController, TypingState>(TypingController.new);



`features/typing_session/presentation/pages/typing_page.dart`

``
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../providers/typing_providers.dart';

    class TypingPage extends ConsumerWidget {
        const TypingPage({super.key});

        @override
        Widget build(BuildContext context, WidgetRef ref) {
            final state = ref.watch(typingControllerProvider);
            return Scaffold(
                appBar: AppBar(title: const Text('Typing Session')),
                body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        children: [
                            LinearProgressIndicator(value: state.progress),
                            const SizedBox(height: 12),
                            Text('WPM: ${state.wpm.toStringAsFixed(1)} • Acc: ${(state.accuracy * 100).toStringAsFixed(0)}%'),
                            const SizedBox(height: 12),
                            Expanded(child: SingleChildScrollView(child: Text(state.paragraph?.content ?? ''))),
                            const SizedBox(height: 12),
                            Row(
                                children: [
                                    ElevatedButton(onPressed: () => ref.read(typingControllerProvider.notifier).start(), child: const Text('Start')),
                                    const SizedBox(width: 8),
                                    ElevatedButton(onPressed: () => ref.read(typingControllerProvider.notifier).pause(), child: const Text('Pause')),
                                    const SizedBox(width: 8),
                                    ElevatedButton(onPressed: () => ref.read(typingControllerProvider.notifier).finish(), child: const Text('Finish')),
                                ],
                            ),
                        ],
                    ),
                ),
            );
        }
    }
``