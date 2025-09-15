import 'package:flutter/widgets.dart';

abstract class KeyboardController {
    final TextEditingController text;

    KeyboardController(this.text);

    void insert(String value);

    void backspace(String value);

    // Property to track key press state
    bool isKeyPressed = false;
}
