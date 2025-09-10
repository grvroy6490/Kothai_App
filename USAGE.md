## Practice Setting Notifier Usage

```
    // Watch (AsyncValue)
    final settingsAsync = ref.watch(practiceSettingsNotifierProvider);
    final settings = settingsAsync.valueOrNull ?? const PracticeSettings();
    
    // Toggle a switch
    Switch(
      value: settings.soundOnError,
      onChanged: (_) =>
          ref.read(practiceSettingsNotifierProvider.notifier).toggleSoundOnError(),
    );
    
    // Set enums (e.g., Difficulty.Hard)
    ref.read(practiceSettingsNotifierProvider.notifier)
       .setDifficulty(Difficulty.hard);
       
    // Watch whole settings
    final settings = ref.watch(practiceSettingsNotifierProvider).value;
    
    // Access just one property
    final isSoundOnError = settings?.soundOnError ?? false;
    
    // Optimized way
    final soundOnError = ref.watch(
      practiceSettingsNotifierProvider.select((s) => s.value?.soundOnError ?? false),
    );
    
    // How to read
    final darkMode = ref.watch(
      practiceSettingsProvider.select((s) => s.darkMode),
    );
    
    // Update
    Future<void> toggleDarkMode() async {
      await _update((s) => s.copyWith(darkMode: !s.darkMode));
    }
    
    Future<void> setDifficulty(Difficulty value) async {
      await _update((s) => s.copyWith(difficulty: value));
    }
    
    // In Widget
    Switch(
      value: ref.watch(
        practiceSettingsNotifierProvider.select((s) => s.value?.darkMode ?? true),
      ),
      onChanged: (_) {
        ref.read(practiceSettingsNotifierProvider.notifier).toggleDarkMode();
      },
    );
    
    // Multiple at once
    await ref.read(practiceSettingsProvider.notifier).update((s) => s.copyWith(
      darkMode: true,
      difficulty: Difficulty.hard,
      soundEnabled: false,
    ));
    
    // Listen to difficulty changes
    ref.listen<PracticeSettings>(
      practiceSettingsProvider.select((s) => s.difficulty),
      (prev, next) {
        if (mounted) {
          setState(() {
            _selectedDifficulty = next;
          });
        }
      },
    );

```

## Difficulty Notifier Usage

### Purpose:
 - Keeps track of the current difficulty settings (level, accuracy/WPM thresholds, XP multiplier, time limit). Basically, the "rules" of the game for the active session.

### Usage:

```dart
    // Read current difficulty
    final difficulty = ref.watch(difficultyNotifierProvider);
    print(difficulty.level); // "easy"
    
    // Update difficulty
    ref.read(difficultyNotifierProvider.notifier)
       .setDifficulty(level: "hard", wpmThreshold: 60);
```

## METHOD:

 - setDifficulty({String? level, double? accuracyThreshold, double? wpmThreshold, Duration? timeLimit, XpMultiplier? xpMultiplier,})
 - updateAccuracy(double value)
 - updateWpm(double value)
 - updateLevel(String newLevel, XpMultiplier multiplier)






## Typing Session and Metrics Notifier

### Purpose:
 - Represents the domain model for a completed or in-progress session (TypingSession with mode, difficulty, timestamps, metrics). Good for saving/exporting or sharing results.

### Usage:

```dart
    // End the session and sync metrics into TypingSession
    ref.read(typingSessionNotifierProvider.notifier).endSession();
    
    // Read snapshot
    final finalSession = ref.read(typingSessionNotifierProvider);
    if (finalSession != null) {
      print(finalSession.metrics.accuracy);
    }

```
## TYPING SESSION METHODS:

- startSession({required SessionMode mode, required Difficulty difficulty})
- endSession()
- syncMetrics()


```
    // Start a session
    ref.read(typingSessionNotifierProvider.notifier).startSession(
      mode: SessionMode.practice,
      difficulty: Difficulty.easy,
    );
    
    // On each key press
    ref.read(metricsNotifierProvider.notifier).addChars(total: 1, correct: isCorrect ? 1 : 0);
    
    // When a word boundary is detected
    ref.read(metricsNotifierProvider.notifier).addWords(total: 1, correct: wordCorrect ? 1 : 0);
    
    // Periodically (e.g., every frame/timer) to keep session snapshot in sync
    ref.read(typingSessionNotifierProvider.notifier).syncMetrics();
    
    // End a session
    ref.read(typingSessionNotifierProvider.notifier).endSession();
    final finalSession = ref.read(typingSessionNotifierProvider);
    // -> Persist finalSession to your storage
```








## Metrics Provider

### Purpose:
 - Holds the live typing performance numbers (words typed, characters typed, correct/incorrect counts, WPM, CPM, accuracy, duration). Updated as user types.

### Usage:

```dart
    // Read live metrics
    final metrics = ref.watch(metricsNotifierProvider);
    print(metrics.wpm);
    
    // Update metrics as characters/words come in
    ref.read(metricsNotifierProvider.notifier)
       .addChars(total: 1, correct: 1);
```

