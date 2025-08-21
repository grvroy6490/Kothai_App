
import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';

class Uyirkey extends StatelessWidget {
    final String label;
    final VoidCallback? onPressed;

    const Uyirkey({super.key, required this.label, this.onPressed});

    @override
    Widget build(BuildContext context) {
        return KothaiKey(
            background: Color.fromARGB(255, 196, 205, 220),
            onPressed: onPressed,
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






