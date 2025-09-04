library kothai_ui;

import 'package:flutter/material.dart';
export 'theme/theme_manager.dart';
export 'theme/figma_color.dart';
export 'theme/app_typography.dart';
export 'widgets/switch_theme_mode.dart';

class KTheme {
  static ThemeData light() =>
      ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal);
}

class KAssets {
  static const String _images = 'packages/kothai_ui/assets/images';
  static String image(String name) => '$_images/$name';
}

class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Text from another package');
  }
}
