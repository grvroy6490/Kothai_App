import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kothai_ui/kothai_ui.dart';
import 'pages/splash_page.dart';
import 'package:kothai_ui/theme/figma_color.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // FirebaseAuth.instance.setLanguageCode('en');
    // Ensure the locale is explicitly set to avoid null warnings
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
            fn,
        ) {
            runApp(const KothaiApp());
        });
}

class KothaiApp extends StatelessWidget {
    const KothaiApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            // routes: Routes.routes,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: getTheme(false),
            darkTheme: getTheme(true),
            home: const SplashScreenWrapper(),
        );
    }
}

class SplashScreenWrapper extends StatefulWidget {
    const SplashScreenWrapper({super.key});

    @override
    State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
    @override
    void initState() {
        super.initState();
        Future.delayed(const Duration(seconds: 2), () {
                // Navigator.of(context).pushReplacementNamed('/editor');
            });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Surface'),
            body: const SplashPage(),
        );
    }
}
