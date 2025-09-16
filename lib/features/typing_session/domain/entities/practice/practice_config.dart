


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/expertise_mode_enums.dart';
import 'package:kothai_app/features/typing_session/domain/enums/text_length_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/text_size_enum.dart';

part 'practice_config.freezed.dart';
part 'practice_config.g.dart';

@freezed
abstract class PracticeConfig with _$PracticeConfig {
    const factory PracticeConfig({
        @Default(ExpertiseModeEnum.normal) ExpertiseModeEnum mode,
        @Default(DifficultyEnum.easy) DifficultyEnum difficulty,
        @Default(TextLengthEnum.short) TextLengthEnum contentLength,
        @Default(TextSizeEnum.L) TextSizeEnum contentFontSize,
        @Default(false) bool blindMode,
        @Default(true) bool randomize,
        @Default(true) bool wpmEnabled,
        @Default(true) bool accuracyEnabled,
        @Default(true) bool timerEnabled,
        @Default(true) bool errorsEnabled,
        @Default(true) bool allowPauses,
        @Default(true) bool allowTakeBacks,
        @Default(false) bool soundEnabled,
        @Default(false) bool soundOnError,
        @Default(false) bool hapticEnabled,
        @Default(true) bool hapticOnError,
        @Default(true) bool darkMode
    }) = _PracticeConfig;

    factory PracticeConfig.fromJson(Map<String, dynamic> json) =>
    _$PracticeConfigFromJson(json);
}