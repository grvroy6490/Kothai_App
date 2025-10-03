import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/app/app.dart';
import 'package:kothai_app/features/authentication/presentation/providers/ApplicationState.dart' as auth;
import 'package:kothai_app/di/poviders/db_provider.dart';
import 'package:kothai_app/di/poviders/shared_prefs_provider.dart';
import 'package:kothai_app/services/shared_prefs_service.dart';

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
    container.read(auth.authPrefsSyncProvider);

    runApp(
        UncontrolledProviderScope(
            container: container,
            child: const App()
        )
    );
}






// TODO: Setup XP calculation and display


// TODO: Create Profile UI
// TODO: Create Auth UI
// TODO: Handle Authentication
// TODO: Data upload to firebase


/* COMPLETED */
// TODO: Fix the paragraph change on difficulty updates
// TODO: Only 7 days data should be persisted locally
// TODO: Use SQFlite for store data locally
// TODO: Handle start practise and session management
// TODO: Add practice progress tracking
// TODO: Setup Practice Completion
// TODO: Add Practice Reset
// TODO: Add Practice Pause
// TODO: Add Practice Stop
// TODO: Setup the WPM, Accuracy and Timer of practice
// TODO: Setup and handle routes for Pause/Reset/Complete and Randomize Screen
// TODO: Animate content board on practice start
// TODO: Update paragraph info on infobox at the top
// TODO: Apply practice configuration throughout
//  mode,
//  difficulty, 👍
//  contentLength,
//  contentFontSize, 👍
//  blindMode, 👍
//  randomize,
//  wpmEnabled, 👍
//  accuracyEnabled, 👍
//  timerEnabled, 👍
//  errorsEnabled,
//  allowPauses, 👍
//  allowTakeBacks, 👍
//  soundEnabled,
//  soundOnError,
//  hapticEnabled, 👍
//  hapticOnError,
//  darkMode

