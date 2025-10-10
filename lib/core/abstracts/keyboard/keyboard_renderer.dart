import 'package:flutter/widgets.dart';
import 'package:kothai_app/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:kothai_app/enums/KeyboardLayoutTypeEnum.dart';

abstract class KeyboardRenderer {
  Widget build(KeyboardController controller, KeyboardLayoutType layoutType);
}
