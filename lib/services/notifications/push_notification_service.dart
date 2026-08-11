import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:visai/core/constants/notifications_constants.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/features/notifications/presentation/notification_navigation.dart';
import 'package:visai/features/typing_session/domain/entities/challenge/challenge_config.dart';
import 'package:visai/services/firebase/firebase_options.dart';
import 'package:visai/services/notifications/local_notification_service.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';

/// Top-level background FCM handler (must be a top-level function).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print('FCM background: ${message.messageId} ${message.notification?.title}');
  }
}

/// Firebase Cloud Messaging for Android + iOS remote push.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _initialized = false;
  SharedPrefsService? _prefs;

  Future<void> init(SharedPrefsService prefs) async {
    if (kIsWeb) return;
    if (_initialized) return;
    _prefs = prefs;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // iOS: show alerts while app is in foreground.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _handleNavigation(initial);
    }

    _messaging.onTokenRefresh.listen((token) async {
      await _persistToken(token);
    });

    await syncPreferences(prefs);
    _initialized = true;
  }

  ChallengeConfig _config(SharedPrefsService prefs) {
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

  /// Align FCM permission, topic subscription, and token storage with prefs.
  Future<void> syncPreferences(SharedPrefsService prefs) async {
    if (kIsWeb) return;
    _prefs = prefs;
    final config = _config(prefs);

    if (!config.notificationsEnabled || !config.productUpdatesEnabled) {
      try {
        await _messaging.unsubscribeFromTopic(kFcmAnnouncementsTopic);
      } catch (_) {}
      return;
    }

    await LocalNotificationService.instance.requestPermissionsIfNeeded();
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    // iOS needs an APNs token before FCM token is available.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _messaging.getAPNSToken();
    }

    final token = await _messaging.getToken();
    if (token != null) {
      await _persistToken(token);
    }

    try {
      await _messaging.subscribeToTopic(kFcmAnnouncementsTopic);
    } catch (e) {
      if (kDebugMode) {
        print('FCM topic subscribe failed: $e');
      }
    }
  }

  Future<void> _persistToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'fcmTokens': FieldValue.arrayUnion([token]),
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          'platform': defaultTargetPlatform.name,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      if (kDebugMode) {
        print('FCM token persist failed: $e');
      }
    }
  }

  /// Call after sign-in so the current device token is attached to the user.
  Future<void> onUserSignedIn() async {
    final prefs = _prefs;
    if (prefs == null) return;
    final config = _config(prefs);
    if (!config.notificationsEnabled || !config.productUpdatesEnabled) return;
    final token = await _messaging.getToken();
    if (token != null) {
      await _persistToken(token);
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final prefs = _prefs;
    if (prefs != null) {
      final config = _config(prefs);
      if (!config.notificationsEnabled || !config.productUpdatesEnabled) {
        return;
      }
    }

    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;
    if (title == null && body == null) return;

    final payload = message.data['payload'] as String? ??
        message.data['route'] as String? ??
        kNotificationPayloadPractice;

    await LocalNotificationService.instance.showRemoteMessage(
      title: title ?? 'Visai',
      body: body ?? '',
      payload: payload,
    );
  }

  void _onMessageOpened(RemoteMessage message) {
    _handleNavigation(message);
  }

  void _handleNavigation(RemoteMessage message) {
    final payload = message.data['payload'] as String? ??
        message.data['route'] as String? ??
        kNotificationPayloadPractice;
    navigateFromNotificationPayload(payload);
  }
}
