import 'package:flutter/widgets.dart';

abstract class KeyboardController {
  final TextEditingController text;

  const KeyboardController(this.text);

  void insert(String value);

  void backspace(String value);
}
