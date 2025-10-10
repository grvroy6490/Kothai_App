import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/keyboard/domain/contracts/keyboard_controller.dart';
import 'package:kothai_app/features/keyboard/domain/contracts/keyboard_renderer.dart';
import 'package:kothai_app/features/keyboard/presentation/tamil_keyboard/tamil_keyboard.dart';
import 'package:kothai_app/features/keyboard/presentation/tamil_keyboard/tamil_keyboard_renderer.dart';
import 'package:kothai_app/features/typing_session/domain/entities/session/session_handler_entity.dart';
import 'package:kothai_app/features/typing_session/domain/enums/keyboard_layout_type_enum.dart';

import 'package:flutter/widgets.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';

// KEYBOARD NOTIFIER
class KeyboardStatusController extends Notifier<bool> {
    @override
    bool build() {
        // listen to changes in session handler
        ref.listen<SessionHandler>(
            sessionStatusControllerProvider,
            (prev, next) {
                // Logic: keyboard visible only when session is actively running
                final isTypingSession = next.mode != SessionMode.none;
                final isRunning = next.status == SessionStatusEnum.start;

                state = isTypingSession && isRunning;
            }
        );

        // initial keyboard visibility (hidden)
        return false;
    }

    // Optional manual controls for animations or override
    void showKeyboard() => state = true;
    void hideKeyboard() => state = false;
    void toggleKeyboard() => state = !state;
}

// KEYBOARD LAYOUT NOTIFIER
class KeyboardLayoutNotifier extends StateNotifier<KeyboardLayoutType> {
    KeyboardLayoutNotifier() : super(KeyboardLayoutType.regular);

    KeyboardLayoutType get keyboardLayout => state;

    void setRegular() => state = KeyboardLayoutType.regular;
    void setNumeric() => state = KeyboardLayoutType.numeric;
    void setsymbolic() => state = KeyboardLayoutType.symbolic;
}




// PROVIDOR SELECTORS
final keyboardStatusProvider = NotifierProvider<KeyboardStatusController, bool>(KeyboardStatusController.new);

final keyboardLayoutProvider =
    StateNotifierProvider<KeyboardLayoutNotifier, KeyboardLayoutType>(
        (ref) => KeyboardLayoutNotifier()
    );

// Keyboard controller factory provider (can switch by locale/settings later)
final keyboardControllerProvider =
    Provider.family<KeyboardController, TextEditingController>((
            ref,
            textController
        ) {
            final controller = TamilKeyboard(textController);
            controller.setRef(ref);
            return controller;
        });

// Keyboard renderer provider (swap renderer to switch keyboard family)
final keyboardRendererProvider = Provider<KeyboardRenderer>((ref) {
        return TamilKeyboardRenderer();
    });

// Hold key provider to track held left diacritics
class HoldKeyNotifier extends StateNotifier<String?> {
    HoldKeyNotifier() : super(null);

    void holdFor(String diacritic) => state = diacritic;
    void clear() => state = null;
}

final holdKeyProvider = StateNotifierProvider<HoldKeyNotifier, String?>((ref) {
        return HoldKeyNotifier();
    });
