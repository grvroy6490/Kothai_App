import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/di/providers/toast/flutter_toast_provider.dart';
import 'package:visai/features/badges/data/model/badge_entity.dart';
import 'package:visai/features/badges/data/repositories_impl/badge_repository.dart';
import 'package:visai/features/badges/presentation/pages/badge_popup.dart';
import 'package:visai/features/notifications/presentation/riverpod/in_app_notifications_controller.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';

class BadgeController extends Notifier<Set<String>> {
  static const _kLastActiveYmdKey = 'badges.last_active_ymd';
  static const _kAcc98SessionStreakKey = 'badges.acc98_session_streak';
  static const _kAcc95SessionStreakKey = 'badges.acc95_session_streak';
  static const _kPracticeSessionDateKey = 'badges.practice_session_date';
  static const _kPracticeSessionCountKey = 'badges.practice_session_count';
  OverlayEntry? _badgeOverlayEntry;

  late final SharedPrefsService _prefs = ref.read(sharedPrefsServiceProvider);
  late final toast = ref.read(toastServiceProvider);

  @override
  Set<String> build() {
    final badges = _prefs.getSet("badges");
    return badges ?? <String>{};
  }

  void _unlock(
    BuildContext context,
    String badgeId, {
    bool nonBlockingPopup = false,
  }) {
    if (state.contains(badgeId)) return;

    final matches = BadgeRepository.allBadges.where((b) => b.id == badgeId);
    if (matches.isEmpty) return;
    final badge = matches.first;

    state = {...state, badgeId};
    _prefs.setSet("badges", state);

    if (nonBlockingPopup) {
      _showBadgeFloatingPopup(context, badge);
    } else {
      showBadgePopup(context, badge);
    }

    ref
        .read(inAppNotificationsControllerProvider.notifier)
        .tryAddBadgeUnlocked(badge);
  }

  void _showBadgeFloatingPopup(BuildContext context, BadgeEntity badge) {
    final overlayContext = Get.overlayContext ?? context;
    final overlay =
        Overlay.maybeOf(overlayContext, rootOverlay: true) ??
        Navigator.maybeOf(overlayContext, rootNavigator: true)?.overlay;
    if (overlay == null) return;

    _badgeOverlayEntry?.remove();
    _badgeOverlayEntry = OverlayEntry(
      builder: (context) {
        final mediaQuery = MediaQuery.maybeOf(overlayContext);
        final topPadding = (mediaQuery?.padding.top ?? 0) + 12;
        return Positioned(
          top: topPadding,
          left: 12,
          right: 12,
          child: IgnorePointer(
            ignoring: true,
            child: Material(
              color: Colors.transparent,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 220),
                tween: Tween(begin: 0, end: 1),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * -16),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          badge.imagePath,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Badge unlocked: ${badge.name}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              badge.toastMessage,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_badgeOverlayEntry!);
    Future<void>.delayed(const Duration(seconds: 3), () {
      _badgeOverlayEntry?.remove();
      _badgeOverlayEntry = null;
    });
  }

  // ---------- EVENT LISTENERS ----------
  void onFirstKeystroke(BuildContext context) {
    _unlock(context, "first_keystroke", nonBlockingPopup: true);
    _checkComebackAfterInactivity(context);
    _touchLastActiveDate();
  }

  void onChallengeCompleted(BuildContext context) =>
      _unlock(context, "first_challenge_completed");

  void onReturnAfterInactivity(BuildContext context) =>
      _checkComebackAfterInactivity(context);

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
    required double wpm,
    required SessionMode mode,
  }) {
    if (accuracy == 100) _unlock(context, "accuracy_hunter");
    if (wpm >= 50) _unlock(context, "speed_sprinter");
    _checkAccuracySessionStreakBadges(context, accuracy: accuracy);
    _checkMarathonTypist(context, mode: mode);
    _touchLastActiveDate();
  }

  void _checkComebackAfterInactivity(BuildContext context) {
    final lastYmd = _prefs.getString(_kLastActiveYmdKey);
    if (lastYmd == null || lastYmd.isEmpty) return;

    final lastDate = DateTime.tryParse(lastYmd);
    if (lastDate == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = DateTime(lastDate.year, lastDate.month, lastDate.day);

    if (today.difference(last).inDays >= 3) {
      _unlock(context, "comeback_kid");
    }
  }

  void _checkAccuracySessionStreakBadges(
    BuildContext context, {
    required double accuracy,
  }) {
    int acc98 = _prefs.getInt(_kAcc98SessionStreakKey) ?? 0;
    int acc95 = _prefs.getInt(_kAcc95SessionStreakKey) ?? 0;

    if (accuracy >= 98) {
      acc98 += 1;
      acc95 += 1;
    } else if (accuracy >= 95) {
      acc98 = 0;
      acc95 += 1;
    } else {
      acc98 = 0;
      acc95 = 0;
    }

    _prefs.setInt(_kAcc98SessionStreakKey, acc98);
    _prefs.setInt(_kAcc95SessionStreakKey, acc95);

    if (acc98 >= 5) _unlock(context, "perfectionist");
    if (acc95 >= 10) _unlock(context, "perfection_pro");
  }

  void _checkMarathonTypist(BuildContext context, {required SessionMode mode}) {
    if (mode != SessionMode.practice) return;

    final now = DateTime.now();
    final todayYmd = _ymd(now);
    final storedYmd = _prefs.getString(_kPracticeSessionDateKey);

    int count;
    if (storedYmd == todayYmd) {
      count = (_prefs.getInt(_kPracticeSessionCountKey) ?? 0) + 1;
    } else {
      count = 1;
      _prefs.setString(_kPracticeSessionDateKey, todayYmd);
    }

    _prefs.setInt(_kPracticeSessionCountKey, count);
    if (count >= 10) {
      _unlock(context, "marathon_typist");
    }
  }

  void _touchLastActiveDate() {
    _prefs.setString(_kLastActiveYmdKey, _ymd(DateTime.now()));
  }

  String _ymd(DateTime date) {
    final d = date.toLocal();
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  /// Debug helper: resets only progress counters used for advanced badges.
  /// Keeps already unlocked badges intact.
  Future<void> resetProgressCounters() async {
    await _prefs.remove(_kLastActiveYmdKey);
    await _prefs.remove(_kAcc98SessionStreakKey);
    await _prefs.remove(_kAcc95SessionStreakKey);
    await _prefs.remove(_kPracticeSessionDateKey);
    await _prefs.remove(_kPracticeSessionCountKey);
  }

  /// Debug/admin helper: clears all unlocked badges and counters.
  Future<void> resetAllBadgesAndProgress() async {
    state = <String>{};
    await _prefs.remove("badges");
    await resetProgressCounters();
  }
}

final badgeControllerProvider = NotifierProvider<BadgeController, Set<String>>(
  BadgeController.new,
);
