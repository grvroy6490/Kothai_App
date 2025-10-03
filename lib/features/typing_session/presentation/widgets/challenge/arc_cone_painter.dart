

import 'package:flutter/material.dart';

class ArcConePainter extends CustomPainter {
    final Color color;
    final Gradient? gradient;
    final double borderWidth;
    final Color? borderColor;
    final double? rightMultiplier;
    final double? leftMultiplier;

    ArcConePainter({
        required this.color,
        this.gradient,
        this.borderWidth = 0,
        this.borderColor,
        this.rightMultiplier = 0.3,
        this.leftMultiplier = 0.3
    });

    @override
    void paint(Canvas canvas, Size size) {
        final path = Path();

        // Start at bottom center (cone tip)
        path.moveTo(size.width / 2, size.height);

        // Line up left side
        path.lineTo(0, size.height * leftMultiplier!);

        // Top arc
        path.quadraticBezierTo(
            size.width / 2, -size.height  * -0.215, // control point (adjust for curvature)
            size.width, size.height * rightMultiplier!     // end at right
        );

        // Back to bottom tip
        path.close();

        // Fill paint
        final fillPaint = Paint()
            ..style = PaintingStyle.fill
            ..isAntiAlias = true;

        if (gradient != null) {
            fillPaint.shader = gradient!.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
        } else {
            fillPaint.color = color;
        }

        canvas.drawPath(path, fillPaint);

        // Border paint
        if (borderWidth > 0 && borderColor != null) {
            final borderPaint = Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = borderWidth
                ..color = borderColor!
                ..isAntiAlias = true;
            canvas.drawPath(path, borderPaint);
        }
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
