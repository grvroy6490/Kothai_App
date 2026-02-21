

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/accuracy_threshold_enum.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_time_limit_enum.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_wpm_enum.dart';
import 'package:visai/features/typing_session/domain/enums/expertise_mode_enums.dart';
import 'package:visai/features/typing_session/domain/enums/text_length_enum.dart';
import 'package:visai/features/typing_session/domain/enums/text_size_enum.dart';

class PracticeConfigController extends Notifier<PracticeConfig> {

    @override
    PracticeConfig build() {
        state = PracticeConfig();
        _load();
        return state;
    }

    Future<void> _load() async {
        try {
            final prefs = ref.watch(sharedPrefsServiceProvider);

            final raw = prefs.getString(kPracticeSettingsPrefsKey);
            if (raw != null) {
                final decoded = PracticeConfig.fromJson(
                    jsonDecode(raw) as Map<String, dynamic>
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

        // --- 2) Sync DifficultyCriteria ---
        // final criteria = _difficultyFromEnum(state.difficulty);
        // _updateDifficultyObject(criteria);

        // --- 3) Preload typing texts for current difficulty ---
        // await ref.read(preloadTypingTextsProvider).call(
        //     difficulty: state.difficulty,
        //     randomize: state.randomize
        // );

        // --- 4) Seed TextContent ---
        // final list = await ref.read(preloadedTextsProvider.future);
        // if (list.isNotEmpty) {
        //     ref.read(textContentProvider.notifier).setTextContent(list.first);
        // } else {
        //     ref.read(textContentProvider.notifier).clearTextContent();
        // }
    }

    // Keep this inside the notifier and use `Ref`, not `WidgetRef`.
    // void _updateDifficultyObject(DifficultyCriteria d) {
    //     ref.read(difficultyCriteriaNotifierProvider.notifier).setDifficulty(
    //         accuracyThreshold: d.accuracyThreshold,
    //         level: d.level,
    //         timeLimit: d.timeLimit,
    //         wpmThreshold: d.wpmThreshold,
    //         xpMultiplier: d.xpMultiplier
    //     );
    // }

    Future<void> _save(PracticeConfig s) async {
        final prefs = ref.watch(sharedPrefsServiceProvider);
        await prefs.setString(kPracticeSettingsPrefsKey, jsonEncode(s.toJson()));
        state = s; // plain model, not AsyncValue
    }

    Future<void> _update(PracticeConfig Function(PracticeConfig) fn) async {
        final updated = fn(state);
        await _save(updated);
    }

    // ---------- setters / toggles ----------

    Future<void> setDifficulty(DifficultyEnum v) =>
    _update((s) => s.copyWith(difficulty: v));

    Future<void> setMode(ExpertiseModeEnum v) => 
    _update((s) => s.copyWith(mode: v));

    Future<void> setContentLength(TextLengthEnum v) => 
    _update((s) => s.copyWith(contentLength: v));

    Future<void> setContentFontSize(TextSizeEnum v) =>
    _update((s) => s.copyWith(contentFontSize: v));

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

    Future<void> replace(PracticeConfig next) => _save(next);
    Future<void> reset() => _save(const PracticeConfig());

}


final practiceConfigurationProvider = NotifierProvider<PracticeConfigController, PracticeConfig>(PracticeConfigController.new);
