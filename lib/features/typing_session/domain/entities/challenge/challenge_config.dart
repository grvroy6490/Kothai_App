import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_config.freezed.dart';
part 'challenge_config.g.dart';

@freezed
abstract class ChallengeConfig with _$ChallengeConfig {
  const factory ChallengeConfig({
    @Default(false) bool soundEnabled,
    @Default(false) bool hapticEnabled,
    @Default(true) bool darkMode,

    /// Master switch — gates all OS + in-app notification surfaces.
    @Default(true) bool notificationsEnabled,

    /// Daily practice reminder at the configured time.
    @Default(true) bool dailyRemindersEnabled,

    /// Evening streak-at-risk + comeback win-back reminders.
    @Default(true) bool streakAlertsEnabled,

    /// Badge unlock + level-up local notifications (and in-app feed rows).
    @Default(true) bool achievementAlertsEnabled,

    /// Remote FCM product / content announcements.
    @Default(true) bool productUpdatesEnabled,
  }) = _ChallengeConfig;

  factory ChallengeConfig.fromJson(Map<String, dynamic> json) =>
      _$ChallengeConfigFromJson(json);
}