
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:kothai_app/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/metrics/metrics_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practise_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/user_input/user_input_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/sessions/session_state/session_state_provider.dart';
import 'package:vibration/vibration.dart';

class AnimatedContentBoard extends ConsumerStatefulWidget {
    String paragraph;
    AnimatedContentBoard({
        super.key, 
        required this.paragraph
    });

    @override
    ConsumerState<AnimatedContentBoard> createState() => _AnimatedContentBoardState();
}

class _AnimatedContentBoardState extends ConsumerState<AnimatedContentBoard> {

    @override
    Widget build(BuildContext context) {
        final practiceStatus = ref.watch(practiceStatusProvider);
        final isPracticeStart = practiceStatus == PracticeStatusEnum.start;
        final userInput = ref.watch(userInputProvider);

        return AnimatedSize(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: SizedBox(
                width: double.infinity,
                height: isPracticeStart
                    ? MediaQuery.of(context).size.height * 0.35
                    : MediaQuery.of(context).size.height, // 👈 Update height animation here
                // decoration: BoxDecoration(color: Colors.white24),
                child: TypingArea(
                    paragraph: widget.paragraph,
                    userInput: userInput
                ) // Typing Area
            )
        );
    }
}





class TypingArea extends ConsumerStatefulWidget {
    String paragraph;
    String userInput;
    TypingArea({super.key, required this.paragraph, required this.userInput});

    @override
    ConsumerState<TypingArea> createState() => _TypingAreaState();
}

class _TypingAreaState extends ConsumerState<TypingArea> {

    @override
    Widget build(BuildContext context) {
        final practiceConfig = ref.watch(practiceConfigurationProvider);

        if(practiceConfig.hapticOnError) {
            ref.listen<int>(metricsNotifierProvider.select((s) => s.errors),
                (prev, next) async {
                    if (prev != null && next > prev) {
                        if (await (Vibration.hasVibrator() ?? Future.value(false))) {
                            Vibration.vibrate(duration: 200);
                        }
                    }
                }
            );
        }

        return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: Gap(context).gap(8)),
            physics: const BouncingScrollPhysics(),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(14)),
                child:  RichText(
                    key: ValueKey(widget.paragraph),
                    text: TextSpan(
                        children: _buildTextSpans(widget.paragraph, widget.userInput, practiceConfig),
                        style: TextStyle(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                            fontSize: KxScale(context).sp(practiceConfig.contentFontSize.value), // 👈 CONTENT FONT SIZE SETTINGS
                            height: 1.5,
                            fontFamily: 'NotoSansTamil'
                        )
                    )
                )
            )
        );
    }

    List<TextSpan> _buildTextSpans(String paragraph, String input, PracticeConfig practiceConfig) {

        return List.generate(paragraph.length, (i) {
                final actualChar = paragraph[i];
                final typedChar = (i < input.length) ? input[i] : null;

                bool isCorrect = typedChar != null && typedChar == actualChar;

                Color textColor = typedChar == null
                    ? Colors.grey.shade400
                    : practiceConfig.blindMode ? Colors.grey.shade600 // 👈 BLIND MODE SETTINGS
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
