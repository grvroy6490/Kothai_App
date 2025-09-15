

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/accuracy_threshold_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_time_limit_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_wpm_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/multipliers_enums.dart';

part 'difficulty_criteria.freezed.dart';
part 'difficulty_criteria.g.dart';

@freezed
abstract class DifficultyCriteria with _$DifficultyCriteria {
    const factory DifficultyCriteria({
        @Default(DifficultyEnum.easy) DifficultyEnum level,
        @Default(AccuracyThresholdEnum.accuracyEasy) AccuracyThresholdEnum accuracyThreshold,
        @Default(DifficultyWPMEnum.wpmEasy) DifficultyWPMEnum wpmThreshold,
        @Default(DifficultyTimeLimit.limitEasy) DifficultyTimeLimit timeLimit,
        @Default(XpMultiplier.easy) XpMultiplier xpMultiplier
    }) = _DifficultyCriteria;

    factory DifficultyCriteria.fromJson(Map<String, dynamic> json) => _$DifficultyCriteriaFromJson(json);
}
