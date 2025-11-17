import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/user_profile/presentation/widgets/streak_badge.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';

class BadgeDisplay extends ConsumerStatefulWidget {
    const BadgeDisplay({super.key});

    @override
    ConsumerState<BadgeDisplay> createState() => _BadgeDisplayState();
}

class _BadgeDisplayState extends ConsumerState<BadgeDisplay> {
    @override
    Widget build(BuildContext context) {
        final streak = ref.watch(streakControllerProvider);

        // Calculate progress to Week Warrior badge (7 days)
        const targetDays = 7;
        final currentDays = streak.current;
        final progress = currentDays >= targetDays ? 1.0 : currentDays / targetDays;
        final percentage = (progress * 100).round();
        final daysRemaining = (targetDays - currentDays).clamp(0, targetDays);

        // Determine message based on progress
        String progressMessage;
        if (currentDays >= targetDays) {
            progressMessage = 'Congratulations! You earned the Week Warrior badge!';
        } else if (daysRemaining == 1) {
            progressMessage = 'Only 1 more day to earn the Week Warrior badge!';
        } else {
            progressMessage =
            'Only $daysRemaining more days to earn the Week Warrior badge!';
        }
        return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                    image: AssetImage('assets/images/streak_board.png'),
                    fit: BoxFit.cover
                )
            ),
            child: Padding(
                padding: EdgeInsets.only(
                    top: Gap(context).gap(40),
                    bottom: Gap(context).gap(10),
                    left: Gap(context).gap(16),
                    right: Gap(context).gap(16)
                ),
                child: Column(
                    children: [
                        Stack(
                            children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Container(width: double.infinity, height: 190)
                                    )
                                ),

                                Container(
                                    width: double.infinity,
                                    // height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            color: getFigmaColor(
                                                context,
                                                'State Layers/Secondary Fixed Dim/Opacity-16'
                                            ),
                                            width: 1
                                        )
                                    ),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: getFigmaColor(
                                                                context,
                                                                'State Layers/Secondary Fixed Dim/Opacity-16'
                                                            ),
                                                            width: 1
                                                        )
                                                    )
                                                ),
                                                child: Column(
                                                    children: [
                                                        Transform.translate(
                                                            offset: Offset(0, Gap(context).gap(-27)),
                                                            child: StreakBadge()
                                                        ),

                                                        Transform.translate(
                                                            offset: Offset(0, Gap(context).gap(-12)),
                                                            child: Text(
                                                                progressMessage,
                                                                style: Theme.of(context).textTheme.bodySmall
                                                                    ?.copyWith(
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Fixed/Secondary Fixed'
                                                                        )
                                                                    )
                                                            )
                                                        )
                                                    ]
                                                )
                                            ),

                                            Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Gap(context).gap(20),
                                                    vertical: Gap(context).gap(5)
                                                ),
                                                child: Row(
                                                    children: [
                                                        Expanded(
                                                            child: Column(
                                                                children: [
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            ShaderMask(
                                                                                shaderCallback: (bounds) =>
                                                                                LinearGradient(
                                                                                    colors: [
                                                                                        Color.fromARGB(
                                                                                            255,
                                                                                            215,
                                                                                            190,
                                                                                            116
                                                                                        ),
                                                                                        Color.fromARGB(
                                                                                            255,
                                                                                            164,
                                                                                            138,
                                                                                            88
                                                                                        )
                                                                                    ]
                                                                                ).createShader(
                                                                                        Rect.fromLTWH(
                                                                                            -2,
                                                                                            -2,
                                                                                            bounds.width + 4,
                                                                                            bounds.height + 4
                                                                                        )
                                                                                    ),
                                                                                blendMode: BlendMode.srcIn,
                                                                                child: Padding(
                                                                                    padding: EdgeInsets.symmetric(
                                                                                        vertical: 2
                                                                                    ),
                                                                                    child: Text(
                                                                                        'Progress to Week Warrior',
                                                                                        style: Theme.of(context)
                                                                                            .textTheme
                                                                                            .bodySmall
                                                                                            ?.copyWith(color: Colors.white)
                                                                                    )
                                                                                )
                                                                            ),

                                                                            ShaderMask(
                                                                                shaderCallback: (bounds) =>
                                                                                LinearGradient(
                                                                                    colors: [
                                                                                        Color.fromARGB(
                                                                                            255,
                                                                                            215,
                                                                                            190,
                                                                                            116
                                                                                        ),
                                                                                        Color.fromARGB(
                                                                                            255,
                                                                                            164,
                                                                                            138,
                                                                                            88
                                                                                        )
                                                                                    ]
                                                                                ).createShader(
                                                                                        Rect.fromLTWH(
                                                                                            -2,
                                                                                            -2,
                                                                                            bounds.width + 4,
                                                                                            bounds.height + 4
                                                                                        )
                                                                                    ),
                                                                                blendMode: BlendMode.srcIn,
                                                                                child: Padding(
                                                                                    padding: EdgeInsets.symmetric(
                                                                                        vertical: 2
                                                                                    ),
                                                                                    child: Text(
                                                                                        '$percentage%',
                                                                                        style: Theme.of(context)
                                                                                            .textTheme
                                                                                            .bodySmall
                                                                                            ?.copyWith(color: Colors.white)
                                                                                    )
                                                                                )
                                                                            )
                                                                        ]
                                                                    ),

                                                                    SizedBox(height: Gap(context).gap(8)),
                                                                    Stack(
                                                                        children: [
                                                                            // Background progress bar
                                                                            Container(
                                                                                width: double.infinity,
                                                                                height: Gap(context).gap(8),
                                                                                decoration: BoxDecoration(
                                                                                    color: getFigmaColor(
                                                                                        context,
                                                                                        'State Layers/Secondary Fixed Dim/Opacity-16'
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(
                                                                                        25
                                                                                    )
                                                                                )
                                                                            ),
                                                                            // Progress fill
                                                                            Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: FractionallySizedBox(
                                                                                    widthFactor: progress.clamp(0.0, 1.0),
                                                                                    child: Container(
                                                                                        height: Gap(context).gap(8),
                                                                                        decoration: BoxDecoration(
                                                                                            gradient: LinearGradient(
                                                                                                begin: Alignment.topLeft,
                                                                                                end: Alignment.bottomRight,
                                                                                                colors: [
                                                                                                    Color.fromARGB(
                                                                                                        255,
                                                                                                        215,
                                                                                                        190,
                                                                                                        116
                                                                                                    ),
                                                                                                    Color.fromARGB(
                                                                                                        255,
                                                                                                        164,
                                                                                                        138,
                                                                                                        88
                                                                                                    )
                                                                                                ]
                                                                                            ),
                                                                                            borderRadius:
                                                                                            BorderRadius.circular(25)
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                        ]
                                                                    ),
                                                                    SizedBox(height: Gap(context).gap(8)),

                                                                    Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            ShaderMask(
                                                                                shaderCallback: (bounds) =>
                                                                                LinearGradient(
                                                                                    colors: [
                                                                                        Color.fromARGB(
                                                                                            255,
                                                                                            215,
                                                                                            190,
                                                                                            116
                                                                                        ),
                                                                                        Color.fromARGB(
                                                                                            255,
                                                                                            164,
                                                                                            138,
                                                                                            88
                                                                                        )
                                                                                    ]
                                                                                ).createShader(
                                                                                        Rect.fromLTWH(
                                                                                            -2,
                                                                                            -2,
                                                                                            bounds.width + 4,
                                                                                            bounds.height + 4
                                                                                        )
                                                                                    ),
                                                                                blendMode: BlendMode.srcIn,
                                                                                child: Padding(
                                                                                    padding: EdgeInsets.symmetric(
                                                                                        vertical: 2
                                                                                    ),
                                                                                    child: Text(
                                                                                        '$currentDays Days',
                                                                                        style: Theme.of(context)
                                                                                            .textTheme
                                                                                            .bodySmall
                                                                                            ?.copyWith(color: Colors.white)
                                                                                    )
                                                                                )
                                                                            ),

                                                                            Text(
                                                                                '$targetDays Days',
                                                                                style: Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodySmall
                                                                                    ?.copyWith(
                                                                                        color: getFigmaColor(
                                                                                            context,
                                                                                            'State Layers/Secondary Fixed/Opacity-16'
                                                                                        )
                                                                                    )
                                                                            )
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                        ),

                                                        Image(
                                                            image: AssetImage(
                                                                'assets/images/Warrior_badge.png'
                                                            ),
                                                            width: 100
                                                        )
                                                    ]
                                                )
                                            )
                                        ]
                                    )
                                )
                            ]
                        ),

                        // SizedBox(height: 8),

                        FilledButton(
                            onPressed: () {
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Color.fromARGB(255, 255, 247, 240)
                                ),
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: Gap(context).gap(15),
                                        vertical: Gap(context).gap(10)
                                    )
                                )
                            ),
                            child: Stack(
                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Text(
                                                'Best: ',
                                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                    color: Color.fromARGB(255, 120, 82, 9)
                                                )
                                            ),

                                            Text(
                                                '${streak.best} Days',
                                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                    color: Color.fromARGB(255, 120, 82, 9),
                                                    fontWeight: FontWeight.bold
                                                )
                                            )
                                        ]
                                    ),

                                    Positioned(
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                                Icons.keyboard_double_arrow_right,
                                                size: 24,
                                                color: Color.fromARGB(255, 120, 82, 9)
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }
}
