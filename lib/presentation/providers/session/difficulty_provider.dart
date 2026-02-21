import 'package:visai/data/models/session/difficulty.dart';
import 'package:visai/enums/difficulty/AccuracyThresholdEnum.dart';
import 'package:visai/enums/difficulty/DifficultyEnum.dart';
import 'package:visai/enums/MulplierEnum.dart';
import 'package:visai/enums/difficulty/DifficultyTimeLimitEnum.dart';
import 'package:visai/enums/difficulty/DifficultyWPM.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'difficulty_provider.g.dart';

@Riverpod(keepAlive: false)
class DifficultyNotifier extends _$DifficultyNotifier {
    @override
    Difficulty build() {
        // default state when provider is first created
        return Difficulty(
            level: DifficultyEnum.easy,
            accuracyThreshold: AccuracyThresholdEnum.accuracyEasy,
            wpmThreshold: DifficultyWPMEnum.wpmEasy,
            timeLimit: DifficultyTimeLimit.limitEasy,
            xpMultiplier: XpMultiplier.easy,
        );
    }

    void setDifficulty({
        DifficultyEnum? level,
        AccuracyThresholdEnum? accuracyThreshold,
        DifficultyWPMEnum? wpmThreshold,
        DifficultyTimeLimit? timeLimit,
        XpMultiplier? xpMultiplier,
    }) {
        state = state.copyWith(
            level: level ?? state.level,
            accuracyThreshold: accuracyThreshold ?? state.accuracyThreshold,
            wpmThreshold: wpmThreshold ?? state.wpmThreshold,
            timeLimit: timeLimit ?? state.timeLimit,
            xpMultiplier: xpMultiplier ?? state.xpMultiplier,
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
