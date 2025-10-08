import 'package:flutter/widgets.dart';

 // pick your design width

extension KxScale on BuildContext {
    static const kBaselineWidth = 390.0;
    double get r {
        final w = MediaQuery.sizeOf(this).width;
        final s = w / kBaselineWidth;
        return s.clamp(0.90, 1.15);
    }
    double sp(num base) => base.toDouble() * r;   // text
    double gap(double base) => base * r;  // spacing
}

extension Gap on BuildContext {
    double get r => KxScale.kBaselineWidth == 0 ? 1 : (MediaQuery.sizeOf(this).width / KxScale.kBaselineWidth).clamp(0.90, 1.15);
    double gap(num v) => v.toDouble() * r;
}