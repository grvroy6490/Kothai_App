
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visai/features/splash/splash_page.dart';
import 'package:visai/features/typing_session/presentation/pages/practice/practice_page.dart';

class MobileLayout extends StatefulWidget {
    const MobileLayout({super.key});

    @override
    State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
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

