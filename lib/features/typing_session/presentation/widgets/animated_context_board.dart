import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:characters/characters.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;



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
        // 🌐 PROVIDERS ------------------------------
        final sessionStatus = ref.watch(sessionStatusControllerProvider);
        final userInput = ref.watch(userInputProvider);

        // 📃 DECLARATION ----------------------------
        final isPracticeStart = sessionStatus.status == SessionStatusEnum.start;

        // ⭐ Widget ---------------------------------
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

        // 🌐 PROVIDERS ------------------------------
        final practiceConfig = ref.watch(practiceConfigurationProvider);

        // 🚀 METHODS --------------------------------
        // TODO: handle type haptic / vibration based on parctice config
        if(practiceConfig.hapticOnError) {
                ref.listen<int>(metricsStateControllerProvider.select((s) => s.errors),
                    (prev, next) async {
                        if (prev != null && next > prev) {
                            if (await (Vibration.hasVibrator() ?? Future.value(false))) {
                                Vibration.vibrate(duration: 200);
                            }
                        }
                    }
                );
        }

        // ⭐ Widget ---------------------------------
        return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: Gap(context).gap(8)),
            physics: const BouncingScrollPhysics(),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(14)),
                child:  RichText(
                    key: ValueKey(widget.paragraph),
                    text: TextSpan(
                        children: _buildTextSpans(widget.paragraph, widget.userInput, practiceConfig), // TODO: Pass Practice config here
                        style: TextStyle(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                            fontSize: KxScale(context).sp(practiceConfig.contentFontSize.value), // 👈 CONTENT FONT SIZE SETTINGS // TODO: add practice config text font size
                            height: 1.5,
                            fontFamily: 'NotoSansTamil'
                        )
                    )
                )
            )
        );
    }

    List<TextSpan> _buildTextSpans(
        String paragraph,
        String input,
        PracticeConfig practiceConfig
    ) {
        // Normalize both to NFC form
        final normalizedPara = unorm.nfc(paragraph);
        final normalizedInput = unorm.nfc(input);

        final paraClusters = normalizedPara.characters.toList();
        final inputClusters = normalizedInput.characters.toList();

        final spans = <TextSpan>[];
        int inputIndex = 0;

        for (int i = 0; i < paraClusters.length; i++) {
            final paraChar = paraClusters[i];
            final typed = (inputIndex < inputClusters.length) ? inputClusters[inputIndex] : null;

            final isCorrect = typed != null && typed == paraChar;

            final textColor = typed == null
                ? Colors.grey.shade400
                :  practiceConfig.blindMode
                    ? Colors.grey.shade600
                    : isCorrect
                        ? Colors.green
                        : Colors.red;

            spans.add(TextSpan(
                    text: paraChar,
                    style: TextStyle(color: textColor)
                ));

            inputIndex++;
        }

        return spans;
    }
}
