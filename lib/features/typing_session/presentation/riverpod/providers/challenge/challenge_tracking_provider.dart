import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/challenge/challenges_to_prefs.dart';
import 'package:kothai_app/features/typing_session/domain/contracts/challenge/store_challenge_to_prefs.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_tracking_provider.g.dart';

@riverpod
StoreChallengeToPrefs challengeSessionToPrefs(Ref ref) {
    final prefs = ref.watch(sharedPrefsServiceProvider);
    return ChallengeSessionToPrefs(prefs);
}

// Key scheme for saving/loading challenge tracking per difficulty
String challengePrefsKeyFor(DifficultyEnum difficulty) =>
'${difficulty.name}_challenge.v1';

// Returns which difficulties should be hidden for 24h (i.e., have a recent record)
final hiddenChallengesProvider = FutureProvider<Set<DifficultyEnum>>((
        ref
    ) async {
        final store = ref.watch(challengeSessionToPrefsProvider);
        final now = DateTime.now();
        final hidden = <DifficultyEnum>{};

        for (final difficulty in DifficultyEnum.values) {
            try {
                final key = challengePrefsKeyFor(difficulty);
                final data = await store.load(key);
                if (data == null) continue;

                final ts = DateTime.tryParse(data.timestamp);
                if (ts == null) continue;

                final diffHours = now.difference(ts).inHours;
                if (diffHours < 24) {
                    hidden.add(difficulty);
                }
            } catch (_) {
                // Ignore malformed data; treat as not hidden
            }
        }

        return hidden;
    });

// Synchronous provider that provides immediate feedback
final hiddenChallengesSyncProvider = Provider<Set<DifficultyEnum>>((ref) {
        final hiddenChallengesAsync = ref.watch(hiddenChallengesProvider);
        return hiddenChallengesAsync.when(
            data: (hidden) => hidden,
            loading: () => <DifficultyEnum>{}, // Show as not blocked while loading
            error: (_, __) => <DifficultyEnum>{} // Show as not blocked on error
        );
    });

// Provider that returns the completion timestamps for each difficulty
final challengeCompletionTimestampsProvider =
    FutureProvider<Map<DifficultyEnum, DateTime>>((ref) async {
            final store = ref.watch(challengeSessionToPrefsProvider);
            final timestamps = <DifficultyEnum, DateTime>{};

            for (final difficulty in DifficultyEnum.values) {
                try {
                    final key = challengePrefsKeyFor(difficulty);
                    final data = await store.load(key);
                    if (data == null) continue;

                    final ts = DateTime.tryParse(data.timestamp);
                    if (ts == null) continue;

                    timestamps[difficulty] = ts;
                } catch (_) {
                    // Ignore malformed data
                }
            }

            return timestamps;
        });

// Synchronous provider for completion timestamps
final challengeCompletionTimestampsSyncProvider =
    Provider<Map<DifficultyEnum, DateTime>>((ref) {
            final timestampsAsync = ref.watch(challengeCompletionTimestampsProvider);
            return timestampsAsync.when(
                data: (timestamps) => timestamps,
                loading: () => <DifficultyEnum, DateTime>{},
                error: (_, __) => <DifficultyEnum, DateTime>{}
            );
        });
