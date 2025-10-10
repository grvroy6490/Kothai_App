import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:kothai_app/presentation/screens/practice-page/PracticePageWidget.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/PracticeResetPauseSettings.dart';
import 'package:kothai_app/presentation/shared/keyboard/keyboard.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';

class PracticeScreen extends ConsumerStatefulWidget {
    const PracticeScreen({super.key});

    @override
    ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
    final TextEditingController _controller = TextEditingController();
    final FocusNode _focusNode = FocusNode();

    @override
    void dispose() {
        _controller.dispose();
        _focusNode.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final isKeyboardActive = ref.watch(keyboardProvider);
        final controller = _controller;
        final focusNode = _focusNode;

        final keyboardController = ref.watch(
            keyboardControllerProvider(controller),
        );

        final keyboardRenderer = ref.watch(keyboardRendererProvider); //TamilKeyboard


        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: Stack(
                children: [
                    // PRACTICE MAIN SCREEN
                    PracticePage(
                        controller: controller,
                        focusNode: focusNode,
                    ),

                    // KEYBOARD SLIDE-IN
                    AnimatedSlide(
                        offset: isKeyboardActive ? Offset.zero : const Offset(0, 1),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutQuad,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    PracticeResetPauseSettings(),
                                    Container(
                                        constraints: BoxConstraints(
                                            minHeight: 150,
                                        ),
                                        child: Material(
                                            color: getFigmaColor(context, 'Schemes/Surface Container'),
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 30,
                                                    right: 12,
                                                    left: 12,
                                                    top: 12
                                                ),
                                                child: Keyboard(
                                                    controller: keyboardController,
                                                    renderer: keyboardRenderer,
                                                ),
                                            ),
                                        ),
                                    ),
                                ],
                            )
                        ),
                    ),
                ],
            ),
        );
    }
}


