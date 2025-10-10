import 'package:flutter/material.dart';
import 'custom_colors.dart';

Color getFigmaColor(
  BuildContext context,
  String path, {
  Color fallback = Colors.transparent,
}) {
  final ext = Theme.of(context).extension<CustomColors>();
  return ext?.c(path) ?? fallback;
}
