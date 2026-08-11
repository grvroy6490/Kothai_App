import 'dart:convert';

import 'package:flutter/foundation.dart';
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

/// Schedules/cancels local reminders and shows one-shot achievement alerts.
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  AndroidScheduleMode _scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;

  Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Defer the system permission prompt to [requestPermissionsIfNeeded] so
    // Android 13+ and iOS get one explicit request path (and we can call it
    // when the user turns reminders on, not only at first [initialize]).
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _ensureAndroidChannels();
    _initialized = true;
  }

  Future<void> _ensureAndroidChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        kDailyReminderChannelId,
        'Practice reminders',
        description: 'Daily reminders to practice Tamil typing',
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        kStreakChannelId,
        'Streak alerts',
        description: 'Reminders to protect your practice streak',
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        kAchievementChannelId,
        'Achievements',
        description: 'Badge unlocks and level-up alerts',
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        kProductUpdatesChannelId,
        'Product updates',
        description: 'News and updates from Visai',
        importance: Importance.defaultImportance,
      ),
    );
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
      final raw = await FlutterTimezone.getLocalTimezone();
      final name = _normalizeTimeZoneName(raw);
      tz.setLocalLocation(tz.getLocation(name));
      if (kDebugMode) {
        print('LocalNotificationService timezone: $name (raw=$raw)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('LocalNotificationService timezone fallback UTC: $e');
      }
      tz.setLocalLocation(tz.UTC);
    }
  }

  /// Android sometimes returns abbreviations (e.g. IST) that are not IANA ids.
  String _normalizeTimeZoneName(String raw) {
    const aliases = <String, String>{
      'IST': 'Asia/Kolkata',
      'India Standard Time': 'Asia/Kolkata',
      'Asia/Calcutta': 'Asia/Kolkata',
      'PST': 'America/Los_Angeles',
      'PDT': 'America/Los_Angeles',
      'EST': 'America/New_York',
      'EDT': 'America/New_York',
      'CST': 'America/Chicago',
      'CDT': 'America/Chicago',
      'MST': 'America/Denver',
      'MDT': 'America/Denver',
      'GMT': 'Etc/GMT',
      'UTC': 'Etc/UTC',
    };
    return aliases[raw] ?? raw;
  }

  /// Requests post-notification permission (Android 13+), and alert/badge/sound
  /// (iOS/macOS), using the same APIs as [flutter_local_notifications] native
  /// implementations. Falls back to [Permission.notification] elsewhere.
  Future<void> requestPermissionsIfNeeded() async {
    if (kIsWeb) return;
    await init();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
      // Exact alarms make daily/streak reminders fire near the chosen time.
      try {
        final canExact = await android?.canScheduleExactNotifications();
        if (canExact == false) {
          await android?.requestExactAlarmsPermission();
        }
        final allowed = await android?.canScheduleExactNotifications();
        _scheduleMode = allowed == true
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle;
      } catch (_) {
        _scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
      }
      final st = await Permission.notification.status;
      if (!st.isGranted) {
        await Permission.notification.request();
      }
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.macOS) {
      final mac = _plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      await mac?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return;
    }

    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  ChallengeConfig _configFromPrefs(SharedPrefsService prefs) {
    final raw = prefs.getString(kChallengeSettingsPrefsKey);
    if (raw == null) return const ChallengeConfig();
    try {
      return ChallengeConfig.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const ChallengeConfig();
    }
  }

  int _daysSinceLastPractice(SharedPrefsService prefs) {
    final last = prefs.getString(kStreakLastYmdKey);
    if (last == null || last.length != 8) return 999;
    try {
      final y = int.parse(last.substring(0, 4));
      final m = int.parse(last.substring(4, 6));
      final d = int.parse(last.substring(6, 8));
      final lastDate = DateTime(y, m, d);
      final now = DateTime.now().toLocal();
      final today = DateTime(now.year, now.month, now.day);
      return today.difference(lastDate).inDays;
    } catch (_) {
      return 999;
    }
  }

  int _currentStreak(SharedPrefsService prefs) =>
      prefs.getInt(kStreakCurrentKey) ?? 0;

  /// Reads prefs and (re)schedules recurring local reminders.
  Future<void> syncFromPrefs(
    SharedPrefsService prefs, {
    bool requestPermission = true,
  }) async {
    await init();
    await configureTimeZone();

    final config = _configFromPrefs(prefs);
    final masterOn = config.notificationsEnabled;

    await _plugin.cancel(kDailyReminderNotificationId);
    await _plugin.cancel(kStreakAtRiskNotificationId);
    await _plugin.cancel(kComebackNotificationId);

    if (!masterOn) return;

    if (requestPermission) {
      await requestPermissionsIfNeeded();
    }

    if (config.dailyRemindersEnabled) {
      await _scheduleDailyReminder(prefs);
    }

    if (config.streakAlertsEnabled) {
      await _scheduleStreakAtRiskIfNeeded(prefs);
      await _scheduleComebackIfNeeded(prefs);
    }

    if (kDebugMode) {
      final pending = await _plugin.pendingNotificationRequests();
      print(
        'LocalNotificationService pending=${pending.length} '
        'ids=${pending.map((e) => e.id).toList()} mode=$_scheduleMode',
      );
    }
  }

  Future<void> _scheduleDailyReminder(SharedPrefsService prefs) async {
    final hour = prefs.getInt(kDailyReminderHourKey) ?? 9;
    final minute = prefs.getInt(kDailyReminderMinuteKey) ?? 0;
    final streak = _currentStreak(prefs);
    final body = streak > 0
        ? 'Open Visai and keep your $streak-day streak going.'
        : 'Open Visai and keep your streak going.';
    final when = _nextInstanceOfDailyTime(hour, minute);

    try {
      await _plugin.zonedSchedule(
        kDailyReminderNotificationId,
        'Time for Tamil practice',
        body,
        when,
        _details(
          channelId: kDailyReminderChannelId,
          channelName: 'Practice reminders',
          channelDescription: 'Daily reminders to practice Tamil typing',
          importance: Importance.high,
          priority: Priority.high,
        ),
        androidScheduleMode: _scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: kNotificationPayloadPractice,
      );
      if (kDebugMode) {
        print('Scheduled daily reminder at $when');
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('Failed to schedule daily reminder: $e\n$st');
      }
    }
  }

  Future<void> _scheduleStreakAtRiskIfNeeded(SharedPrefsService prefs) async {
    final streak = _currentStreak(prefs);
    if (streak <= 0) return;

    final when = _nextInstanceOfDailyTime(kStreakAtRiskHour, kStreakAtRiskMinute);
    try {
      await _plugin.zonedSchedule(
        kStreakAtRiskNotificationId,
        'Your streak needs you',
        'Practice today to protect your $streak-day streak.',
        when,
        _details(
          channelId: kStreakChannelId,
          channelName: 'Streak alerts',
          channelDescription: 'Reminders to protect your practice streak',
          importance: Importance.high,
          priority: Priority.high,
        ),
        androidScheduleMode: _scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: kNotificationPayloadStreakBoard,
      );
      if (kDebugMode) {
        print('Scheduled streak alert at $when (streak=$streak)');
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('Failed to schedule streak alert: $e\n$st');
      }
    }
  }

  Future<void> _scheduleComebackIfNeeded(SharedPrefsService prefs) async {
    final daysAway = _daysSinceLastPractice(prefs);
    if (daysAway < 3 || daysAway > 30) return;

    // One-shot tomorrow morning — avoid spamming if they keep opening the app.
    final tomorrow = tz.TZDateTime.now(tz.local).add(const Duration(days: 1));
    final scheduled = tz.TZDateTime(
      tz.local,
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      10,
      0,
    );

    try {
      await _plugin.zonedSchedule(
        kComebackNotificationId,
        'We miss you!',
        'Come back to Visai — your Tamil typing skills are waiting.',
        scheduled,
        _details(
          channelId: kStreakChannelId,
          channelName: 'Streak alerts',
          channelDescription: 'Reminders to protect your practice streak',
          importance: Importance.high,
          priority: Priority.high,
        ),
        androidScheduleMode: _scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: kNotificationPayloadPractice,
      );
    } catch (e, st) {
      if (kDebugMode) {
        print('Failed to schedule comeback: $e\n$st');
      }
    }
  }

  /// Call after the user practices today to clear win-back and refresh streak copy.
  Future<void> onPracticedToday(SharedPrefsService prefs) async {
    await _plugin.cancel(kComebackNotificationId);
    final config = _configFromPrefs(prefs);
    if (!config.notificationsEnabled || !config.streakAlertsEnabled) {
      await _plugin.cancel(kStreakAtRiskNotificationId);
      return;
    }
    await _plugin.cancel(kStreakAtRiskNotificationId);
    await _scheduleStreakAtRiskIfNeeded(prefs);
  }

  /// Debug helper: schedule a one-shot reminder [minutesFromNow] minutes ahead.
  Future<void> scheduleDebugInMinutes(int minutesFromNow) async {
    await init();
    await configureTimeZone();
    await requestPermissionsIfNeeded();
    final when =
        tz.TZDateTime.now(tz.local).add(Duration(minutes: minutesFromNow));
    await _plugin.zonedSchedule(
      kDebugScheduleNotificationId,
      'Visai schedule test',
      'If you see this, auto-scheduled notifications work.',
      when,
      _details(
        channelId: kDailyReminderChannelId,
        channelName: 'Practice reminders',
        channelDescription: 'Daily reminders to practice Tamil typing',
        importance: Importance.high,
        priority: Priority.high,
      ),
      androidScheduleMode: _scheduleMode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: kNotificationPayloadPractice,
    );
    if (kDebugMode) {
      print('Debug schedule set for $when (mode=$_scheduleMode)');
    }
  }

  Future<void> showBadgeUnlocked({
    required SharedPrefsService prefs,
    required String badgeName,
    String? body,
  }) async {
    final config = _configFromPrefs(prefs);
    if (!config.notificationsEnabled || !config.achievementAlertsEnabled) {
      return;
    }
    await init();
    await _plugin.show(
      kBadgeUnlockNotificationId,
      'New badge: $badgeName',
      body ?? 'Open Visai to celebrate your achievement.',
      _details(
        channelId: kAchievementChannelId,
        channelName: 'Achievements',
        channelDescription: 'Badge unlocks and level-up alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
      payload: kNotificationPayloadAchievementGallery,
    );
  }

  Future<void> showLevelUp({
    required SharedPrefsService prefs,
    required int level,
  }) async {
    final config = _configFromPrefs(prefs);
    if (!config.notificationsEnabled || !config.achievementAlertsEnabled) {
      return;
    }
    await init();
    await _plugin.show(
      kLevelUpNotificationId,
      'Level up!',
      'You reached level $level. Keep practicing!',
      _details(
        channelId: kAchievementChannelId,
        channelName: 'Achievements',
        channelDescription: 'Badge unlocks and level-up alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
      payload: kNotificationPayloadXpMilestones,
    );
  }

  /// Shows a foreground FCM message via the local notifications plugin.
  Future<void> showRemoteMessage({
    required String title,
    required String body,
    String? payload,
  }) async {
    await init();
    await _plugin.show(
      kRemoteForegroundNotificationId,
      title,
      body,
      _details(
        channelId: kProductUpdatesChannelId,
        channelName: 'Product updates',
        channelDescription: 'News and updates from Visai',
      ),
      payload: payload ?? kNotificationPayloadPractice,
    );
  }

  NotificationDetails _details({
    required String channelId,
    required String channelName,
    required String channelDescription,
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: importance,
        priority: priority,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
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
