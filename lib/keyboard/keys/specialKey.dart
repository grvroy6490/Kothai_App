
import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';
import 'package:kothai_app/theme/figma_color.dart';

class Specialkeys extends StatelessWidget {
    final String label;
    final VoidCallback? onPressed;
    const Specialkeys({super.key, required this.label, this.onPressed});

    @override
    Widget build(BuildContext context) {
        return KothaiKey(
            onPressed: onPressed,
            background: getFigmaColor(context, 'State Layers/Inverse Surface/Opacity-16'),
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
