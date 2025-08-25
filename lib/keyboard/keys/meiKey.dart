
import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';
import 'package:kothai_app/theme/figma_color.dart';

class Meikey extends StatelessWidget {
    final String label;
    final VoidCallback? onPressed;
    const Meikey({super.key,  required this.label, this.onPressed});

    @override
    Widget build(BuildContext context) {
        return KothaiKey(
            onPressed: onPressed,
            background: getFigmaColor(context, 'Schemes/Surface Dim'),
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
