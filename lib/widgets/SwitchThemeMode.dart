



import 'package:flutter/material.dart';
import 'package:kothai_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SwitchThemeMode extends StatelessWidget {
    const SwitchThemeMode({super.key});

    @override
    Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

        return ElevatedButton(
            onPressed: () {
                themeProvider.toggleTheme();
            },
            child: const Text("Toggle Theme"),
        );
    }
}
