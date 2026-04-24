import 'package:flutter/widgets.dart';

abstract class KeyboardController {
    final TextEditingController text;

    KeyboardController(this.text);

    void insert(String value);

  void backspace(String value);

  /// Clear any held Tamil diacritic / composition state (e.g. after session ends).
  void resetCompositionState() {}

  // Property to track key press state
  bool isKeyPressed = false;
}
