import 'package:flutter/widgets.dart';
import 'package:kothai_app/features/keyboard/domain/contracts/keyboard_controller.dart';
import 'package:kothai_app/features/keyboard/domain/contracts/keyboard_renderer.dart';
import 'package:kothai_app/features/keyboard/presentation/tamil_keyboard/tamil_numeric_layout.dart';
import 'package:kothai_app/features/keyboard/presentation/tamil_keyboard/tamil_regular_layout.dart';
import 'package:kothai_app/features/keyboard/presentation/tamil_keyboard/tamil_symbolic_layout.dart';
import 'package:kothai_app/features/typing_session/domain/enums/keyboard_layout_type_enum.dart';
import 'package:kothai_app/features/keyboard/presentation/keyboard_layout.dart';


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
