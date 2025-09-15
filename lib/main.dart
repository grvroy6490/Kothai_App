import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/app/app.dart';
import 'package:kothai_app/di/poviders/shared_prefs_provider.dart';
import 'package:kothai_app/services/shared_prefs_service.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final service = SharedPrefsServiceImpl();
    await service.init();
    runApp(
        ProviderScope(
            overrides: [sharedPrefsServiceProvider.overrideWithValue(service),],
            child: const App()
        )
    );
}



