// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChallengeConfig _$ChallengeConfigFromJson(Map<String, dynamic> json) =>
    _ChallengeConfig(
      soundEnabled: json['soundEnabled'] as bool? ?? false,
      hapticEnabled: json['hapticEnabled'] as bool? ?? false,
      darkMode: json['darkMode'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      dailyRemindersEnabled: json['dailyRemindersEnabled'] as bool? ?? true,
      streakAlertsEnabled: json['streakAlertsEnabled'] as bool? ?? true,
      achievementAlertsEnabled:
          json['achievementAlertsEnabled'] as bool? ?? true,
      productUpdatesEnabled: json['productUpdatesEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$ChallengeConfigToJson(_ChallengeConfig instance) =>
    <String, dynamic>{
      'soundEnabled': instance.soundEnabled,
      'hapticEnabled': instance.hapticEnabled,
      'darkMode': instance.darkMode,
      'notificationsEnabled': instance.notificationsEnabled,
      'dailyRemindersEnabled': instance.dailyRemindersEnabled,
      'streakAlertsEnabled': instance.streakAlertsEnabled,
      'achievementAlertsEnabled': instance.achievementAlertsEnabled,
      'productUpdatesEnabled': instance.productUpdatesEnabled,
    };
