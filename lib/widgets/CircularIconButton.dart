import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgCircularIconButton extends StatelessWidget {
    final String svgPath;
    final double size;
    final double iconSize;
    final Color backgroundColor;
    final VoidCallback onPressed;

    const SvgCircularIconButton({
        super.key,
        required this.svgPath,
        required this.onPressed,
        this.size = 48,
        this.iconSize = 24,
        this.backgroundColor = const Color(0xFFE0E0E0),
    });

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            height: size,
            width: size,
            child: Material(
                color: backgroundColor,
                shape: const CircleBorder(
                  side: BorderSide(color: Colors.white, width: 2),
                ),
                child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onPressed,
                    child: Center(
                        child: SvgPicture.asset(
                            svgPath,
                            height: iconSize,
                            width: iconSize,
                        ),
                    ),
                ),
            ),
        );
    }
}
