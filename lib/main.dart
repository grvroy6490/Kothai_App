import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/app/app.dart';
import 'package:visai/di/providers/db/db_provider.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/services/firebase/firebase_options.dart';
import 'package:visai/services/notifications/local_notification_service.dart';
import 'package:visai/services/notifications/push_notification_service.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setLanguageCode('en');

  final service = SharedPrefsServiceImpl();
  await service.init();

  if (!kIsWeb) {
    await LocalNotificationService.instance.init();
    await LocalNotificationService.instance.configureTimeZone();
    // Schedule without prompting here — permission dialogs need an Activity.
    // [App] re-syncs after the first frame (and Settings toggles also re-sync).
    await LocalNotificationService.instance.syncFromPrefs(
      service,
      requestPermission: false,
    );
    await PushNotificationService.instance.init(service);
  }

  final container = ProviderContainer(
    overrides: [sharedPrefsServiceProvider.overrideWithValue(service)],
  );
  // Warm the DB so downstream providers have it ready
  await container.read(databaseProvider.future);
  // Start auth prefs sync listener
  // container.read(auth.authPrefsSyncProvider);

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}


// 📃 DECLARATION ----------------------------
// 🌐 PROVIDERS ------------------------------
// 🚀 METHODS --------------------------------
// ⭐ Widget ---------------------------------