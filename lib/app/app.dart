

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:visai/app/layout_builder.dart';
// import 'package:visai/core/constants/gamification.dart';
import 'package:visai/core/errors/default_404.dart';
import 'package:visai/core/routing/routes.dart';
import 'package:visai/core/theme/app_typography_scaled.dart';
import 'package:visai/core/theme/theme_manager.dart';
import 'package:visai/di/providers/app_initialilizer/app_initializer.dart';
// import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/di/providers/theme/theme_provider.dart';
import 'package:visai/features/splash/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visai/features/authentication/presentation/providers/auth_service_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/score/score_controller_provider.dart';
// import 'package:logger/logger.dart';


class App extends ConsumerStatefulWidget {
    const App({super.key});

    @override
    ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
    // Prevent multiple restore/sync calls for the same uid.
    static String? _lastSyncedUid;

    final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();

    void clear() async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        print('worked');
        prefs.clear();
    }

    @override
    Widget build(BuildContext context) {
        final ref = this.ref;
        // final _logger = Logger();
        
        // clear();
        // print(ref.watch(xpControllerProvider).totalXp);

        // 👇 APP INITIALIZER
        final init = ref.watch(appInitializerProvider);
        final themeMode = ref.watch(themeProvider);

        // Auto-sync scores after login (and after reinstall).
        // Riverpod requires ref.listen to be called from build.
        ref.listen<AsyncValue<User?>>(
            authUserProvider,
            (previous, next) {
                next.whenData((user) {
                    final uid = user?.uid;
                    if (uid == null) {
                        _lastSyncedUid = null;
                        return;
                    }
                    if (_lastSyncedUid == uid) return;

                    _lastSyncedUid = uid;

                    // Show a snackbar for sync success/failure.
                    unawaited(() async {
                        try {
                            await ref.read(scoreControllerProvider.notifier).syncAll();
                            _scaffoldMessengerKey.currentState?.showSnackBar(
                                const SnackBar(content: Text('Progress synced successfully.'),
                                    backgroundColor: Colors.green),
                            );
                        } catch (e) {
                            _scaffoldMessengerKey.currentState?.showSnackBar(
                                SnackBar(
                                    content: Text('Sync failed: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                ),
                            );
                        }
                    }());
                });
            },
        );

        // [scaffoldMessengerKey] must live on [GetMaterialApp], not on a parent
        // [ScaffoldMessenger]. Otherwise route [Scaffold]s register with the
        // inner messenger and the key’s messenger has none → showSnackBar asserts.
        return ScreenUtilInit(
            designSize: const Size(360, 812),
            minTextAdapt: true,
            splitScreenMode: false,
            child: GetMaterialApp(
                scaffoldMessengerKey: _scaffoldMessengerKey,
                getPages: routes,
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                theme: getTheme(false),
                darkTheme: getTheme(true),
                builder: (context, child) {
                    final mq = MediaQuery.of(context);
                    final clamped = mq.textScaler.clamp(
                        minScaleFactor: 0.85,
                        maxScaleFactor: 1.20
                    );

                    final inheritedTheme = Theme.of(context);
                    final withScaledText = inheritedTheme.copyWith(
                        textTheme: AppTypographyScaled.of(context, fontFamily: 'Inter')
                    );

                    final themedChild = child == null
                        ? const SizedBox.shrink()
                        : Theme(data: withScaledText, child: child);
                    return MediaQuery(
                        data: mq.copyWith(textScaler: clamped),
                        child: themedChild
                    );
                },

                // 👇 This is key:
                home: init.when(
                    data: (_) => const ResponsivePage(),
                    error: (e, _) => Default404(error: e.toString()),
                    loading: () => const SplashPage()
                )
            ),
        );
    }
}
