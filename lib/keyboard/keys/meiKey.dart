
import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';

class Meikey extends StatelessWidget {
    final String label;
    final VoidCallback? onPressed;
    const Meikey({super.key,  required this.label, this.onPressed});

    @override
    Widget build(BuildContext context) {
        return KothaiKey(
            onPressed: onPressed,
            background: Color.fromARGB(255, 159, 170, 188),
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
