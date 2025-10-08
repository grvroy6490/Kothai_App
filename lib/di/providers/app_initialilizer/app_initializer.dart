

import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/content/preload_initial_content_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_initializer.g.dart';

@riverpod
class AppInitializer extends _$AppInitializer {
    @override
    Future<void> build() async {
        // 1️⃣ Initialize SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await ref.read(preloadPracticeInitialContentControllerProvider);
        await ref.read(preloadChallengeInitialContentControllerProvider);
        await ref.read(preloadGamificationControllerProvider);
    }
}