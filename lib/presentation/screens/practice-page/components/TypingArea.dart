

import 'package:flutter/material.dart';

class TypingArea extends StatefulWidget {
    final String paragraph;
    final String input;

    const TypingArea({super.key, required this.paragraph, required this.input});

    @override
    State<TypingArea> createState() => _TypingAreaState();
}

class _TypingAreaState extends State<TypingArea> {
    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16
            ),
            child: RichText(
                key: ValueKey(widget.paragraph),
                text: TextSpan(
                    children: _buildTextSpans(widget.paragraph, widget.input),
                    style: const TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        fontFamily: 'NotoSansTamil'
                    ),
                ),
            ),
        );
    }

    List<TextSpan> _buildTextSpans(String paragraph, String input) {
        return List.generate(paragraph.length, (i) {
                final actualChar = paragraph[i];
                final typedChar = (i < input.length) ? input[i] : null;

                bool isCorrect = typedChar != null && typedChar == actualChar;
                Color textColor = typedChar == null
                    ? Colors.grey.shade400
                    : isCorrect
                        ? Colors.green
                        : Colors.red;

                return TextSpan(
                    text: actualChar,
                    style: TextStyle(color: textColor),
                );
            });
    }

}
