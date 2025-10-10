


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/enums/difficulty/AccuracyThresholdEnum.dart';
import 'package:kothai_app/enums/difficulty/DifficultyEnum.dart';
import 'package:kothai_app/enums/difficulty/DifficultyTimeLimitEnum.dart';
import 'package:kothai_app/enums/difficulty/DifficultyWPM.dart';
import 'package:kothai_app/enums/MulplierEnum.dart';

part 'difficulty.freezed.dart';
part 'difficulty.g.dart';

@freezed
abstract class Difficulty with _$Difficulty {
  const factory Difficulty({
    @Default(DifficultyEnum.easy) DifficultyEnum level,
    @Default(AccuracyThresholdEnum.accuracyEasy) AccuracyThresholdEnum accuracyThreshold,
    @Default(DifficultyWPMEnum.wpmEasy) DifficultyWPMEnum wpmThreshold,
    @Default(DifficultyTimeLimit.limitEasy) DifficultyTimeLimit timeLimit,
    @Default(XpMultiplier.easy) XpMultiplier xpMultiplier,
  }) = _Difficulty;

  factory Difficulty.fromJson(Map<String, dynamic> json) => _$DifficultyFromJson(json);
}
