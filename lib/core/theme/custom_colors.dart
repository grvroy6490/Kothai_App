import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Map<String, Color> colors;

  const CustomColors({required this.colors});

  Color? color(String path) => colors[path];
  Color? operator [](String path) => color(path);

  Color? c(String path) {
    final norm = _normalize(path);
    return colors.entries
        .firstWhere(
          (e) => _normalize(e.key) == norm,
          orElse: () => MapEntry('', Colors.transparent),
        )
        .value;
  }

  @override
  CustomColors copyWith({Map<String, Color>? colors}) =>
      CustomColors(colors: colors ?? this.colors);

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    final allKeys = {...colors.keys, ...other.colors.keys};
    final out = <String, Color>{};
    for (final k in allKeys) {
      final a = colors[k];
      final b = other.colors[k];
      if (a == null) {
        out[k] = b!;
      } else if (b == null) {
        out[k] = a;
      } else {
        out[k] = Color.lerp(a, b, t)!;
      }
    }
    return CustomColors(colors: out);
  }

  static String _normalize(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'[\s./_-]+'), '/');
}
