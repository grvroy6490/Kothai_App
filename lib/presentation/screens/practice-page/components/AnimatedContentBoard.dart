
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/enums/PracticeStatusEnum.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/TypingArea.dart';
import 'package:kothai_app/presentation/providers/practice/practice_status_provider.dart';

class AnimatedContentBoard extends ConsumerStatefulWidget {
    String paragraph;
    String userInput;

    AnimatedContentBoard({
        super.key,
        required this.paragraph,
        required this.userInput
    });

    @override
    ConsumerState<AnimatedContentBoard> createState() => _AnimatedContentBoardState();
}

class _AnimatedContentBoardState extends ConsumerState<AnimatedContentBoard> {
    @override
    Widget build(BuildContext context) {
        final practiseStatus = ref.watch(practiceStatusProvider);
        return AnimatedSize(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: SizedBox(
                height: practiseStatus == PracticeStatus.start ? MediaQuery.of(context).size.height * 0.35 : MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                // decoration: BoxDecoration(color: Colors.white24),
                child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 8),
                    physics: const BouncingScrollPhysics(),
                    child: TypingArea(paragraph: widget.paragraph, input: widget.userInput),
                ),
            ),
        );
    }
}
