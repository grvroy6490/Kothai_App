
import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';

class Diacritickey extends StatelessWidget {
    final String label;
    final VoidCallback? onPressed;
    const Diacritickey({super.key, required this.label, this.onPressed});

    @override
    Widget build(BuildContext context) {
        return KothaiKey(
            background: Color.fromARGB(255, 157, 174, 202),
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
