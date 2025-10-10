import 'package:flutter/material.dart';
import 'package:kothai_app/presentation/screens/SplashPage.dart';
import 'package:kothai_app/presentation/screens/practice-page/PracticeScreen.dart';

class Routes {
  static Map<String, WidgetBuilder> get routes => {
    '/splash': (context) => SplashPage(),
    '/practice': (context) => PracticeScreen(),
    // '/settings': (context) => SettingsPage(),
  };
}
