import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/enums/KeyboardLayoutTypeEnum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kothai_app/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:kothai_app/presentation/shared/keyboard/layouts/tamil_keyboard/tamil_keyboard.dart'
    as tamil_controller;
import 'package:kothai_app/presentation/shared/keyboard/layouts/tamil_keyboard/tamil_keyboard_renderer.dart';
import 'package:kothai_app/core/abstracts/keyboard/keyboard_renderer.dart';
import 'package:flutter/widgets.dart';

// KEYBOARD NOTIFIER
class KeyboardNotifier extends StateNotifier<bool> {
  KeyboardNotifier() : super(false);

  bool get practiceSettingStatus => state;

  void showKeyboard() => state = true;

  void hideKeyboard() => state = false;
}

// KEYBOARD LAYOUT NOTIFIER
class KeyboardLayoutNotifier extends StateNotifier<KeyboardLayoutType> {
  KeyboardLayoutNotifier() : super(KeyboardLayoutType.regular);

  KeyboardLayoutType get keyboardLayout => state;

  void setRegular() => state = KeyboardLayoutType.regular;
  void setNumeric() => state = KeyboardLayoutType.numeric;
  void setsymbolic() => state = KeyboardLayoutType.symbolic;
}

final keyboardProvider = StateNotifierProvider<KeyboardNotifier, bool>(
  (ref) => KeyboardNotifier(),
);

final keyboardLayoutProvider =
    StateNotifierProvider<KeyboardLayoutNotifier, KeyboardLayoutType>(
      (ref) => KeyboardLayoutNotifier(),
    );

// Keyboard controller factory provider (can switch by locale/settings later)
final keyboardControllerProvider =
    Provider.family<KeyboardController, TextEditingController>((
      ref,
      textController,
    ) {
      final controller = tamil_controller.TamilKeyboard(textController);
      controller.setRef(ref);
      return controller;
    });

// Keyboard renderer provider (swap renderer to switch keyboard family)
final keyboardRendererProvider = Provider<KeyboardRenderer>((ref) {
  return TamilKeyboardRenderer();
});

// Hold key provider to track held left diacritics
class HoldKeyNotifier extends StateNotifier<String?> {
  HoldKeyNotifier() : super(null);

  void holdFor(String diacritic) => state = diacritic;
  void clear() => state = null;
}

final holdKeyProvider = StateNotifierProvider<HoldKeyNotifier, String?>((ref) {
  return HoldKeyNotifier();
});
