

import 'package:flutter/material.dart';

class BendLinePainter extends CustomPainter {
    final Color color;

    BendLinePainter({this.color = Colors.blue});

    @override
    void paint(Canvas canvas, Size size) {
        final paint = Paint()
            ..color = color
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke;

        final path = Path();
        path.moveTo(0, size.height / 2); // start left middle

        // Quadratic Bezier curve to right middle
        path.quadraticBezierTo(
            size.width / 2, 0,          // control point (makes it bend upwards)
            size.width, size.height / 2 // end point (right middle)
        );

        canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(covariant BendLinePainter oldDelegate) =>
    oldDelegate.color != color;
}