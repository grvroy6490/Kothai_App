import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/abstracts/keyboard/keyboard_controller.dart';
import 'package:visai/presentation/providers/session/session_state_provider.dart';
import 'package:visai/presentation/shared/keyboard/layouts/tamil_keyboard/letters.dart';
import 'package:visai/presentation/providers/keyboard/keyboard_provider.dart';

class TamilKeyboard extends KeyboardController {
    String? _heldLeftDiacritic;
    Ref? _ref;

    TamilKeyboard(super.text);

    void setRef(Ref ref) {
        _ref = ref;
    }

    @override
    void backspace(String value) {
        // Backspace should also honor the initial diacritic rule only if text is empty
        // If empty, nothing to delete; just return
        if (text.text.isEmpty) {
            return;
        }
        final selection = text.selection;
        final textValue = text.text;

        // If there's a selection, delete the selected text
        if (selection.start != selection.end) {
            final newText = textValue.replaceRange(
                selection.start,
                selection.end,
                '',
            );
            text.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: selection.start),
            );
            return;
        }

        // If selection is collapsed, delete the character before the caret
        final caretIndex = selection.start;
        if (caretIndex <= 0) return;

        final newText = textValue.replaceRange(caretIndex - 1, caretIndex, '');
        text.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: caretIndex - 1),
        );
        _ref?.read(sessionStateProvider.notifier).backspace();

    }

    @override
    void insert(String value) {

        // Handle left diacritic hold mechanism
        if (Letters.leftDiacriticLetters.contains(value)) {
            // Don't hold if last character is uyir
            if (text.text.isNotEmpty) {
                final lastChar = text.text[text.text.length - 1];
                if (Letters.uyirLetters.contains(lastChar)) {
                    return; // Don't hold diacritic after uyir
                }
            }
            _heldLeftDiacritic = value;
            _ref?.read(holdKeyProvider.notifier).holdFor(value);
            return; // Hold the diacritic, wait for next character
        }

        // Handle special keys - clear hold
        if ([' ', '\n', 'delete'].contains(value)) {
            if (_heldLeftDiacritic != null) {
                _heldLeftDiacritic = null;
                _ref?.read(holdKeyProvider.notifier).clear();
            }
            _insertText(value);
            return;
        }

        // Handle held left diacritic: only combine with mei; else clear and insert as-is
        if (_heldLeftDiacritic != null) {
            if (Letters.meiLetters.contains(value)) {
                final combinedValue = value + _heldLeftDiacritic!;
                _heldLeftDiacritic = null;
                _ref?.read(holdKeyProvider.notifier).clear();
                _insertText(combinedValue);
                return;
            } else {
                // Not mei: clear hold and insert the pressed key without diacritic
                _heldLeftDiacritic = null;
                _ref?.read(holdKeyProvider.notifier).clear();
                _insertText(value);
                return;
            }
        }

        // Guard: prevent starting input with right diacritics
        if (Letters.rightDiacriticLetters.contains(value) && text.text.isEmpty) {
            return;
        }

        // Guard: prevent right diacritics after uyir letters
        if (Letters.rightDiacriticLetters.contains(value) && text.text.isNotEmpty) {
            final lastChar = text.text[text.text.length - 1];
            if (Letters.uyirLetters.contains(lastChar)) {
                return;
            }
        }

        _insertText(value);
        _ref?.read(sessionStateProvider.notifier).typeChar(value);
    }

    void _insertText(String value) {
        final selection = text.selection;
        final textValue = text.text;

        // Replace selection (if any) with value, or insert at caret
        final start = selection.start;
        final end = selection.end;
        final newText = textValue.replaceRange(start, end, value);

        final newOffset = start + value.length;
        text.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newOffset),
        );
    }
}
