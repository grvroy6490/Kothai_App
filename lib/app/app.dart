

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
// import 'package:logger/logger.dart';


class App extends ConsumerWidget {
    const App({super.key}); 

    void clear() async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        print('worked');
        prefs.clear();
    }

    @override
    Widget build(BuildContext context, ref) {
        // final _logger = Logger();
        
        // clear();
        // print(ref.watch(xpControllerProvider).totalXp);

        // 👇 APP INITIALIZER
        final init = ref.watch(appInitializerProvider);

        final themeMode = ref.watch(themeProvider);

        return ScreenUtilInit(
            designSize: const Size(360, 812),
            minTextAdapt: true,
            splitScreenMode: false,
            child: GetMaterialApp(
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
            )
        );
    }
}