## METRICS METHODS:

 - reset()
 - setCounts({int? totalWords, int? correctWords, int? incorrectWords, int? totalCharacters, int? correctCharacters, int? incorrectCharacters,})
 - addWords({int total = 0, int correct = 0})
 - addChars({int total = 0, int correct = 0})
 - setDuration(Duration duration)







## Session History Notifier

### Purpose:
 - Manages persistence of finished sessions (load history, add a session, clear history). Uses SharedPreferences/Hive (your repo) under the hood.

### Usage:

```dart
    // Load all past sessions
    final history = ref.watch(sessionHistoryProvider);
    history.when(
      data: (sessions) => print(sessions.length),
      loading: () => print("Loading..."),
      error: (e, _) => print("Error $e"),
    );
    
    // Add session to history
    final session = ref.read(typingSessionNotifierProvider); // last ended session
    if (session != null) {
      ref.read(sessionHistoryProvider.notifier).add(session);
    }

```

## METHODS:

 - Future<void> reload()
 - Future<void> add(TypingSession session)
 - Future<void> clear()



## Session State Notifier

### Purpose:
 - Controls the active typing run state: the target paragraph, cursor, typed keys, errors, elapsed time, pause/resume/stop. It’s low-level, tied to the actual typing flow.

### Usage:

```dart
    // Start a typing run
    ref.read(typingSessionProvider.notifier).start(target: "தமிழ் பத்தி...");
    
    // Handle keystrokes
    ref.read(typingSessionProvider.notifier).typeChar("அ");
    
    // Pause/resume
    ref.read(typingSessionProvider.notifier).pause();
    ref.read(typingSessionProvider.notifier).resume();
    
    // Stop
    ref.read(typingSessionProvider.notifier).stop();
    
    // Read state
    final sessionState = ref.watch(typingSessionProvider);
    print(sessionState.cursor); // current cursor index

```

## METHODS:

 - void start({required String target})
 - void pause()
 - void resume()
 - void stop()
 - void typeChar(String char)
 - void backspace()

## PROVIDERS:

 - sessionElapsedProvider (Duration)
 - sessionProgressProvider (double 0..1)
 - sessionAccuracyProvider (double %)
 - sessionWpmProvider (double words per minute)


```
    // In your widget build:
    final progress = ref.watch(sessionProgressProvider); // 0..1
    final accuracy = ref.watch(sessionAccuracyProvider); // %
    final wpm = ref.watch(sessionWpmProvider);           // words per minute
    final elapsed = ref.watch(sessionElapsedProvider);   // Duration
    
    // Starting a session
    ElevatedButton(
      onPressed: () {
        ref.read(typingSessionProvider.notifier).start(
          target: "உங்கள் தமிழ் டைப்பிங் பயிற்சி இங்கே தொடங்குகிறது.",
        );
      },
      child: const Text('Start'),
    );
        
    // Typing a char (wire this to your editor/keyboard callback)
    onKey: (String ch) {
      ref.read(typingSessionProvider.notifier).typeChar(ch);
    },
    
    // Backspace
    onBackspace: () {
      ref.read(typingSessionProvider.notifier).backspace();
    },
    
    // Pause/Resume/Stop
    IconButton(
      icon: const Icon(Icons.pause),
      onPressed: () => ref.read(typingSessionProvider.notifier).pause(),
    ),
    IconButton(
      icon: const Icon(Icons.play_arrow),
      onPressed: () => ref.read(typingSessionProvider.notifier).resume(),
    ),
    IconButton(
      icon: const Icon(Icons.stop),
      onPressed: () => ref.read(typingSessionProvider.notifier).stop(),
    ),
    
    // Show metrics
    Text('Progress: ${(progress * 100).toStringAsFixed(0)}%'),
    Text('Accuracy: ${accuracy.toStringAsFixed(1)}%'),
    Text('WPM: ${wpm.toStringAsFixed(1)}'),
    Text('Time: ${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}'),
```




## Session State Selector

### Purpose:
 - Lightweight Providers (or one combined provider) that expose derived values like progress, accuracy, elapsed, WPM. Prevents widgets from rebuilding on unrelated state changes.

### Usage:

```dart
    // Subscribe only to progress
    final progress = ref.watch(sessionProgressProvider);
    
    // Or, if you merged into one:
    final wpm = ref.watch(sessionDerivedProvider.select((d) => d.wpm));

```


## How they flow together

    - DifficultyProvider → defines session rules (XP, thresholds).

    - SessionStateProvider → runs the actual typing session (keystrokes, timing).

    - MetricsProvider → aggregates live performance numbers.

    - TypingSessionProvider → wraps up the run into a TypingSession domain model.

    - TypingSessionHistoryProvider → saves/retrieves finished sessions.

    - SessionStateSelector → gives widgets efficient access to only what they need.
