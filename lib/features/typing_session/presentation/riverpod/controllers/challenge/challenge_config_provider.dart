


import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/constants/notifications_constants.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/features/typing_session/domain/entities/challenge/challenge_config.dart';
import 'package:visai/services/notifications/local_notification_service.dart';
import 'package:visai/services/notifications/push_notification_service.dart';

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

    Future<void> _resyncNotifications() async {
        final prefs = ref.read(sharedPrefsServiceProvider);
        await LocalNotificationService.instance.syncFromPrefs(prefs);
        await PushNotificationService.instance.syncPreferences(prefs);
    }

    // ---------- setters / toggles ----------

    Future<void> toggleSound() =>
    _update((s) => s.copyWith(soundEnabled: !s.soundEnabled));

    Future<void> toggleHaptics() =>
    _update((s) => s.copyWith(hapticEnabled: !s.hapticEnabled));

    Future<void> toggleDarkMode() =>
    _update((s) => s.copyWith(darkMode: !s.darkMode));

    Future<void> toggleNotifications() async {
        await _update((s) => s.copyWith(notificationsEnabled: !s.notificationsEnabled));
        await _resyncNotifications();
    }

    Future<void> toggleDailyReminders() async {
        await _update((s) => s.copyWith(dailyRemindersEnabled: !s.dailyRemindersEnabled));
        await _resyncNotifications();
    }

    Future<void> toggleStreakAlerts() async {
        await _update((s) => s.copyWith(streakAlertsEnabled: !s.streakAlertsEnabled));
        await _resyncNotifications();
    }

    Future<void> toggleAchievementAlerts() async {
        await _update((s) => s.copyWith(achievementAlertsEnabled: !s.achievementAlertsEnabled));
        await _resyncNotifications();
    }

    Future<void> toggleProductUpdates() async {
        await _update((s) => s.copyWith(productUpdatesEnabled: !s.productUpdatesEnabled));
        await _resyncNotifications();
    }

    /// Persists daily reminder time (local notification) and reschedules.
    Future<void> setDailyReminderTime(int hour, int minute) async {
        final prefs = ref.read(sharedPrefsServiceProvider);
        await prefs.setInt(kDailyReminderHourKey, hour);
        await prefs.setInt(kDailyReminderMinuteKey, minute);
        await LocalNotificationService.instance.syncFromPrefs(prefs);
    }

    Future<void> replace(ChallengeConfig next) => _save(next);
    Future<void> reset() => _save(const ChallengeConfig());
}


final challengeConfigurationProvider = NotifierProvider<ChallengeConfigController, ChallengeConfig>(ChallengeConfigController.new);
