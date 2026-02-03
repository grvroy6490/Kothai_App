import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/data/models/practice/practice_settings.dart';
import 'package:kothai_app/data/models/session/difficulty.dart';
import 'package:kothai_app/enums/ConfigDisplayType.dart';
import 'package:kothai_app/enums/ContentFontSize.dart';
import 'package:kothai_app/enums/ContentLength.dart';
import 'package:kothai_app/enums/MulplierEnum.dart';
import 'package:kothai_app/enums/difficulty/AccuracyThresholdEnum.dart';
import 'package:kothai_app/enums/difficulty/DifficultyEnum.dart';
import 'package:kothai_app/enums/ModeEnum.dart';
import 'package:kothai_app/enums/difficulty/DifficultyTimeLimitEnum.dart';
import 'package:kothai_app/enums/difficulty/DifficultyWPM.dart';
import 'package:kothai_app/presentation/providers/session/difficulty_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kothai_app/core/constants/constants.dart';


class PracticeSettingsNotifier extends StateNotifier<PracticeSettings> {
    PracticeSettingsNotifier(this.ref) : super(const PracticeSettings()) {
        _load();
    }

    final Ref ref;

    // Map your enum to a concrete Difficulty preset.
    // TODO: replace placeholder values with your real presets.
    Difficulty _difficultyFromEnum(DifficultyEnum e) {
        switch (e) {
            case DifficultyEnum.easy:
                return Difficulty(
                    level: DifficultyEnum.easy,
                    accuracyThreshold: AccuracyThresholdEnum.accuracyEasy,
                    timeLimit: DifficultyTimeLimit.limitEasy,
                    wpmThreshold: DifficultyWPMEnum.wpmEasy,
                    xpMultiplier: XpMultiplier.easy,
                );
            case DifficultyEnum.medium:
                return Difficulty(
                    level: DifficultyEnum.medium,
                    accuracyThreshold: AccuracyThresholdEnum.accuracyMedium,
                    timeLimit: DifficultyTimeLimit.limitMedium,
                    wpmThreshold: DifficultyWPMEnum.wpmMedium,
                    xpMultiplier: XpMultiplier.medium,
                );

            case DifficultyEnum.hard:
                return Difficulty(
                    level: DifficultyEnum.hard,
                    accuracyThreshold: AccuracyThresholdEnum.accuracyHigh,
                    timeLimit: DifficultyTimeLimit.limitHard,
                    wpmThreshold: DifficultyWPMEnum.wpmHard,
                    xpMultiplier: XpMultiplier.hard,
                );

            // If you have more enums, handle them here.
          case DifficultyEnum.special:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
    }

    // Keep this inside the notifier and use `Ref`, not `WidgetRef`.
    void _updateDifficultyObject(Difficulty d) {
        ref.read(difficultyNotifierProvider.notifier).setDifficulty(
            accuracyThreshold: d.accuracyThreshold,
            level: d.level,
            timeLimit: d.timeLimit,
            wpmThreshold: d.wpmThreshold,
            xpMultiplier: d.xpMultiplier,
        );
    }

    Future<void> _load() async {
        try {
            final prefs = await SharedPreferences.getInstance();
            final raw = prefs.getString(kPracticeModePrefsKey);
            if (raw != null) {
                final decoded = PracticeSettings.fromJson(
                    jsonDecode(raw) as Map<String, dynamic>,
                );
                state = decoded;
            } else {
                // first run → persist defaults so future migrations have a base
                await _save(state);
            }
        } catch (e, st) {
            if (kDebugMode) {
                print('PracticeSettings load failed: $e\n$st');
            }
            // fall back to defaults already in `state`
            await _save(state);
        }

        // After state is established, sync the external difficulty object.
        final d = _difficultyFromEnum(state.difficulty);
        _updateDifficultyObject(d);
    }

    Future<void> _save(PracticeSettings s) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(kPracticeModePrefsKey, jsonEncode(s.toJson()));
        state = s; // plain model, not AsyncValue
    }

    Future<void> _update(PracticeSettings Function(PracticeSettings) fn) async {
        final updated = fn(state);
        await _save(updated);
    }

    // ---------- setters / toggles ----------
    Future<void> setMode(PracticeMode v) => _update((s) => s.copyWith(mode: v));

    Future<void> setDifficulty(DifficultyEnum v) async {
        // 1) Persist the enum to settings.
        await _update((s) => s.copyWith(difficulty: v));
        // 2) Push the resolved Difficulty preset to the external provider.
        _updateDifficultyObject(_difficultyFromEnum(v));
    }

    Future<void> setContentLength(ContentLength v) =>
    _update((s) => s.copyWith(contentLength: v));

    Future<void> setContentFontSize(ContentFontSize v) =>
    _update((s) => s.copyWith(contentFontSize: v));

    Future<void> setConfigDisplayType(ConfigDisplayType v) =>
    _update((s) => s.copyWith(configType: v));

    Future<void> toggleBlindMode() =>
    _update((s) => s.copyWith(blindMode: !s.blindMode));
    Future<void> toggleRandomize() =>
    _update((s) => s.copyWith(randomize: !s.randomize));
    Future<void> toggleWpm() =>
    _update((s) => s.copyWith(wpmEnabled: !s.wpmEnabled));
    Future<void> toggleAccuracy() =>
    _update((s) => s.copyWith(accuracyEnabled: !s.accuracyEnabled));
    Future<void> toggleTimer() =>
    _update((s) => s.copyWith(timerEnabled: !s.timerEnabled));
    Future<void> toggleErrors() =>
    _update((s) => s.copyWith(errorsEnabled: !s.errorsEnabled));
    Future<void> toggleAllowPauses() =>
    _update((s) => s.copyWith(allowPauses: !s.allowPauses));
    Future<void> toggleAllowTakeBacks() =>
    _update((s) => s.copyWith(allowTakeBacks: !s.allowTakeBacks));
    Future<void> toggleSound() =>
    _update((s) => s.copyWith(soundEnabled: !s.soundEnabled));
    Future<void> toggleSoundOnError() =>
    _update((s) => s.copyWith(soundOnError: !s.soundOnError));
    Future<void> toggleHaptics() =>
    _update((s) => s.copyWith(hapticEnabled: !s.hapticEnabled));
    Future<void> toggleHapticsOnError() =>
    _update((s) => s.copyWith(hapticOnError: !s.hapticOnError));
    Future<void> toggleDarkMode() =>
    _update((s) => s.copyWith(darkMode: !s.darkMode));

    Future<void> replace(PracticeSettings next) => _save(next);
    Future<void> reset() => _save(const PracticeSettings());
}

final practiceConfigurationProvider =
    StateNotifierProvider<PracticeSettingsNotifier, PracticeSettings>(
        (ref) => PracticeSettingsNotifier(ref),
    );
