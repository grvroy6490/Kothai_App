import 'dart:math';
import 'package:flutter/material.dart';

class RoundedPieSlicePainter extends CustomPainter {
    final double startAngle; // radians
    final double sweepAngle; // radians
    final double radius;
    final double cornerRadius;
    final Color color;

    RoundedPieSlicePainter({
        required this.startAngle,
        required this.sweepAngle,
        required this.radius,
        required this.cornerRadius,
        this.color = Colors.orange
    });

    @override
    void paint(Canvas canvas, Size size) {
        final center = Offset(size.width / 2, size.height / 2);
        final paint = Paint()
            ..style = PaintingStyle.fill
            ..isAntiAlias = true
            ..color = color;

        final path = Path();

        // Angles adjusted so 0 is at top
        final double start = startAngle - pi / 2;
        final double end = start + sweepAngle;

        // Points on the arc for start and end
        final startPoint = Offset(
            center.dx + radius * cos(start),
            center.dy + radius * sin(start)
        );
        final endPoint = Offset(
            center.dx + radius * cos(end),
            center.dy + radius * sin(end)
        );

        // Move to center
        path.moveTo(center.dx, center.dy);

        // Line to startPoint but offset inward for rounded corner
        final startCorner = Offset(
            center.dx + (radius - cornerRadius) * cos(start),
            center.dy + (radius - cornerRadius) * sin(start)
        );
        path.lineTo(startCorner.dx, startCorner.dy);

        // Draw small arc (corner rounding)
        path.arcToPoint(
            startPoint,
            radius: Radius.circular(cornerRadius),
            clockwise: true
        );

        // Big arc for the slice outer edge
        path.arcTo(
            Rect.fromCircle(center: center, radius: radius),
            start,
            sweepAngle,
            false
        );

        // End corner arc back inward
        final endCorner = Offset(
            center.dx + (radius - cornerRadius) * cos(end),
            center.dy + (radius - cornerRadius) * sin(end)
        );
        path.arcToPoint(
            endCorner,
            radius: Radius.circular(cornerRadius),
            clockwise: true
        );

        // Line back to center
        path.lineTo(center.dx, center.dy);

        path.close();
        canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
