import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kothai_app/pages/SplashPage.dart';
import 'package:kothai_app/pages/auth/AuthCommon.dart';
import 'package:kothai_app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
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
        return MaterialApp(
            routes: Routes.routes,
            themeMode: ThemeMode.system,
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            home: Scaffold(
                backgroundColor: Color.fromARGB(100, 74, 78, 90),
                body: SplashPage(),
            ),
        );
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
