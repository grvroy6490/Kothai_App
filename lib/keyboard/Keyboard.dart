import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/KeyboardEnum.dart';
import 'package:kothai_app/keyboard/layouts/NumberKeyLayout.dart';
import 'package:kothai_app/keyboard/layouts/SymbolKeyLayout.dart';
import 'package:kothai_app/keyboard/layouts/TamilKeyLayout.dart';




class Keyboard extends StatefulWidget {
    final ValueChanged<String>? onKeyPressed;
    const Keyboard({super.key, this.onKeyPressed});


    @override
    State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
    KeyboardType _layout = KeyboardType.tamil; // initial state

    void _changeKeyboardLayout(KeyboardType type) {
        if (_layout == type) return;
        setState(() => _layout = type);
    }

    @override
    Widget build(BuildContext context) {
        switch (_layout) {
            case KeyboardType.tamil:
                return BuildTamilKeysLayout(
                    context,
                    widget.onKeyPressed,
                    _changeKeyboardLayout,
                );
            case KeyboardType.number:
                return BuildNumberKeysLayout(
                    context,
                    widget.onKeyPressed,
                    _changeKeyboardLayout,
                );
            case KeyboardType.symbolic:
                return BuildSymbolKeysLayout(
                    context,
                    widget.onKeyPressed,
                    _changeKeyboardLayout,
                );
        }
    }
}







