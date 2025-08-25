import 'package:flutter/material.dart';
import 'package:kothai_app/theme/figma_color.dart';

class KothaiKey extends StatelessWidget {
    final Widget child;
    final VoidCallback? onPressed;
    final bool isFunction;
    final double height;
    final double borderRadius;
    final Color? background;

    const KothaiKey({
        super.key,
        required this.child,
        this.onPressed,
        this.isFunction = false,
        this.height = 40,
        this.borderRadius = 5,
        this.background,
    });

    @override
    Widget build(BuildContext context) {
        final bgColor = background ??
            (isFunction ? getFigmaColor(context, 'State Layers/On Background/Opacity-08') : const Color(0xFF40444C));

        return SizedBox(
            height: height,
            child: Material(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderRadius),
                child: InkWell(
                    onTap: onPressed,
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Center(child: child),
                ),
            ),
        );
    }
}

