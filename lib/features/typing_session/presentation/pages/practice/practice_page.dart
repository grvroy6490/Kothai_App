
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/poviders/navigation_provider.dart';
import 'package:kothai_app/features/typing_session/domain/enums/practice_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/practice_editor_page.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';
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
        final idx = ref.watch(selectNavProvider); // 👈 NAVIGATION PROVIDER WATCH
        final nav = ref.read(selectNavProvider.notifier); // 👈 NAVIGATION PROVIDER READ

        final controller = _controller;
        final focusNode = _focusNode;

        final keyboardController = ref.watch(keyboardControllerProvider(controller)); // 👈 KEYBOARD CONTROLLER PROVIDER

        final currentIndex = (idx >= 0 && idx < 4) ? idx : 0;

        void showNotifications(){

        }

        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            appBar: AppBar(
                backgroundColor: getFigmaColor(context, 'Schemes/Background'),
                automaticallyImplyLeading: false,
                title: Text('Practice', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    )
                ),
                actions: appBarActions(
                    context,
                    practiceStatus != PracticeStatusEnum.start,
                    showNotifications
                ) // 👈 PRACTICE APP BAR ACTIONS
            ),
            bottomNavigationBar: BottomNavigationBar(
                iconSize: 20,
                enableFeedback: false,
                currentIndex: 0,
                onTap: (index) {
                    nav.set(index);
                    final route = nav.currentRoute;
                    if (Get.currentRoute != route) {
                        Get.offNamed(route);
                    }
                },
                selectedLabelStyle: null,
                unselectedLabelStyle: null,
                type: BottomNavigationBarType.fixed,
                backgroundColor: getFigmaColor(context, 'Schemes/Surface'),
                selectedItemColor: getFigmaColor(context, 'Schemes/Primary'),
                unselectedItemColor: getFigmaColor(
                    context,
                    'Schemes/On Background'
                ).withAlpha(153),
                items: [
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.solidKeyboard), label: 'Practice'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.trophy), label: 'Challenge'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.circleUser), label: 'Profile'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.grip), label: 'More')
                ]
            ),
            body: SizedBox(
                height: double.infinity,
                width: double.infinity,

                child: Stack(
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
                                        PracticeResetPause(),
                                        Container(
                                            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(16)),
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
