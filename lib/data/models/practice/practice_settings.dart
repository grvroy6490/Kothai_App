import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/enums/ConfigDisplayType.dart';
import 'package:kothai_app/enums/ContentFontSize.dart';
import 'package:kothai_app/enums/difficulty/DifficultyEnum.dart';
import 'package:kothai_app/enums/ModeEnum.dart';
import 'package:kothai_app/enums/ContentLength.dart';

part 'practice_settings.freezed.dart';
part 'practice_settings.g.dart';

@freezed
abstract class PracticeSettings with _$PracticeSettings {
  const factory PracticeSettings({
    @Default(PracticeMode.normal) PracticeMode mode,
    @Default(DifficultyEnum.easy) DifficultyEnum difficulty,
    @Default(ContentLength.short) ContentLength contentLength,
    @Default(ContentFontSize.l) ContentFontSize contentFontSize,
    @Default(ConfigDisplayType.detailed) ConfigDisplayType  configType,
    @Default(false) bool blindMode,
    @Default(true) bool randomize,
    @Default(true) bool wpmEnabled,
    @Default(true) bool accuracyEnabled,
    @Default(true) bool timerEnabled,
    @Default(false) bool errorsEnabled,
    @Default(true) bool allowPauses,
    @Default(false) bool allowTakeBacks,
    @Default(false) bool soundEnabled,
    @Default(false) bool soundOnError,
    @Default(false) bool hapticEnabled,
    @Default(false) bool hapticOnError,
    @Default(true) bool darkMode,
  }) = _PracticeSettings;

  factory PracticeSettings.fromJson(Map<String, dynamic> json) =>
      _$PracticeSettingsFromJson(json);
}
