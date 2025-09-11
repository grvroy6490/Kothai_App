import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/shared_prefs/shared_prefs_service.dart';
import 'package:kothai_app/presentation/providers/content/text_provider.dart';
import 'package:kothai_app/presentation/providers/shared_prefs_provider.dart';
import 'package:kothai_app/presentation/providers/theme_provider.dart';
import 'package:kothai_app/presentation/routes/routes.dart';
import 'package:kothai_app/presentation/screens/practice-page/PracticeScreen.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';
import 'package:kothai_app/presentation/theme/theme_manager.dart';
import 'presentation/screens/SplashPage.dart';
import 'package:get/get.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    final prefs = SharedPrefsServiceImpl();
    await prefs.init();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(
        ProviderScope(
            overrides: [sharedPrefsServiceProvider.overrideWithValue(prefs)],
            child: const App(),
        ),
    );
}

class App extends ConsumerWidget {
    const App({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final themeMode = ref.watch(themeProvider);

        final preloadFuture = ref.watch(preloadTypingTextsProvider)();

        return FutureBuilder(
            future: preloadFuture,
            builder: (context, snapshot) {
                Widget home;
                if (snapshot.connectionState == ConnectionState.waiting) {
                    home = const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                    );
                } else if (snapshot.hasError) {
                    home = Scaffold(
                        body: Center(child: Text('Error: ${snapshot.error}')),
                    );
                } else {
                    home = const SplashScreenWrapper();
                }

                return GetMaterialApp(
                    routes: Routes.routes,
                    debugShowCheckedModeBanner: false,
                    themeMode: themeMode,
                    theme: getTheme(false),
                    darkTheme: getTheme(true),
                    home: home,
                );
            },
        );
    }
}

class SplashScreenWrapper extends StatefulWidget {
    const SplashScreenWrapper({super.key});

    @override
    State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper>
    with SingleTickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _fadeAnimation;

    @override
    void initState() {
        super.initState();

        // Initialize animation controller
        _animationController = AnimationController(
            duration: const Duration(milliseconds: 1000),
            vsync: this,
        );

        // Create fade animation
        _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );

        // Start the animation
        _animationController.forward();

        // Navigate after animation completes with simple transition
        Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                    Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            const PracticeScreen(),
                            transitionDuration: const Duration(milliseconds: 600),
                            transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                        ),
                    );
                }
            });
    }

    @override
    void dispose() {
        _animationController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Surface'),
            body: FadeTransition(
                opacity: _fadeAnimation,
                child: const SplashPage(),
            ), // Splash Screen
        );
    }
}
