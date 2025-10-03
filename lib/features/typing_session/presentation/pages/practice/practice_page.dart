
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/poviders/navigation_provider.dart';
import 'package:kothai_app/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/pause/practice_pause_page.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/practice_editor_page.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/reset/practice_reset_page.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/sessions/practice/practice_session_controller.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/bottom_navigation_bar_widget.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/keyboard/keyboard.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/appbar_actions.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/practice_reset_pause.dart';

class PracticePage extends ConsumerStatefulWidget {
    const PracticePage({super.key});

    @override
    ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
    final TextEditingController _controller = TextEditingController();
    final FocusNode _focusNode = FocusNode();

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
        final isKeyboardVisible = ref.watch(keyboardStatusProvider); // 👈 KEYBOARD STATUS PROVIDER
        final practiceStatus = ref.watch(practiceStatusProvider); // 👈 PRACTICE STATUS PROVIDER
        final keyboardRenderer = ref.watch(keyboardRendererProvider); // 👈 KEYBOARD RENDERER

        final controller = _controller;
        final focusNode = _focusNode;

        final keyboardController = ref.watch(keyboardControllerProvider(controller)); // 👈 KEYBOARD CONTROLLER PROVIDER


        void showNotifications() async {
          // final records = await ref.read(sessionDaoProvider).list();
          // for (final r in records) {
          //   debugPrint(r.);
          // }
        }

        void handlePracticePause(TextEditingController controller){
            ref.read(practiceSessionControllerProvider.notifier).pause();
            Get.to(() => PracticePausePage(controller: controller), transition: Transition.fadeIn, curve: Curves.easeInOutQuad);
        }

        void handlePracticeReset(TextEditingController controller){
            Get.to(() => PracticeResetPage(controller: controller), arguments: 'fromReset', transition: Transition.fadeIn, curve: Curves.easeInOutQuad);
        }

        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: getFigmaColor(context, 'Schemes/Background'),
                automaticallyImplyLeading: false,
                title: Text('Practice', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    )
                ),
                actions: appBarActions(
                    context,
                    practiceStatus != PracticeStatusEnum.start,
                    showNotifications,
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
                            controller: _controller,
                            focusNode: _focusNode
                        ), // 👈 EDITOR PAGE

                        AnimatedSlide( // 👈 KEYBOARD DRAWER
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
                                            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(8), vertical: Gap(context).gap(10)),
                                            width: double.infinity,
                                            color:  getFigmaColor(context, 'Schemes/Surface Container'),
                                            child: Keyboard(controller: keyboardController, renderer: keyboardRenderer)
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
