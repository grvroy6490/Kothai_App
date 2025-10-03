
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/poviders/navigation_provider.dart';

class BottomNavigationBarWidget extends ConsumerWidget {
    const BottomNavigationBarWidget({super.key});

    @override
    Widget build(BuildContext context, ref) {
        final navNotifier = ref.read(selectNavProvider.notifier);
        final idx = ref.watch(selectNavProvider); // 👈 NAVIGATION PROVIDER WATCH

        final currentIndex = (idx >= 0 && idx < 4) ? idx : 0;

        return BottomNavigationBar(
            iconSize: KxScale(context).sp(20),
            enableFeedback: false,
            currentIndex: idx,
            onTap: (index) {
                navNotifier.set(index);
                final route = navNotifier.currentRoute;
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
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.solidKeyboard, size: KxScale(context).sp(18)), label: 'Practice'),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.trophy, size: KxScale(context).sp(17),), label: 'Challenge'),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.circleUser, size: KxScale(context).sp(18)), label: 'Profile'),
                BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.grip, size: KxScale(context).sp(18)), label: 'Coming Soon')
            ]
        );
    }
}
