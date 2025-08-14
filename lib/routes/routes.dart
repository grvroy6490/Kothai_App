
import 'package:flutter/material.dart';
import 'package:kothai_app/pages/Home.dart';
import 'package:kothai_app/pages/SplashPage.dart';

class Routes {
    static Map<String, WidgetBuilder> get routes => {
        '/splash': (context) => SplashPage(),
        '/home': (context) => Home(),
    };
}