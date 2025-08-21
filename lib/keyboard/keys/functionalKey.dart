
import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';

class FunctionalKey extends StatelessWidget {
    final dynamic iconOrText;
    final VoidCallback? onPressed;

    const FunctionalKey({super.key, required this.iconOrText, this.onPressed});

    @override
    Widget build(BuildContext context) {
        Widget child;
        if (iconOrText is IconData) {
            child = Icon(iconOrText, color: Colors.black, size: 18);
        } else if (iconOrText is String) {
            child = Text(
                iconOrText,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'NotoSansTamil',
                ),
            );
        } else {
            child = const Icon(Icons.help_outline, color: Colors.black, size: 18);
        }

        return KothaiKey(
            onPressed: onPressed,
            isFunction: true,
            child: child,
        );
    }
}