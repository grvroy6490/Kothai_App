import 'package:flutter/widgets.dart';
import 'package:kothai_app/features/keyboard/domain/contracts/keyboard_controller.dart';
import 'package:kothai_app/features/typing_session/domain/enums/keyboard_layout_type_enum.dart';

abstract class KeyboardRenderer {
    Widget build(KeyboardController controller, KeyboardLayoutType layoutType);
}
