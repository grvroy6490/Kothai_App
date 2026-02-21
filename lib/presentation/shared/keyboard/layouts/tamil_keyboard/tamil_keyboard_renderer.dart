import 'package:flutter/widgets.dart';
import 'package:visai/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:visai/enums/KeyboardLayoutTypeEnum.dart';
import 'package:visai/presentation/shared/keyboard/keyboard_layout.dart';
import 'package:visai/core/abstracts/keyboard/keyboard_renderer.dart';
import 'package:visai/presentation/shared/keyboard/layouts/tamil_keyboard/tamil_numeric_layout.dart';
import 'package:visai/presentation/shared/keyboard/layouts/tamil_keyboard/tamil_regualr_layout.dart';
import 'package:visai/presentation/shared/keyboard/layouts/tamil_keyboard/tamil_symbolic_layout.dart';

class TamilKeyboardRenderer implements KeyboardRenderer {
    final KeyboardLayout defaultLayout = const KeyboardLayout(6, 10);

    @override
    Widget build(KeyboardController controller, KeyboardLayoutType layoutType) {
        switch (layoutType) {
            case KeyboardLayoutType.regular:
                return TamilRegularKeyboardLayout(controller: controller);
            case KeyboardLayoutType.numeric:
                return TamilNumericKeyboardLayout(controller: controller);
            case KeyboardLayoutType.symbolic:
                return TamilSymbolicKeyboardLayout(controller: controller);
            // No default; previous cases cover all enum values
        }
    }
}
