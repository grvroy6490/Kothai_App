
import 'package:flutter/material.dart';

class TypingEngine {
    final String paragraph;
    final TextEditingController controller;
    final VoidCallback onUpdate;


    String userInput = '';
    String? lastTypedLetter;


    TypingEngine({
        required this.paragraph,
        required this.controller,
        required this.onUpdate,
    });


    void handleKeyPress(String data, TextSelection selection,
        {String? heldChar}) {
        if (!selection.isValid) return;


        if (lastTypedLetter == null &&
            (data == 'space' || data == 'delete')) return;


        if (data == 'space') return handleSpace(selection);
        if (data == 'delete') return handleDelete(selection);
        if (data == 'enter') return handleEnter(selection);


        String toInsert = heldChar != null ? data + heldChar : data;


        final newText = controller.text.replaceRange(
            selection.start, selection.end, toInsert);
        final newInput = userInput.replaceRange(
            selection.start, selection.end, toInsert);


        controller.text = newText;
        controller.selection =
            TextSelection.collapsed(offset: selection.start + toInsert.length);
        userInput = newInput;
        lastTypedLetter = data;


        onUpdate();
    }


    void handleSpace(TextSelection selection) {
        final newText = controller.text.replaceRange(
            selection.start, selection.end, ' ');
        final newInput = userInput.replaceRange(
            selection.start, selection.end, ' ');


        controller.text = newText;
        controller.selection =
            TextSelection.collapsed(offset: selection.start + 1);
        userInput = newInput;
        lastTypedLetter = ' ';
        onUpdate();
    }


    void handleDelete(TextSelection selection) {
        String text = controller.text;
        if (selection.start != selection.end) {
            controller.text =
                text.replaceRange(selection.start, selection.end, '');
            userInput =
                userInput.replaceRange(selection.start, selection.end, '');
            controller.selection =
                TextSelection.collapsed(offset: selection.start);
        } else if (selection.start > 0) {
            controller.text =
                text.replaceRange(selection.start - 1, selection.start, '');
            userInput = userInput.replaceRange(
                selection.start - 1, selection.start, '');
            controller.selection =
                TextSelection.collapsed(offset: selection.start - 1);
        }
        lastTypedLetter =
        (controller.text.isNotEmpty && controller.selection.start > 0)
            ? controller.text[controller.selection.start - 1]
            : null;
        onUpdate();
    }


    void handleEnter(TextSelection selection) {
        final newText = controller.text.replaceRange(
            selection.start, selection.end, '\n');
        final newInput = userInput.replaceRange(
            selection.start, selection.end, '\n');
    }
}