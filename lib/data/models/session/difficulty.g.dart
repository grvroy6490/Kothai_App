// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'difficulty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Difficulty _$DifficultyFromJson(Map<String, dynamic> json) => _Difficulty(
  level:
      $enumDecodeNullable(_$DifficultyEnumEnumMap, json['level']) ??
      DifficultyEnum.easy,
  accuracyThreshold:
      $enumDecodeNullable(
        _$AccuracyThresholdEnumEnumMap,
        json['accuracyThreshold'],
      ) ??
      AccuracyThresholdEnum.accuracyEasy,
  wpmThreshold:
      $enumDecodeNullable(_$DifficultyWPMEnumEnumMap, json['wpmThreshold']) ??
      DifficultyWPMEnum.wpmEasy,
  timeLimit:
      $enumDecodeNullable(_$DifficultyTimeLimitEnumMap, json['timeLimit']) ??
      DifficultyTimeLimit.limitEasy,
  xpMultiplier:
      $enumDecodeNullable(_$XpMultiplierEnumMap, json['xpMultiplier']) ??
      XpMultiplier.easy,
);

Map<String, dynamic> _$DifficultyToJson(_Difficulty instance) =>
    <String, dynamic>{
      'level': _$DifficultyEnumEnumMap[instance.level]!,
      'accuracyThreshold':
          _$AccuracyThresholdEnumEnumMap[instance.accuracyThreshold]!,
      'wpmThreshold': _$DifficultyWPMEnumEnumMap[instance.wpmThreshold]!,
      'timeLimit': _$DifficultyTimeLimitEnumMap[instance.timeLimit]!,
      'xpMultiplier': _$XpMultiplierEnumMap[instance.xpMultiplier]!,
    };

const _$DifficultyEnumEnumMap = {
  DifficultyEnum.easy: 'easy',
  DifficultyEnum.medium: 'medium',
  DifficultyEnum.hard: 'hard',
  DifficultyEnum.special: 'special',
};

const _$AccuracyThresholdEnumEnumMap = {
  AccuracyThresholdEnum.accuracyEasy: 'accuracyEasy',
  AccuracyThresholdEnum.accuracyMedium: 'accuracyMedium',
  AccuracyThresholdEnum.accuracyHigh: 'accuracyHigh',
};

const _$DifficultyWPMEnumEnumMap = {
  DifficultyWPMEnum.wpmEasy: 'wpmEasy',
  DifficultyWPMEnum.wpmMedium: 'wpmMedium',
  DifficultyWPMEnum.wpmHard: 'wpmHard',
};

const _$DifficultyTimeLimitEnumMap = {
  DifficultyTimeLimit.limitEasy: 'limitEasy',
  DifficultyTimeLimit.limitMedium: 'limitMedium',
  DifficultyTimeLimit.limitHard: 'limitHard',
};

const _$XpMultiplierEnumMap = {
  XpMultiplier.easy: 'easy',
  XpMultiplier.medium: 'medium',
  XpMultiplier.hard: 'hard',
};
