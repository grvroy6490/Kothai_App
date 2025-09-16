


import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/constants/typin_session_constants.dart';
import 'package:kothai_app/di/poviders/shared_prefs_provider.dart';
import 'package:kothai_app/features/typing_session/domain/entities/difficulty/difficulty_criteria.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/accuracy_threshold_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_time_limit_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_wpm_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/expertise_mode_enums.dart';
import 'package:kothai_app/features/typing_session/domain/enums/multipliers_enums.dart';
import 'package:kothai_app/features/typing_session/domain/enums/text_length_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/text_size_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/content/text_providers.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/difficulty/difficulty_criteria_provider.dart';

class PracticeConfigController extends Notifier<PracticeConfig> {

    @override
    PracticeConfig build() {
        state = PracticeConfig();
        _load();
        return state;
    }

    // TODO: replace placeholder values with your real presets.
    DifficultyCriteria _difficultyFromEnum(DifficultyEnum e) {
        switch (e) {
            case DifficultyEnum.easy:
                return DifficultyCriteria(
                    level: DifficultyEnum.easy,
                    accuracyThreshold: AccuracyThresholdEnum.accuracyEasy,
                    timeLimit: DifficultyTimeLimit.limitEasy,
                    wpmThreshold: DifficultyWPMEnum.wpmEasy,
                    xpMultiplier: XpMultiplier.easy
                );
            case DifficultyEnum.medium:
                return DifficultyCriteria(
                    level: DifficultyEnum.medium,
                    accuracyThreshold: AccuracyThresholdEnum.accuracyMedium,
                    timeLimit: DifficultyTimeLimit.limitMedium,
                    wpmThreshold: DifficultyWPMEnum.wpmMedium,
                    xpMultiplier: XpMultiplier.medium
                );

            case DifficultyEnum.hard:
                return DifficultyCriteria(
                    level: DifficultyEnum.hard,
                    accuracyThreshold: AccuracyThresholdEnum.accuracyHigh,
                    timeLimit: DifficultyTimeLimit.limitHard,
                    wpmThreshold: DifficultyWPMEnum.wpmHard,
                    xpMultiplier: XpMultiplier.hard
                );

            // If you have more enums, handle them here.
        }
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
        final criteria = _difficultyFromEnum(state.difficulty);
        _updateDifficultyObject(criteria);

        // --- 3) Preload typing texts for current difficulty ---
        await ref.read(preloadTypingTextsProvider).call(
            difficulty: state.difficulty,
            randomize: state.randomize,
        );

        // --- 4) Seed TextContent ---
        final list = await ref.read(preloadedTextsProvider.future);
        if (list.isNotEmpty) {
            ref.read(textContentProvider.notifier).setTextContent(list.first);
        } else {
            ref.read(textContentProvider.notifier).clearTextContent();
        }
    }

    // Keep this inside the notifier and use `Ref`, not `WidgetRef`.
    void _updateDifficultyObject(DifficultyCriteria d) {
        ref.read(difficultyCriteriaNotifierProvider.notifier).setDifficulty(
            accuracyThreshold: d.accuracyThreshold,
            level: d.level,
            timeLimit: d.timeLimit,
            wpmThreshold: d.wpmThreshold,
            xpMultiplier: d.xpMultiplier
        );
    }

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
    Future<void> setMode(ExpertiseModeEnum v) => _update((s) => s.copyWith(mode: v));

    Future<void> setDifficulty(DifficultyEnum v) async {
        // 1) Persist the enum to settings.
        await _update((s) => s.copyWith(difficulty: v));

        // 2) push resolved Difficulty preset to difficultyCriteriaNotifier (which now persists)
        _updateDifficultyObject(_difficultyFromEnum(v));

        // 3) refresh preloaded texts for this difficulty
        final randomize = state.randomize; // from your config
        await ref.read(preloadTypingTextsProvider).call(
            difficulty: v,
            randomize: randomize,
        );

        // 4) pick a paragraph and publish to TextContent
        final list = await ref.read(preloadedTextsProvider.future); // your FutureProvider<List<TextParagraph>>


        if (list.isNotEmpty) {
            ref.read(textContentProvider.notifier).setTextContent(list.first);
        } else {
            ref.read(textContentProvider.notifier).clearTextContent();
        }
    }

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
