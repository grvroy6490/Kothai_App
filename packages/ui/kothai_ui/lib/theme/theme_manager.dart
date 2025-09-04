import 'package:flutter/material.dart';
import 'color_flatten.dart';
import 'color_scheme_data.dart';
import 'custom_colors.dart';

ThemeData getTheme(bool isDark) {
  final schemeMap = isDark
      ? completeColorScheme.dark
      : completeColorScheme.light;
  final base = isDark ? const ColorScheme.dark() : const ColorScheme.light();
  final colorScheme = base.copyWith(
    primary: schemeMap['Schemes']?['Primary'] as Color?,
    onPrimary: schemeMap['Schemes']?['On Primary'] as Color?,
    secondary: schemeMap['Schemes']?['Secondary'] as Color?,
    onSecondary: schemeMap['Schemes']?['On Secondary'] as Color?,
    surface: schemeMap['Schemes']?['Surface'] as Color?,
    onSurface: schemeMap['Schemes']?['On Surface'] as Color?,
    error: schemeMap['Schemes']?['Error'] as Color?,
    onError: schemeMap['Schemes']?['On Error'] as Color?,
    primaryContainer: schemeMap['Schemes']?['Primary Container'] as Color?,
    onPrimaryContainer: schemeMap['Schemes']?['On Primary Container'] as Color?,
    surfaceVariant: schemeMap['Schemes']?['Surface Variant'] as Color?,
    onSurfaceVariant: schemeMap['Schemes']?['On Surface Variant'] as Color?,
    outline: schemeMap['Schemes']?['Outline'] as Color?,
    outlineVariant: schemeMap['Schemes']?['Outline Variant'] as Color?,
    tertiary: schemeMap['Schemes']?['Tertiary'] as Color?,
    onTertiary: schemeMap['Schemes']?['On Tertiary'] as Color?,
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
