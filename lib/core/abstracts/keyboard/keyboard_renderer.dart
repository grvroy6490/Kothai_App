import 'package:flutter/widgets.dart';
import 'package:visai/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:visai/enums/KeyboardLayoutTypeEnum.dart';

abstract class KeyboardRenderer {
  Widget build(KeyboardController controller, KeyboardLayoutType layoutType);
}
