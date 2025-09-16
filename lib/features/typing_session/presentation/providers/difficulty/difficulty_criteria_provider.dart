

import 'package:kothai_app/di/poviders/difficulty_criteia_provider.dart';
import 'package:kothai_app/features/typing_session/domain/entities/difficulty/difficulty_criteria.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/accuracy_threshold_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_time_limit_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_wpm_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/multipliers_enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'difficulty_criteria_provider.g.dart';

@Riverpod(keepAlive: false)
class DifficultyCriteriaNotifier extends _$DifficultyCriteriaNotifier {
    @override
    DifficultyCriteria build() {
        // default state when provider is first created
        final defaults = DifficultyCriteria(
            level: DifficultyEnum.easy,
            accuracyThreshold: AccuracyThresholdEnum.accuracyEasy,
            wpmThreshold: DifficultyWPMEnum.wpmEasy,
            timeLimit: DifficultyTimeLimit.limitEasy,
            xpMultiplier: XpMultiplier.easy
        );


        // try restore (fire-and-forget then update state)
        Future.microtask(() async {
            final repo = ref.read(difficultyCriteriaRepositoryProvider);
            final saved = await repo.load();
            if (saved != null) state = saved;
        });

        return defaults;
    }

    Future<void> setDifficulty({
        DifficultyEnum? level,
        AccuracyThresholdEnum? accuracyThreshold,
        DifficultyWPMEnum? wpmThreshold,
        DifficultyTimeLimit? timeLimit,
        XpMultiplier? xpMultiplier
    }) async {
        state = state.copyWith(
            level: level ?? state.level,
            accuracyThreshold: accuracyThreshold ?? state.accuracyThreshold,
            wpmThreshold: wpmThreshold ?? state.wpmThreshold,
            timeLimit: timeLimit ?? state.timeLimit,
            xpMultiplier: xpMultiplier ?? state.xpMultiplier
        );

        // persist
        await ref.read(difficultyCriteriaRepositoryProvider).save(state);
    }

    // convenience updaters that also persist
    Future<void> updateAccuracy(AccuracyThresholdEnum value) =>
        setDifficulty(accuracyThreshold: value);

    Future<void> updateWpm(DifficultyWPMEnum value) =>
        setDifficulty(wpmThreshold: value);

    Future<void> updateLevel(DifficultyEnum newLevel, XpMultiplier multiplier) =>
        setDifficulty(level: newLevel, xpMultiplier: multiplier);
}
