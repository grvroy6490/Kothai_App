import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/providers/navigation/navigation_provider.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/session/stop/session_stop_page.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';

class BottomNavigationBarWidget extends ConsumerWidget {
    final TextEditingController? controller;
    const BottomNavigationBarWidget({super.key, this.controller});

    @override
    Widget build(BuildContext context, ref) {
        // 🌐 PROVIDERS ------------------------------
        final navNotifier = ref.read(selectNavProvider.notifier);
        final idx = ref.watch(selectNavProvider); // 👈 NAVIGATION PROVIDER WATCH
        final sessionState = ref.watch(sessionStatusControllerProvider);
        final sessionStatus = sessionState.status == SessionStatusEnum.start;

        // 📃 DECLARATION ----------------------------
        final currentIndex = (idx >= 0 && idx < 4) ? idx : 0;

        // ⭐ Widget --------------------------------------
        return BottomNavigationBar(
            iconSize: KxScale(context).sp(20),
            enableFeedback: false,
            currentIndex: currentIndex,
            onTap: (index) async {
                final intendedRoute = navNotifier.routeFor(index);

                // If a session is running and user is changing tabs (any index),
                // show the stop dialog and keep the current selection unchanged.
                final isChangingTab = index != currentIndex;
                if (sessionStatus && isChangingTab) {
                    final result = await Get.to(
                        () => const SessionStopPage(),
                        arguments: {
                            'route': intendedRoute,
                            'index': index,
                        },
                        transition: Transition.fadeIn,
                        curve: Curves.easeInOutQuad,
                    );
                    final confirmed = (result is Map && result['confirmed'] == true);
                    if (!confirmed) return;
                    // proceed after confirmation
                    navNotifier.set(index);
                    if (Get.currentRoute != intendedRoute) {
                        Get.offNamed(intendedRoute);
                    }
                    return;
                }

                // Otherwise, proceed: update selection and navigate if route differs.
                navNotifier.set(index);
                if (Get.currentRoute != intendedRoute) {
                    Get.offNamed(intendedRoute);
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
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.solidKeyboard, size: KxScale(context).sp(18)), label: 'Practice'),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.trophy, size: KxScale(context).sp(17)), label: 'Challenge'),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.circleUser, size: KxScale(context).sp(18)), label: 'Profile'),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.grip, size: KxScale(context).sp(18)), label: 'Coming Soon')
            ]
        );
    }
}
