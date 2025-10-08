import 'dart:math';
import 'package:flutter/material.dart';

/// A scalloped/starburst badge that centers [child] inside.
class StarburstBadge extends StatelessWidget {
    final double size;
    final int spikes;              // number of scallops (e.g. 16–24)
    final double innerRatio;       // inner radius / outer radius (0.5–0.9)
    final Widget child;
    final VoidCallback? onTap;
    final Color? starColor;

    const StarburstBadge({
        super.key,
        required this.child,
        this.size = 200,
        this.spikes = 20,
        this.innerRatio = 0.78,
        this.onTap,
        this.starColor
    });

    @override
    Widget build(BuildContext context) {
        final badge = ClipPath(
            clipper: _StarburstClipper(spikes: spikes, innerRatio: innerRatio),
            child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    // soft lilac gradient like your mock
                    color: starColor ?? Color(0x1A000000),
                    boxShadow: const [
                        BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 16,
                            spreadRadius: 2,
                            offset: Offset(0, 6)
                        )
                    ]
                ),
                child: Stack(
                    alignment: Alignment.center,
                    children: [
                        // subtle inner vignette to sell the embossed look
                        // IgnorePointer(
                        //     child: Container(
                        //         decoration: const BoxDecoration(
                        //             gradient: RadialGradient(
                        //                 center: Alignment(0, -0.1),
                        //                 radius: 0.9,
                        //                 colors: [
                        //                     Colors.white70,
                        //                     Colors.transparent,
                        //                 ],
                        //                 stops: [0.3, 1],
                        //             ),
                        //         ),
                        //     ),
                        // ),
                        child // 👈 your center content
                    ]
                )
            )
        );

        return onTap == null ? badge : GestureDetector(onTap: onTap, child: badge);
    }
}

/// Clipper that creates a starburst/scalloped circle.
class _StarburstClipper extends CustomClipper<Path> {
    final int spikes;
    final double innerRatio;

    _StarburstClipper({required this.spikes, required this.innerRatio});

    @override
    Path getClip(Size size) {
        final c = size.center(Offset.zero);
        final outerR = size.shortestSide / 2;
        final innerR = outerR * innerRatio;

        final path = Path();
        for (int i = 0; i < spikes * 2; i++) {
            final r = (i.isEven) ? outerR : innerR;
            final angle = (pi * i) / spikes - pi / 2; // start at top
            final x = c.dx + cos(angle) * r;
            final y = c.dy + sin(angle) * r;
            if (i == 0) {
                path.moveTo(x, y);
            } else {
                path.lineTo(x, y);
            }
        }
        path.close();
        return path;
    }

    @override
    bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
