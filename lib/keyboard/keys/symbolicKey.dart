

import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';

class Symbolickey extends StatelessWidget {
    final String label;
    final VoidCallback? onPressed;
    const Symbolickey({super.key, required this.label, this.onPressed});

    @override
    Widget build(BuildContext context) {
        return KothaiKey(
            onPressed: onPressed,
            background: Color.fromARGB(255, 255, 255, 255),
            child: Text(
                label,
                style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSansTamil',
                    color: Colors.black,
                ),
            ),
        );
    }
}
