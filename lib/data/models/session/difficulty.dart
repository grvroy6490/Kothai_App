


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:visai/enums/difficulty/AccuracyThresholdEnum.dart';
import 'package:visai/enums/difficulty/DifficultyEnum.dart';
import 'package:visai/enums/difficulty/DifficultyTimeLimitEnum.dart';
import 'package:visai/enums/difficulty/DifficultyWPM.dart';
import 'package:visai/enums/MulplierEnum.dart';

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
