import 'package:kothai_app/features/typing_session/domain/contracts/keyboard_controller.dart';

enum KeyType { uyir, mei, diacritic, functional, symbolic, special, colored }

typedef VoidCallbackTap = void Function(KeyboardController c);
