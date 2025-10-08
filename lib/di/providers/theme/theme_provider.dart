import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
    ThemeNotifier() : super(ThemeMode.light) {
        _loadTheme();
    }

    bool get isDark => state == ThemeMode.dark;

    Future<void> _loadTheme() async {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('themeMode')) {
            final index = prefs.getInt('themeMode')!;

            if (index >= 0 && index < ThemeMode.values.length) {
                state = ThemeMode.values[index];
            } else {
                state = ThemeMode.system; // fallback to system if invalid value
            }
        } else {
            state = ThemeMode.system; // follow device if nothing saved
        }
    }

    Future<void> setTheme(ThemeMode mode) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('themeMode', mode.index);
        state = mode;
    }

    Future<void> toggleTheme() async {
        // simple light <-> dark toggle (doesn't set system)
        final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        await setTheme(newMode);
    }

    Future<void> followSystem() => setTheme(ThemeMode.light);
}


final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
        return ThemeNotifier();
    });
