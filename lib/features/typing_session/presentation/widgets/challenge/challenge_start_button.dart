import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/bend_line_painter.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/weekly_streak_display.dart';

class ChallengeStartButton extends StatefulWidget {
    void Function() handleStart;
    int currentIndex;

    ChallengeStartButton({
        super.key,
        required this.handleStart,
        this.currentIndex = 0
    });

    @override
    State<ChallengeStartButton> createState() => _State();
}

class _State extends State<ChallengeStartButton> {
    // 📃 DECLARATION ----------------------------
    final images = [
        'assets/images/start_icon_green.png',
        'assets/images/start_icon_blue.png',
        'assets/images/start_icon_pink.png'
    ];

    late final typoColor = [
        [getFigmaColor(context, 'Schemes/On Green Container'), getFigmaColor(context, 'Schemes/Green')],
        [getFigmaColor(context, 'Extended Colors/Blue'), getFigmaColor(context, 'Extended Colors/Blue Container')],
        [getFigmaColor(context, 'Schemes/Tertiary'), getFigmaColor(context, 'Schemes/Tertiary Container')]
    ];

    @override
    Widget build(BuildContext context) {
        // ⭐ Widget ---------------------------------
        return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                        // BACKDROP CONTAINER
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(150),
                                    topRight: Radius.circular(150)
                                ),
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                    child: Container(
                                        width: Gap(context).gap(280),
                                        height: Gap(context).gap(210),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                    getFigmaColor(
                                                        context,
                                                        'Schemes/Surface Container Lowest'
                                                    ),
                                                    getFigmaColor(
                                                        context,
                                                        'Schemes/Surface Container'
                                                    ).withAlpha(100)
                                                ]
                                            ),
                                            borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(150),
                                                topRight: Radius.circular(150)
                                            ),
                                            border: Border(
                                                top: BorderSide(
                                                    color: Color.fromARGB(255, 220, 195, 122),
                                                    width: Gap(context).gap(3)
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        ),

                        Positioned(
                            top: 8,
                            child: AnimatedOpacity(
                                duration: Duration(milliseconds: 400),
                                opacity: widget.currentIndex == 1 ? 1 : 0.2,
                                child: CustomPaint(
                                    size: const Size(250 / 4, 20),
                                    painter: BendLinePainter(color: getFigmaColor(context, 'Extended Colors/Blue'))
                                )
                            )
                        ),

                        Positioned(
                            top: 16,
                            left: 68,
                            child: Transform.rotate(
                                angle: -0.75,
                                alignment: Alignment.centerRight,
                                child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 400),
                                    opacity: widget.currentIndex == 0 ? 1 : 0.2,
                                    child: CustomPaint(
                                        size: const Size(250 / 4, 20),
                                        painter: BendLinePainter(color: getFigmaColor(context, 'Schemes/On Green Container'))
                                    )
                                )
                            )
                        ),

                        Positioned(
                            top: 16,
                            right: 68,
                            child: Transform.rotate(
                                angle: 0.75,
                                alignment: Alignment.centerLeft,
                                child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 400),
                                    opacity: widget.currentIndex == 2 ? 1 : 0.2,
                                    child: CustomPaint(
                                        size: const Size(250 / 4, 20),
                                        painter: BendLinePainter(color: getFigmaColor(context, 'Schemes/Tertiary'))
                                    )
                                )
                            )
                        ),

                        // ICON / START BUTTON
                        Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Consumer(
                                        builder: (context, ref, child) {

                                            return GestureDetector(
                                                onTap: () => widget.handleStart(),
                                                child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                        AnimatedSwitcher(
                                                            duration: const Duration(milliseconds: 500),
                                                            transitionBuilder: (child, animation) {
                                                                // Fade + scale animation
                                                                return ScaleTransition(
                                                                    scale: animation,
                                                                    child: FadeTransition(opacity: animation, child: child)
                                                                );
                                                            },
                                                            child: Image.asset(
                                                                images[widget.currentIndex],
                                                                width: 60
                                                            )
                                                        ),
                                                        SizedBox(height: Gap(context).gap(3)),

                                                        // START TYPO
                                                        ShaderMask(
                                                            shaderCallback: (bounds) => LinearGradient(
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                                colors: typoColor[widget.currentIndex]
                                                            ).createShader(bounds),
                                                            child: Text(
                                                                'Start Challenge',
                                                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                    color: Colors.white, // must be white for gradient to show
                                                                    fontWeight: FontWeight.w600
                                                                )
                                                            )
                                                        )
                                                    ]
                                                )
                                            );
                                        }
                                    ),
                                    // STREAK BADGES
                                    SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                            padding: EdgeInsets.all(Gap(context).gap(14)),
                                            child: WeekilyStreakDisplay()
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            ]
        );
    }
}