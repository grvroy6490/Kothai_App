
import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';


class AppTypographyScaled {
    static TextTheme of(BuildContext c, {String fontFamily = 'Inter'}) {
        double s(num v) => c.sp(v);
        const w400 = FontWeight.w400, w500 = FontWeight.w500;

        return TextTheme(
            displayLarge:   TextStyle(fontFamily: fontFamily, fontSize: s(57), fontWeight: w400, height: 1.12),
            displayMedium:  TextStyle(fontFamily: fontFamily, fontSize: s(45), fontWeight: w400, height: 1.16),
            displaySmall:   TextStyle(fontFamily: fontFamily, fontSize: s(36), fontWeight: w400, height: 1.22),

            headlineLarge:  TextStyle(fontFamily: fontFamily, fontSize: s(32), fontWeight: w400, height: 1.25),
            headlineMedium: TextStyle(fontFamily: fontFamily, fontSize: s(28), fontWeight: w400, height: 1.29),
            headlineSmall:  TextStyle(fontFamily: fontFamily, fontSize: s(24), fontWeight: w400, height: 1.33),

            titleLarge:     TextStyle(fontFamily: fontFamily, fontSize: s(22), fontWeight: w500, height: 1.27),
            titleMedium:    TextStyle(fontFamily: fontFamily, fontSize: s(16), fontWeight: w500, height: 1.50, letterSpacing: 0.15),
            titleSmall:     TextStyle(fontFamily: fontFamily, fontSize: s(18), fontWeight: w500, height: 1.43, letterSpacing: 0.10),

            labelLarge:     TextStyle(fontFamily: fontFamily, fontSize: s(14), fontWeight: w500, height: 1.43, letterSpacing: 0.10),
            labelMedium:    TextStyle(fontFamily: fontFamily, fontSize: s(12), fontWeight: w500, height: 1.33, letterSpacing: 0.50),
            labelSmall:     TextStyle(fontFamily: fontFamily, fontSize: s(11), fontWeight: w500, height: 1.45, letterSpacing: 0.50),

            bodyLarge:      TextStyle(fontFamily: fontFamily, fontSize: s(16), fontWeight: w400, height: 1.50, letterSpacing: 0.15),
            bodyMedium:     TextStyle(fontFamily: fontFamily, fontSize: s(14), fontWeight: w400, height: 1.43, letterSpacing: 0.25),
            bodySmall:      TextStyle(fontFamily: fontFamily, fontSize: s(12), fontWeight: w400, height: 1.33, letterSpacing: 0.40)
        );
    }
}