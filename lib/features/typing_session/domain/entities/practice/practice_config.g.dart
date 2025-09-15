// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PracticeConfig _$PracticeConfigFromJson(Map<String, dynamic> json) =>
    _PracticeConfig(
      mode:
          $enumDecodeNullable(_$ExpertiseModeEnumEnumMap, json['mode']) ??
          ExpertiseModeEnum.normal,
      difficulty:
          $enumDecodeNullable(_$DifficultyEnumEnumMap, json['difficulty']) ??
          DifficultyEnum.easy,
      contentLength:
          $enumDecodeNullable(_$TextLengthEnumEnumMap, json['contentLength']) ??
          TextLengthEnum.short,
      contentFontSize:
          $enumDecodeNullable(_$TextSizeEnumEnumMap, json['contentFontSize']) ??
          TextSizeEnum.L,
      blindMode: json['blindMode'] as bool? ?? false,
      randomize: json['randomize'] as bool? ?? true,
      wpmEnabled: json['wpmEnabled'] as bool? ?? true,
      accuracyEnabled: json['accuracyEnabled'] as bool? ?? true,
      timerEnabled: json['timerEnabled'] as bool? ?? true,
      errorsEnabled: json['errorsEnabled'] as bool? ?? false,
      allowPauses: json['allowPauses'] as bool? ?? true,
      allowTakeBacks: json['allowTakeBacks'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? false,
      soundOnError: json['soundOnError'] as bool? ?? false,
      hapticEnabled: json['hapticEnabled'] as bool? ?? false,
      hapticOnError: json['hapticOnError'] as bool? ?? false,
      darkMode: json['darkMode'] as bool? ?? true,
    );

Map<String, dynamic> _$PracticeConfigToJson(_PracticeConfig instance) =>
    <String, dynamic>{
      'mode': _$ExpertiseModeEnumEnumMap[instance.mode]!,
      'difficulty': _$DifficultyEnumEnumMap[instance.difficulty]!,
      'contentLength': _$TextLengthEnumEnumMap[instance.contentLength]!,
      'contentFontSize': _$TextSizeEnumEnumMap[instance.contentFontSize]!,
      'blindMode': instance.blindMode,
      'randomize': instance.randomize,
      'wpmEnabled': instance.wpmEnabled,
      'accuracyEnabled': instance.accuracyEnabled,
      'timerEnabled': instance.timerEnabled,
      'errorsEnabled': instance.errorsEnabled,
      'allowPauses': instance.allowPauses,
      'allowTakeBacks': instance.allowTakeBacks,
      'soundEnabled': instance.soundEnabled,
      'soundOnError': instance.soundOnError,
      'hapticEnabled': instance.hapticEnabled,
      'hapticOnError': instance.hapticOnError,
      'darkMode': instance.darkMode,
    };

const _$ExpertiseModeEnumEnumMap = {
  ExpertiseModeEnum.normal: 'normal',
  ExpertiseModeEnum.expert: 'expert',
  ExpertiseModeEnum.master: 'master',
};

const _$DifficultyEnumEnumMap = {
  DifficultyEnum.easy: 'easy',
  DifficultyEnum.medium: 'medium',
  DifficultyEnum.hard: 'hard',
};

const _$TextLengthEnumEnumMap = {
  TextLengthEnum.short: 'short',
  TextLengthEnum.medium: 'medium',
  TextLengthEnum.long: 'long',
};

const _$TextSizeEnumEnumMap = {
  TextSizeEnum.XS: 'XS',
  TextSizeEnum.S: 'S',
  TextSizeEnum.M: 'M',
  TextSizeEnum.L: 'L',
  TextSizeEnum.XL: 'XL',
};
