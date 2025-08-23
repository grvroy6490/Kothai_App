import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kothai_app/pages/SplashPage.dart';
import 'package:kothai_app/pages/auth/AuthCommon.dart';
import 'package:kothai_app/provider/StartStopPracticeModel.dart';
import 'package:kothai_app/provider/theme_provider.dart';
import 'package:kothai_app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kothai_app/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAuth.instance.setLanguageCode('en');
    // Ensure the locale is explicitly set to avoid null warnings
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
            fn,
        ) {
            runApp(const App());
        });
}

class App extends StatelessWidget {
    const App({super.key});

    @override
    Widget build(BuildContext context) {
        return MultiProvider(
            providers: [
                ChangeNotifierProvider(create: (_) => ThemeProvider()),
                ChangeNotifierProvider(create: (_) => StartStopPracticeModel()),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                    return MaterialApp(
                        routes: Routes.routes,
                        debugShowCheckedModeBanner: false,
                        themeMode: themeProvider.themeMode,
                        theme: getTheme(true),
                        darkTheme: getTheme(false),
                        home: SplashScreenWrapper(),
                    );
                },
            ),
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
            Navigator.of(context).pushReplacementNamed('/editor');
        });
    }

    @override
    Widget build(BuildContext context) {
        return SplashPage();
    }
}





class OpenPopupButton extends StatelessWidget {
    const OpenPopupButton({super.key});

    void _showFullPagePopup(BuildContext context) {
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            barrierColor: Colors.transparent,
            // no dark overlay
            backgroundColor: Colors.transparent,
            // fully transparent background
            builder: (BuildContext context) {
                return Authcommon();
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return ElevatedButton(
            onPressed: () => _showFullPagePopup(context),
            child: const Text("Show Full Page Popup"),
        );
    }
}


// final mode = Provider.of<ThemeProvider>(context).themeMode;
// print(mode); // ThemeMode.system, ThemeMode.light, or ThemeMode.dark
// final isDark = Provider.of<ThemeProvider>(context).isDark;
//

// ✅ Direct ThemeExtension access:
// final cc = Theme.of(context).extension<CustomColors>()!;
// final bg = cc['Surfaces/Surface 2'];
//
//
// // ✅ Helper usage (recommended):
// final primary = getFigmaColor(context, 'Schemes/Primary');
// final label = getFigmaColor(context, 'State Layers/Pressed/Surface');
//
//
// // ✅ Safe fallback:
// final outline = getFigmaColor(context, 'Schemes/Outline', fallback: Colors.grey);