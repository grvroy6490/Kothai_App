import 'package:flutter/material.dart';

/// Global [ScaffoldMessenger] for [GetMaterialApp] — snackbars here render above modals.
final GlobalKey<ScaffoldMessengerState> appScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
