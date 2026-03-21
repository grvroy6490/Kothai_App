import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:visai/core/constants/notifications_constants.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/features/notifications/presentation/notification_navigation.dart';
import 'package:visai/features/typing_session/domain/entities/challenge/challenge_config.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';

/// Schedules/cancels the daily local reminder based on prefs + [ChallengeConfig].
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  static const int _dailyReminderId = 10001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    _initialized = true;
  }

  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateFromNotificationPayload(payload);
    });
  }

  Future<void> configureTimeZone() async {
    tz_data.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> requestPermissionsIfNeeded() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  /// Reads [kChallengeSettingsPrefsKey] and reminder hour/minute from prefs.
  Future<void> syncFromPrefs(SharedPrefsService prefs) async {
    await init();
    await configureTimeZone();

    final raw = prefs.getString(kChallengeSettingsPrefsKey);
    var enabled = false;
    if (raw != null) {
      try {
        enabled = ChallengeConfig.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        ).notificationsEnabled;
      } catch (_) {}
    }

    final hour = prefs.getInt(kDailyReminderHourKey) ?? 9;
    final minute = prefs.getInt(kDailyReminderMinuteKey) ?? 0;

    await _plugin.cancel(_dailyReminderId);

    if (!enabled) return;

    await requestPermissionsIfNeeded();

    final androidDetails = AndroidNotificationDetails(
      kDailyReminderChannelId,
      'Practice reminders',
      channelDescription: 'Daily reminders to practice Tamil typing',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const darwinDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final scheduled = _nextInstanceOfDailyTime(hour, minute);

    await _plugin.zonedSchedule(
      _dailyReminderId,
      'Time for Tamil practice',
      'Open Visai and keep your streak going.',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: kNotificationPayloadPractice,
    );
  }

  tz.TZDateTime _nextInstanceOfDailyTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
