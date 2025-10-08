import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/di/providers/theme/theme_provider.dart';

class SwitchThemeMode extends StatelessWidget {
    const SwitchThemeMode({super.key});

    @override
    Widget build(BuildContext context) {
        return Consumer(
            builder: (context, ref, child) {
                return IconButton(
                    onPressed: () {
                        ref.read(themeProvider.notifier).toggleTheme();
                    },
                    icon: const Icon(Icons.brightness_6)
                );
            }
        );
    }
}
