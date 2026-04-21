

import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/preload_initial_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_initializer.g.dart';

@riverpod
class AppInitializer extends _$AppInitializer {
    // Ensure heavy initialization runs only once per app process.
    static bool _initialized = false;

    @override
    Future<void> build() async {
        if (_initialized) {
            // Initialization already completed in this process; no-op.
            return;
        }

        try {
            // 1️⃣ Initialize SharedPreferences (and any global singletons)
            await SharedPreferences.getInstance();

            // Wait for the preload futures themselves, not their AsyncValue wrappers.
            await ref.read(preloadPracticeInitialContentControllerProvider.future);
            await ref.read(preloadChallengeInitialContentControllerProvider.future);
            await ref.read(preloadGamificationControllerProvider.future);

            _initialized = true;
        } catch (e, st) {
            // Surface the error so App can show Default404 instead of an endless splash.
            Error.throwWithStackTrace(e, st);
        }
    }
}