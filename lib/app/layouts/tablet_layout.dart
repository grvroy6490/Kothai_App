
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visai/features/splash/splash_page.dart';
import 'package:visai/features/typing_session/presentation/pages/practice/practice_page.dart';

class TabletLayout extends StatefulWidget {
    const TabletLayout({super.key});

    @override
    State<TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
    @override
    void initState() {
        super.initState();
        Future.delayed(const Duration(seconds: 2), () {
                if (!mounted) return;
                Get.off(() => PracticePage(), transition: Transition.fadeIn, curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 500));
            });
    }

    @override
    Widget build(BuildContext context) {
        return const SplashPage();
    }
}

