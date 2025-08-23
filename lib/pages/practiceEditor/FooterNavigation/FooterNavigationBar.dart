import 'package:flutter/material.dart';
import 'package:kothai_app/provider/StartStopPracticeModel.dart';
import 'package:provider/provider.dart';
import 'package:kothai_app/pages/practiceEditor/FooterNavigation/FooterNav.dart';
import 'package:kothai_app/pages/practiceEditor/FooterNavigation/PracticeSettingsWidget.dart';
import 'package:kothai_app/theme/figma_color.dart';
import 'package:kothai_app/theme/theme_manager.dart';

class FooterNavigationBar extends StatefulWidget {
    const FooterNavigationBar({super.key});

    @override
    State<FooterNavigationBar> createState() => _FooterNavigationBarState();
}

class _FooterNavigationBarState extends State<FooterNavigationBar> with TickerProviderStateMixin {
    late AnimationController _fadeController;
    late AnimationController _slideController;

    late Animation<double> _fadeAnimation;
    late Animation<Offset> _slideAnimation;

    bool _isVisible = true;

    @override
    void initState() {
        super.initState();

        _fadeController = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 600),
        );

        _slideController = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 600),
        );

        _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
        );

        _slideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)).animate(
            CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );
    }

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        final isRunning = Provider.of<StartStopPracticeModel>(context).isPracticeRunning;
        if (isRunning && !_fadeController.isCompleted) {
            _triggerAnimations();
        } else if (!isRunning && _fadeController.isCompleted) {
            _fadeController.reverse();
            _slideController.reverse();
            setState(() {
                    _isVisible = true;
                });
        }
    }

    Future<void> _triggerAnimations() async {
        await _fadeController.forward();
        await _slideController.forward();
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
                _isVisible = false;
            });
    }

    @override
    void dispose() {
        _fadeController.dispose();
        _slideController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            bottom: _isVisible ? 0 : -MediaQuery.of(context).size.height,
            left: 0,
            right: 0,
            child: Stack(
                clipBehavior: Clip.none,
                children: [
                    Positioned(
                        top: -MediaQuery.of(context).size.height * 0.1 - 3,
                        left: 0,
                        right: 0,
                        child: Align(
                            alignment: Alignment.center,
                            child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 220, 195, 122),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(150),
                                            topRight: Radius.circular(150),
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                    Positioned(
                        top: -MediaQuery.of(context).size.height * 0.1,
                        left: 0,
                        right: 0,
                        child: Align(
                            alignment: Alignment.center,
                            child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: BoxDecoration(
                                        color: getFigmaColor(context, 'Schemes/Surface Container'),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(150),
                                            topRight: Radius.circular(150),
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                    SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                const SizedBox(height: 100),
                                Container(
                                    width: double.infinity,
                                    constraints: const BoxConstraints(minHeight: 100),
                                    decoration: BoxDecoration(
                                        color: getFigmaColor(context, 'Schemes/Background'),
                                    ),
                                    child: FooterNav(context),
                                ),
                            ],
                        ),
                    ),
                    Positioned(
                        top: -MediaQuery.of(context).size.height * 0.4 + 30,
                        left: 0,
                        right: 0,
                        child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                width: double.infinity,
                                constraints: BoxConstraints(
                                    minHeight: MediaQuery.of(context).size.height * 0.5,
                                ),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                            getFigmaColor(context, 'Schemes/Surface Container').withAlpha(0),
                                            getFigmaColor(context, 'Schemes/Surface Container'),
                                        ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        GestureDetector(
                                            onTap: () => {
                                                context.read<StartStopPracticeModel>().startPractice(),
                                            },
                                            child: Column(
                                                children: [
                                                    Image.asset('assets/images/start_icon_purple.png', width: 60),
                                                    const SizedBox(height: 10),
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
                                        const SizedBox(height: 10),
                                        const PracticeSettingsWidget()
                                    ],
                                ),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
