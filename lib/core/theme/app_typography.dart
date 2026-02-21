import 'package:flutter/material.dart';
import 'package:visai/core/config/ui/scale.dart';

class AppTypography {
    /// Figma: Display / Large
    static const TextStyle displayLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 55,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: 0
    );

    /// Figma: Display / Medium
    static const TextStyle displayMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 43,
        fontWeight: FontWeight.w400,
        height: 1.16,
        letterSpacing: 0
    );

    /// Figma: Display / Small
    static const TextStyle displaySmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 34,
        fontWeight: FontWeight.w400,
        height: 1.22,
        letterSpacing: 0
    );

    /// Figma: Headline / Large
    static const TextStyle headlineLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 30,
        fontWeight: FontWeight.w400,
        height: 1.25,
        letterSpacing: 0
    );

    /// Figma: Headline / Medium
    static const TextStyle headlineMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 26,
        fontWeight: FontWeight.w400,
        height: 1.29,
        letterSpacing: 0
    );

    /// Figma: Headline / Small
    static const TextStyle headlineSmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 22,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0
    );

    /// Figma: Title / Large
    static const TextStyle titleLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.27,
        letterSpacing: 0
    );

    /// Figma: Title / Medium
    static const TextStyle titleMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.15
    );

    /// Figma: Title / Small
    static const TextStyle titleSmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1
    );

    /// Figma: Label / Large
    static const TextStyle labelLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1
    );

    /// Figma: Label / Medium
    static const TextStyle labelMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5
    );

    /// Figma: Label / Small
    static const TextStyle labelSmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 9,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5
    );

    /// Figma: Body / Large
    static const TextStyle bodyLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.15
    );

    /// Figma: Body / Medium
    static const TextStyle bodyMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25
    );

    /// Figma: Body / Small
    static const TextStyle bodySmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4
    );

    /// Build a scaled TextTheme from your constants.
    static TextTheme scaled(BuildContext c) {
        // helper to scale a TextStyle’s fontSize if present
        TextStyle? s(TextStyle? t) =>
        t?.copyWith(fontSize: t.fontSize == null ? null : c.sp(t.fontSize!));

        return TextTheme(
            displayLarge:   s(displayLarge),
            displayMedium:  s(displayMedium),
            displaySmall:   s(displaySmall),
            headlineLarge:  s(headlineLarge),
            headlineMedium: s(headlineMedium),
            headlineSmall:  s(headlineSmall),
            titleLarge:     s(titleLarge),
            titleMedium:    s(titleMedium),
            titleSmall:     s(titleSmall),
            labelLarge:     s(labelLarge),
            labelMedium:    s(labelMedium),
            labelSmall:     s(labelSmall),
            bodyLarge:      s(bodyLarge),
            bodyMedium:     s(bodyMedium),
            bodySmall:      s(bodySmall)
        );
    }
}
