import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/enums/difficulty/DifficultyEnum.dart';
import 'package:visai/enums/PracticeStatusEnum.dart';
import 'package:visai/presentation/providers/content/text_provider.dart';
import 'package:visai/presentation/providers/facades/practice_facade.dart';
import 'package:visai/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:visai/presentation/providers/practice/practice_status_provider.dart';
import 'package:visai/presentation/providers/practice/practice_configuration_provider.dart';
import 'package:visai/presentation/providers/session/difficulty_provider.dart';
import 'package:visai/presentation/providers/session/session_state_provider.dart';
import 'package:visai/presentation/providers/session/typing_session_provider.dart';
import 'package:visai/presentation/screens/practice-page/components/PracticeSettingsWidgets.dart';
import 'package:visai/presentation/theme/app_typography.dart';
import 'package:visai/presentation/theme/figma_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeStartWidget extends ConsumerStatefulWidget {
    final Animation<double> fadeAnimation;
    const PracticeStartWidget({super.key, required this.fadeAnimation});

    @override
    ConsumerState<PracticeStartWidget> createState() =>
    _PracticeStartWidgetState();
}

class _PracticeStartWidgetState extends ConsumerState<PracticeStartWidget> {

    @override
    Widget build(BuildContext context) {
        final practiseStatus = ref.watch(practiceStatusProvider);

        void handlePracticeStart() async{

            final currentContent = ref.read(textContentProvider);
            final currentlySelectedDifficulty = ref.read(difficultyNotifierProvider);

            if(currentContent != null){
                ref.read(practiceFacadeProvider.notifier).startSession(target: currentContent.content, difficulty: currentlySelectedDifficulty);
            }

            // Start a new practice session
            ref.read(practiceStatusProvider.notifier).startPractice();
            ref.read(keyboardProvider.notifier).showKeyboard();

        }

        return AnimatedContainer(
            duration: Duration(milliseconds: 600),
            transform: practiseStatus == PracticeStatus.start
                ? Matrix4.translationValues(0, MediaQuery.of(context).size.height, 0)
                : Matrix4.translationValues(0, 0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.transparent,
            ),
            clipBehavior: Clip.hardEdge,

            child: FadeTransition(
                opacity: widget.fadeAnimation,
                child: Stack(
                    children: [
                        // BACKGROUND HALF CIRCLE BUTTON BG
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                            getFigmaColor(
                                                context,
                                                'Schemes/Surface Container Lowest',
                                            ),
                                            getFigmaColor(
                                                context,
                                                'Schemes/Surface Container',
                                            ).withAlpha(0),
                                        ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(150),
                                        topRight: Radius.circular(150),
                                    ),
                                    border: const Border(
                                        top: BorderSide(
                                            color: Color.fromARGB(255, 220, 195, 122),
                                            width: 3,
                                        ),
                                    ),
                                ),
                            ),
                        ),

                        // PRACTICE START BUTTON BLOCK
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                GestureDetector(
                                    onTap: () {
                                        handlePracticeStart();
                                    },
                                    child: Column(
                                        children: [
                                            Image.asset(
                                                'assets/images/start_icon_purple.png',
                                                width: 60,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                                'Start Practice',
                                                style: AppTypography.headlineSmall.copyWith(
                                                    color: getFigmaColor(context, 'Schemes/Primary'),
                                                    fontWeight: FontWeight.w600,
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                                PracticeSettingsWidget(),
                            ],
                        ),
                    ],
                ),
            ),
        );
    }
}
