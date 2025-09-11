

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/presentation/providers/session/session_state_provider.dart';
import 'package:vibration/vibration.dart';

class TypingArea extends ConsumerStatefulWidget {
    final String paragraph;
    final String input;

    const TypingArea({super.key, required this.paragraph, required this.input});

    @override
    ConsumerState<TypingArea> createState() => _TypingAreaState();
}

class _TypingAreaState extends ConsumerState<TypingArea> {
    @override
    Widget build(BuildContext context) {

        ref.listen<int>(
            sessionStateProvider.select((s) => s.errors),
            (prev, next) async {
                if (prev != null && next > prev) {
                    if (await (Vibration.hasVibrator() ?? Future.value(false))) {
                        Vibration.vibrate(duration: 200);
                    }
                }
            },
        );

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
