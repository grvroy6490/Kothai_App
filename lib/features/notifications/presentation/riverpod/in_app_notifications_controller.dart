import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/constants/notifications_constants.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/features/badges/data/model/badge_entity.dart';
import 'package:visai/features/notifications/domain/in_app_notification.dart';
import 'package:visai/features/typing_session/domain/entities/challenge/challenge_config.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';

const int _kMaxNotifications = 100;

/// Local in-app notification feed (persisted under [kInAppNotificationsKey]).
class InAppNotificationsController extends Notifier<List<InAppNotification>> {
  SharedPrefsService get _prefs => ref.read(sharedPrefsServiceProvider);

  ChallengeConfig get _config {
    final raw = _prefs.getString(kChallengeSettingsPrefsKey);
    if (raw == null) return const ChallengeConfig();
    try {
      return ChallengeConfig.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const ChallengeConfig();
    }
  }

  bool get notificationsEnabled => _config.notificationsEnabled;

  bool get achievementAlertsEnabled =>
      _config.notificationsEnabled && _config.achievementAlertsEnabled;

  @override
  List<InAppNotification> build() => _load();

  List<InAppNotification> _load() {
    final raw = _prefs.getString(kInAppNotificationsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map(
            (e) =>
                InAppNotification.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e, st) {
      if (kDebugMode) {
        print('InAppNotifications load failed: $e\n$st');
      }
      return [];
    }
  }

  Future<void> _persist() async {
    final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
    await _prefs.setString(kInAppNotificationsKey, encoded);
  }

  int get unreadCount => state.where((n) => !n.read).length;

  /// Badge unlocked — idempotent per [badgeId] (same day could still add once).
  Future<void> tryAddBadgeUnlocked(BadgeEntity badge) async {
    if (!achievementAlertsEnabled) return;

    final dedupeId = 'badge_${badge.id}';
    if (state.any((e) => e.id == dedupeId)) return;

    final n = InAppNotification(
      id: dedupeId,
      kind: 'badge',
      title: 'New badge: ${badge.name}',
      body: badge.toastMessage.isNotEmpty ? badge.toastMessage : badge.condition,
      createdAt: DateTime.now(),
      read: false,
      routePayload: kNotificationPayloadAchievementGallery,
    );
    _prepend(n);
    await _persist();
  }

  /// Session finished summary (one row per [sessionId]).
  Future<void> tryAddSessionSummary({
    required String sessionId,
    required double wpm,
    required double accuracy,
  }) async {
    if (!achievementAlertsEnabled) return;
    final dedupeId = 'session_$sessionId';
    if (state.any((e) => e.id == dedupeId)) return;

    final n = InAppNotification(
      id: dedupeId,
      kind: 'session',
      title: 'Session complete',
      body:
          'WPM ${wpm.toStringAsFixed(1)} · Accuracy ${accuracy.toStringAsFixed(1)}%',
      createdAt: DateTime.now(),
      read: false,
      routePayload: kNotificationPayloadPractice,
    );
    _prepend(n);
    await _persist();
  }

  /// Level-up — one row per level number.
  Future<void> tryAddLevelUp(int level) async {
    if (!achievementAlertsEnabled) return;
    final dedupeId = 'level_$level';
    if (state.any((e) => e.id == dedupeId)) return;

    final n = InAppNotification(
      id: dedupeId,
      kind: 'level',
      title: 'Level up!',
      body: 'You reached level $level. Keep practicing!',
      createdAt: DateTime.now(),
      read: false,
      routePayload: kNotificationPayloadXpMilestones,
    );
    _prepend(n);
    await _persist();
  }

  void _prepend(InAppNotification n) {
    final next = [n, ...state];
    if (next.length > _kMaxNotifications) {
      state = next.sublist(0, _kMaxNotifications);
    } else {
      state = next;
    }
  }

  Future<void> markRead(String id) async {
    state = [
      for (final n in state)
        n.id == id ? n.copyWith(read: true) : n,
    ];
    await _persist();
  }

  Future<void> markAllRead() async {
    state = [for (final n in state) n.copyWith(read: true)];
    await _persist();
  }

  Future<void> clearAll() async {
    state = [];
    await _prefs.remove(kInAppNotificationsKey);
  }
}

final inAppNotificationsControllerProvider =
    NotifierProvider<InAppNotificationsController, List<InAppNotification>>(
  InAppNotificationsController.new,
);

final inAppNotificationsUnreadCountProvider = Provider<int>((ref) {
  final items = ref.watch(inAppNotificationsControllerProvider);
  return items.where((n) => !n.read).length;
});
