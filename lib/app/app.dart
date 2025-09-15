

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kothai_app/app/layout_builder.dart';
import 'package:kothai_app/core/routing/routes.dart';
import 'package:kothai_app/core/theme/app_typography_scaled.dart';
import 'package:kothai_app/core/theme/theme_manager.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/text_preloader_provider.dart';

class App extends ConsumerWidget {
    const App({super.key});

    @override
    Widget build(BuildContext context, ref) {
        ref.watch(preloadOnConfigControllerProvider);

        return ScreenUtilInit(
            designSize: const Size(360, 812),
            minTextAdapt: true,
            splitScreenMode: false,
            child: GetMaterialApp(
                getPages: routes,
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.system,
                theme: getTheme(false),
                darkTheme: getTheme(true),
                home: ResponsivePage(),
                builder: (context, child) {
                    final mq = MediaQuery.of(context);
                    final clamped = mq.textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.20);

                    // Pick the active Theme (light/dark) and add scaled text on top
                    final inheritedTheme = Theme.of(context);
                    final withScaledText = inheritedTheme.copyWith(
                        textTheme: AppTypographyScaled.of(context, fontFamily: 'Inter')
                    );

                    return MediaQuery(
                        data: mq.copyWith(textScaler: clamped),
                        child: Theme(data: withScaledText, child: child!)
                    );
                }

            )
        );
    }
}
