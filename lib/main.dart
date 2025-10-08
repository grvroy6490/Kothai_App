import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/app/app.dart';
import 'package:kothai_app/di/providers/db/db_provider.dart';
import 'package:kothai_app/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:kothai_app/services/firebase/firebase_options.dart';
import 'package:kothai_app/services/shared_preferences/shared_prefs_service.dart';
import 'package:kothai_app/features/authentication/presentation/providers/auth_service_provider.dart' as auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setLanguageCode('en');

  final service = SharedPrefsServiceImpl();
  await service.init();

  final container = ProviderContainer(
    overrides: [
      sharedPrefsServiceProvider.overrideWithValue(service),
    ],
  );
  // Warm the DB so downstream providers have it ready
  await container.read(databaseProvider.future);
  // Start auth prefs sync listener
  // container.read(auth.authPrefsSyncProvider);

  runApp(
      UncontrolledProviderScope(
          container: container,
          child: const App()
      )
  );
}


// 📃 DECLARATION ----------------------------
// 🌐 PROVIDERS ------------------------------
// 🚀 METHODS --------------------------------
// ⭐ Widget ---------------------------------