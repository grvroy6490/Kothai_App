import 'package:flutter/material.dart';
import 'package:kothai_app/theme/color_flatten.dart';
import 'package:kothai_app/theme/color_sheme.dart';
import 'package:kothai_app/theme/custom_colors.dart';

ThemeData getTheme(bool isDark) {
    final schemeMap = isDark ? completeColorScheme.dark : completeColorScheme.light;

    final base = isDark ? const ColorScheme.dark() : const ColorScheme.light();

    final colorScheme = base.copyWith(
        primary: schemeMap['Schemes']?['Primary'],
        onPrimary: schemeMap['Schemes']?['On Primary'],
        secondary: schemeMap['Schemes']?['Secondary'],
        onSecondary: schemeMap['Schemes']?['On Secondary'],
        surface: schemeMap['Schemes']?['Surface'],
        onSurface: schemeMap['Schemes']?['On Surface'],
        error: schemeMap['Schemes']?['Error'],
        onError: schemeMap['Schemes']?['On Error'],
        primaryContainer: schemeMap['Schemes']?['Primary Container'],
        onPrimaryContainer: schemeMap['Schemes']?['On Primary Container'],
        surfaceVariant: schemeMap['Schemes']?['Surface Variant'],
        onSurfaceVariant: schemeMap['Schemes']?['On Surface Variant'],
        outline: schemeMap['Schemes']?['Outline'],
        outlineVariant: schemeMap['Schemes']?['Outline Variant'],
        tertiary: schemeMap['Schemes']?['Tertiary'],
        onTertiary: schemeMap['Schemes']?['On Tertiary'],
    );

    final flatColors = flattenColorMap(schemeMap);

    return ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        extensions: [CustomColors(colors: flatColors)],
    );
}



class AppTypography {
    /// Figma: Display / Large
    static const TextStyle displayLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 57,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: 0,
    );

    /// Figma: Display / Medium
    static const TextStyle displayMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
        letterSpacing: 0,
    );

    /// Figma: Display / Small
    static const TextStyle displaySmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
        letterSpacing: 0,
    );

    /// Figma: Headline / Large
    static const TextStyle headlineLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 1.25,
        letterSpacing: 0,
    );

    /// Figma: Headline / Medium
    static const TextStyle headlineMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.29,
        letterSpacing: 0,
    );

    /// Figma: Headline / Small
    static const TextStyle headlineSmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0,
    );

    /// Figma: Title / Large
    static const TextStyle titleLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.27,
        letterSpacing: 0,
    );

    /// Figma: Title / Medium
    static const TextStyle titleMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.15,
    );

    /// Figma: Title / Small
    static const TextStyle titleSmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
    );

    /// Figma: Label / Large
    static const TextStyle labelLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
    );

    /// Figma: Label / Medium
    static const TextStyle labelMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
    );

    /// Figma: Label / Small
    static const TextStyle labelSmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
    );

    /// Figma: Body / Large
    static const TextStyle bodyLarge = TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.15,
    );

    /// Figma: Body / Medium
    static const TextStyle bodyMedium = TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
    );

    /// Figma: Body / Small
    static const TextStyle bodySmall = TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
    );
}
