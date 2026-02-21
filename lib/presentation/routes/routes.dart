import 'package:flutter/material.dart';
import 'package:visai/presentation/screens/SplashPage.dart';
import 'package:visai/presentation/screens/practice-page/PracticeScreen.dart';

class Routes {
  static Map<String, WidgetBuilder> get routes => {
    '/splash': (context) => SplashPage(),
    '/practice': (context) => PracticeScreen(),
    // '/settings': (context) => SettingsPage(),
  };
}
