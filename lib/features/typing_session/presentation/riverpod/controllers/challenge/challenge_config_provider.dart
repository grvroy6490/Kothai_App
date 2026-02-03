


import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/constants/typing_session_constants.dart';
import 'package:kothai_app/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:kothai_app/features/typing_session/domain/entities/challenge/challenge_config.dart';

class ChallengeConfigController extends Notifier<ChallengeConfig>{
    @override
    ChallengeConfig build() {
        state = ChallengeConfig();
        _load();
        return state;
    }

    Future<void> _load() async {
        try{
            final prefs = ref.watch(sharedPrefsServiceProvider);
            final raw = prefs.getString(kChallengeSettingsPrefsKey);

            if (raw != null) {
                final decoded = ChallengeConfig.fromJson(
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
    }

    Future<void> _save(ChallengeConfig s) async {
        final prefs = ref.watch(sharedPrefsServiceProvider);
        await prefs.setString(kChallengeSettingsPrefsKey, jsonEncode(s.toJson()));
        state = s; // plain model, not AsyncValue
    }

    Future<void> _update(ChallengeConfig Function(ChallengeConfig) fn) async {
        final updated = fn(state);
        await _save(updated);
    }

    // ---------- setters / toggles ----------

    Future<void> toggleSound() =>
    _update((s) => s.copyWith(soundEnabled: !s.soundEnabled));

    Future<void> toggleHaptics() =>
    _update((s) => s.copyWith(hapticEnabled: !s.hapticEnabled));

    Future<void> toggleDarkMode() =>
    _update((s) => s.copyWith(darkMode: !s.darkMode));

    Future<void> toggleNotifications() =>
    _update((s) => s.copyWith(notificationsEnabled: !s.notificationsEnabled));

    Future<void> replace(ChallengeConfig next) => _save(next);
    Future<void> reset() => _save(const ChallengeConfig());
}


final challengeConfigurationProvider = NotifierProvider<ChallengeConfigController, ChallengeConfig>(ChallengeConfigController.new);