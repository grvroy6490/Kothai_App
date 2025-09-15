
import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class AnimatedContentBoard extends StatefulWidget {
    String paragraph;
    String userInput;
    AnimatedContentBoard({
        super.key, 
        required this.paragraph,
        required this.userInput
    });

    @override
    State<AnimatedContentBoard> createState() => _AnimatedContentBoardState();
}

class _AnimatedContentBoardState extends State<AnimatedContentBoard> {
    @override
    Widget build(BuildContext context) {
        return AnimatedSize(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height, // TODO: Animate size here
                // decoration: BoxDecoration(color: Colors.white24),
                child: TypingArea(
                    paragraph: widget.paragraph,
                    userInput: widget.userInput
                ) // Typing Area
            )
        );
    }
}





class TypingArea extends StatefulWidget {
    String paragraph;
    String userInput;
    TypingArea({super.key, required this.paragraph, required this.userInput});

    @override
    State<TypingArea> createState() => _TypingAreaState();
}

class _TypingAreaState extends State<TypingArea> {   

    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: Gap(context).gap(8)),
            physics: const BouncingScrollPhysics(),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(14)),
                child:  RichText(
                    key: ValueKey(widget.paragraph),
                    text: TextSpan(
                        children: _buildTextSpans(widget.paragraph, widget.userInput),
                        style: TextStyle(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                            fontSize: KxScale(context).sp(20),
                            height: 1.5,
                            fontFamily: 'NotoSansTamil'
                        )
                    )
                )
            )
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
                    style: TextStyle(color: textColor)
                );
            });
    }
}
