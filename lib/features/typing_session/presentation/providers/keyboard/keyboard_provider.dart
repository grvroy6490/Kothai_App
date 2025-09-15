import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/typing_session/domain/contracts/keyboard_controller.dart';
import 'package:kothai_app/features/typing_session/domain/contracts/keyboard_renderer.dart';
import 'package:kothai_app/features/typing_session/domain/enums/keyboard_layout_type_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/keyboard/tamil_keyboard/tamil_keyboard.dart' as tamil_keyboard;
import 'package:kothai_app/features/typing_session/presentation/widgets/keyboard/tamil_keyboard/tamil_keyboard_renderer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter/widgets.dart';

// KEYBOARD NOTIFIER
class KeyboardStatusController extends Notifier<bool> {
    @override
    bool build() {
        // keep state in sync with practiceStatus
        ref.listen<PracticeStatusEnum>(practiceStatusProvider, (prev, next) {
                state = (next == PracticeStatusEnum.start);
            });

        // initial value
        final status = ref.watch(practiceStatusProvider);
        return status == PracticeStatusEnum.start;
    }

    // Optional manual overrides if you still want them:
    void showKeyboard() => state = true;
    void hideKeyboard() => state = false;
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
            final controller = tamil_keyboard.TamilKeyboard(textController);
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
