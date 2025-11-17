// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PracticeSettings _$PracticeSettingsFromJson(Map<String, dynamic> json) =>
    _PracticeSettings(
      mode:
          $enumDecodeNullable(_$PracticeModeEnumMap, json['mode']) ??
          PracticeMode.normal,
      difficulty:
          $enumDecodeNullable(_$DifficultyEnumEnumMap, json['difficulty']) ??
          DifficultyEnum.easy,
      contentLength:
          $enumDecodeNullable(_$ContentLengthEnumMap, json['contentLength']) ??
          ContentLength.short,
      contentFontSize:
          $enumDecodeNullable(
            _$ContentFontSizeEnumMap,
            json['contentFontSize'],
          ) ??
          ContentFontSize.l,
      configType:
          $enumDecodeNullable(_$ConfigDisplayTypeEnumMap, json['configType']) ??
          ConfigDisplayType.detailed,
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

Map<String, dynamic> _$PracticeSettingsToJson(_PracticeSettings instance) =>
    <String, dynamic>{
      'mode': _$PracticeModeEnumMap[instance.mode]!,
      'difficulty': _$DifficultyEnumEnumMap[instance.difficulty]!,
      'contentLength': _$ContentLengthEnumMap[instance.contentLength]!,
      'contentFontSize': _$ContentFontSizeEnumMap[instance.contentFontSize]!,
      'configType': _$ConfigDisplayTypeEnumMap[instance.configType]!,
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

const _$PracticeModeEnumMap = {
  PracticeMode.normal: 'normal',
  PracticeMode.expert: 'expert',
  PracticeMode.master: 'master',
};

const _$DifficultyEnumEnumMap = {
  DifficultyEnum.easy: 'easy',
  DifficultyEnum.medium: 'medium',
  DifficultyEnum.hard: 'hard',
  DifficultyEnum.special: 'special',
};

const _$ContentLengthEnumMap = {
  ContentLength.short: 'short',
  ContentLength.medium: 'medium',
  ContentLength.long: 'long',
};

const _$ContentFontSizeEnumMap = {
  ContentFontSize.xs: 'xs',
  ContentFontSize.s: 's',
  ContentFontSize.m: 'm',
  ContentFontSize.l: 'l',
  ContentFontSize.xl: 'xl',
};

const _$ConfigDisplayTypeEnumMap = {
  ConfigDisplayType.detailed: 'detailed',
  ConfigDisplayType.short: 'short',
};
