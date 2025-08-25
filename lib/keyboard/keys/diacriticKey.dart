
import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';
import 'package:kothai_app/theme/figma_color.dart';

class Diacritickey extends StatelessWidget {
    final String label;
    final VoidCallback? onPressed;
    final bool isActive;

    const Diacritickey({super.key, required this.label, this.onPressed, this.isActive = false});

    @override
    Widget build(BuildContext context) {
        return KothaiKey(
            background: isActive ? Color.fromARGB(255, 26, 115, 233) : getFigmaColor(context, 'Schemes/Surface Dim').withValues(
                red: 0,
                green: 0,
                blue: 0
            ).withAlpha(40),
            onPressed: onPressed,
            child: Text(
                label,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSansTamil',
                    color: isActive ? Colors.white : Colors.black,
                ),
            ),
        );
    }
}
