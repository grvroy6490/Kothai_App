import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/di/providers/toast/flutter_toast_provider.dart';
import 'package:visai/features/badges/data/repositories_impl/badge_repository.dart';
import 'package:visai/features/badges/presentation/pages/badge_popup.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';

class BadgeController extends Notifier<Set<String>> {
    late final SharedPrefsService _prefs = ref.read(sharedPrefsServiceProvider);
    late final toast = ref.read(toastServiceProvider);

    @override
    Set<String> build() {
        final badges = _prefs.getSet("badges");
        return badges ?? <String>{};
    }

    void _unlock(BuildContext context, String badgeId) {
        if (state.contains(badgeId)) return;

        final badge = BadgeRepository.allBadges.firstWhere(
            (b) => b.id == badgeId,
            orElse: () => throw ""
        );

        state = {...state, badgeId};
        _prefs.setSet("badges", state);

        // toast.show(badge.toastMessage);
        showBadgePopup(context, badge);
    }

    // ---------- EVENT LISTENERS ----------
    void onFirstKeystroke(BuildContext context) =>
    _unlock(context, "first_keystroke");

    void onChallengeCompleted(BuildContext context) =>
    _unlock(context, "first_challenge_completed");

    void onReturnAfterInactivity(BuildContext context) => _unlock(
        context,
        "comeback_kid"
    ); // TODO: Logic to check 3+ days of inactivity

    void onXPChanged(BuildContext context, int xp) {
        if (xp >= 100) _unlock(context, "new_learner");
        if (xp >= 500) _unlock(context, "focused_student");
        if (xp >= 1000) _unlock(context, "typing_enthusiast");
        if (xp >= 2500) _unlock(context, "speed_scholar");
        if (xp >= 5000) _unlock(context, "master_of_keys");
        if (xp >= 10000) _unlock(context, "tamil_titan");
    }

    void onStreakChanged(BuildContext context, int days) {
        if (days >= 1) _unlock(context, "day_one_done");
        if (days >= 7) _unlock(context, "weekend_warrior");
        if (days >= 14) _unlock(context, "fortnight_fighter");
        if (days >= 30) _unlock(context, "month_marathoner");
        if (days >= 60) _unlock(context, "unbreakable");
        if (days >= 100) _unlock(context, "legendary_learner");
    }

    void onSessionComplete(
        BuildContext context, {
            required double accuracy,
            required double wpm
        }) {
        if (accuracy == 100) _unlock(context, "accuracy_hunter");
        if (wpm >= 50) _unlock(context, "speed_sprinter");
        // if (accuracy >= 98) _unlock(context, "perfectionist"); //TODO: Need to add 5 seesions check
        // if (accuracy >= 95) _unlock(context, "perfection_pro"); //TODO: Need to add 10 seesions check
        // TODO: Complete 10 practice sessions within a single day
    }
}

final badgeControllerProvider = NotifierProvider<BadgeController, Set<String>>(
    BadgeController.new
);
