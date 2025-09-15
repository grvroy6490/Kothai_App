

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
        return DifficultyCriteria(
            level: DifficultyEnum.easy,
            accuracyThreshold: AccuracyThresholdEnum.accuracyEasy,
            wpmThreshold: DifficultyWPMEnum.wpmEasy,
            timeLimit: DifficultyTimeLimit.limitEasy,
            xpMultiplier: XpMultiplier.easy
        );
    }

    void setDifficulty({
        DifficultyEnum? level,
        AccuracyThresholdEnum? accuracyThreshold,
        DifficultyWPMEnum? wpmThreshold,
        DifficultyTimeLimit? timeLimit,
        XpMultiplier? xpMultiplier
    }) {
        state = state.copyWith(
            level: level ?? state.level,
            accuracyThreshold: accuracyThreshold ?? state.accuracyThreshold,
            wpmThreshold: wpmThreshold ?? state.wpmThreshold,
            timeLimit: timeLimit ?? state.timeLimit,
            xpMultiplier: xpMultiplier ?? state.xpMultiplier
        );

    }

    // Convenience updaters
    void updateAccuracy(AccuracyThresholdEnum value) {
        state = state.copyWith(accuracyThreshold: value);
    }

    void updateWpm(DifficultyWPMEnum value) {
        state = state.copyWith(wpmThreshold: value);
    }

    void updateLevel(DifficultyEnum newLevel, XpMultiplier multiplier) {
        state = state.copyWith(level: newLevel, xpMultiplier: multiplier);
    }
}
