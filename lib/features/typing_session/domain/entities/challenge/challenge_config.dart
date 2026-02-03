
import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_config.freezed.dart';
part 'challenge_config.g.dart';

@freezed
abstract class ChallengeConfig with _$ChallengeConfig {
    const factory ChallengeConfig({
        @Default(false) bool soundEnabled,
        @Default(false) bool hapticEnabled,
        @Default(true) bool darkMode,
        @Default(false) bool notificationsEnabled,
    }) = _ChallengeConfig;

    factory ChallengeConfig.fromJson(Map<String, dynamic> json) =>
        _$ChallengeConfigFromJson(json);
}