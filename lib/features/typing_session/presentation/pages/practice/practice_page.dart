import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/domain/entities/gamification/gamification_entity.dart';
import 'package:visai/features/keyboard/presentation/keyboard.dart';
import 'package:visai/features/keyboard/presentation/providers/keyboard_provider.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/pages/practice/pause/practice_pause_page.dart';
import 'package:visai/features/typing_session/presentation/pages/practice/practice_editor_page.dart';
import 'package:visai/features/typing_session/presentation/pages/session/reset/session_reset_page.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/bottom_navigation_bar.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/appbar_actions.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/practice_reset_pause.dart';

class PracticePage extends ConsumerStatefulWidget {
    const PracticePage({super.key});

    @override
    ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
    final TextEditingController _controller = TextEditingController();
    final FocusNode _focusNode = FocusNode();
    late GamificationEntity? gamificationData;

    @override
    void initState() {
        super.initState();
    }

    @override
    void dispose() {
        _controller.dispose();
        _focusNode.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        // 📃 DECLARATION ----------------------------
        final controller = _controller;
        final focusNode = _focusNode;
        final sessionStatusController = ref.watch(sessionStatusControllerProvider);
        final sessionEngineController = ref.read(
            sessionControllerProvider.notifier
        );
        final practiceStatus = sessionStatusController.mode == SessionMode.practice
            ? sessionStatusController.status
            : false;

        // 🌐 PROVIDERS ------------------------------
        final keyboardRenderer = ref.watch(
            keyboardRendererProvider
        ); // 👈 KEYBOARD RENDERER
        final isKeyboardVisible = ref.watch(
            keyboardStatusProvider
        ); // 👈 KEYBOARD STATUS PROVIDER
        final keyboardController = ref.watch(
            keyboardControllerProvider(controller)
        );
        gamificationData = ref.watch(gamificationDataControllerProvider);


        // 🚀 METHODS ---------------------------------

        void handlePracticePause(TextEditingController controller) {
            sessionEngineController.pause();
            Get.to(
                () => PracticePausePage(controller: controller),
                transition: Transition.fadeIn,
                curve: Curves.easeInOutQuad
            );
        }

        void handlePracticeReset(TextEditingController controller) {
            Get.to(
                () => SessionResetPage(controller: controller),
                arguments: kReset,
                transition: Transition.fadeIn,
                curve: Curves.easeInOutQuad
            );
        }

        // ⭐ Widget --------------------------------------
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
            appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
                automaticallyImplyLeading: false,
                title: Text(
                    'Practice',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    )
                ),
                actions: appBarActions(
                    context,
                    practiceStatus != SessionStatusEnum.start,
                    controller
                ) // 👈 PRACTICE APP BAR ACTIONS
            ),
            bottomNavigationBar: BottomNavigationBarWidget(),
            body: SizedBox(
                height: double.infinity,
                width: double.infinity,

                child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                        PracticeEditorPage(
                            controller: controller,
                            focusNode: focusNode,
                            gamificationData: gamificationData
                        ), // 👈 EDITOR PAGE

                        AnimatedSlide(
                            // 👈 KEYBOARD DRAWER
                            offset: isKeyboardVisible ? Offset.zero : const Offset(0, 1),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutQuad,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        PracticeResetPause(
                                            handlePause: handlePracticePause,
                                            handleReset: handlePracticeReset,
                                            controller: controller
                                        ),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Gap(context).gap(8),
                                                vertical: Gap(context).gap(10)
                                            ),
                                            width: double.infinity,
                                            color: getFigmaColor(
                                                context,
                                                'Schemes/Surface Container'
                                            ),
                                            child: Keyboard(
                                                controller: keyboardController,
                                                renderer: keyboardRenderer
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    ]
                )
            )
        );
    }
}
