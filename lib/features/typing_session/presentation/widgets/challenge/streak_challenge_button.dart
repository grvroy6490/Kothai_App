import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/providers/challenge/challenge_tracking_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/challenge/bend_line_painter.dart';
import 'package:visai/features/typing_session/presentation/widgets/challenge/weekly_streak_display.dart';

class StreakChallengeButton extends ConsumerStatefulWidget {
    final void Function() handleStart;

    const StreakChallengeButton({
        super.key,
        required this.handleStart
    });

    @override
    ConsumerState<StreakChallengeButton> createState() => _State();
}

class _State extends ConsumerState<StreakChallengeButton>
    with TickerProviderStateMixin {
    late AnimationController _timerController;
    Timer? _timer;
    final ValueNotifier<Duration?> _remainingTimeNotifier =
        ValueNotifier<Duration?>(null);

    // 📃 DECLARATION ----------------------------
    final images = [
        'assets/images/start_icon_green.png',
        'assets/images/start_icon_blue.png',
        'assets/images/start_icon_pink.png'
    ];

    late final typoColor = [
        [
            getFigmaColor(context, 'Schemes/Secondary'),
            getFigmaColor(context, 'Schemes/Secondary Container')
        ],
    ];

    @override
    void initState() {
        super.initState();
    }

    @override
    void dispose() {
        _timer?.cancel();
        _timerController.dispose();
        _remainingTimeNotifier.dispose();
        super.dispose();
    }

    String _formatDuration(Duration duration) {
        String twoDigits(int n) => n.toString().padLeft(2, "0");
        String twoDigitHours = twoDigits(duration.inHours);
        String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
        return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    }

    @override
    Widget build(BuildContext context) {
        // final hiddenChallenges = ref.watch(hiddenChallengesSyncProvider);
        // final completionTimestamps = ref.watch(
        //     challengeCompletionTimestampsSyncProvider
        // );
        //
        // // Determine if current challenge is blocked
        // DifficultyEnum currentDifficulty;
        // switch (widget.currentIndex) {
        //     case 0:
        //         currentDifficulty = DifficultyEnum.easy;
        //         break;
        //     case 1:
        //         currentDifficulty = DifficultyEnum.medium;
        //         break;
        //     case 2:
        //         currentDifficulty = DifficultyEnum.hard;
        //         break;
        //     default:
        //     currentDifficulty = DifficultyEnum.easy;
        // }
        //
        // final isCurrentChallengeBlocked = hiddenChallenges.contains(
        //     currentDifficulty
        // );
        //
        // // Initialize the remaining time notifier on first build
        // if (isCurrentChallengeBlocked) {
        //     final completionTime = completionTimestamps[currentDifficulty];
        //     if (completionTime != null) {
        //         final now = DateTime.now();
        //         final timeSinceCompletion = now.difference(completionTime);
        //         final totalRemainingTime = Duration(hours: 24) - timeSinceCompletion;
        //
        //         if (totalRemainingTime.isNegative) {
        //             _remainingTimeNotifier.value = null;
        //         } else {
        //             _remainingTimeNotifier.value = totalRemainingTime;
        //         }
        //     }
        // } else {
        //     _remainingTimeNotifier.value = null;
        // }

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
                                        height: Gap(context).gap(230),
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
                                opacity: 1,
                                child: CustomPaint(
                                    size: const Size(250 / 4, 20),
                                    painter: BendLinePainter(
                                        color: getFigmaColor(context, 'Schemes/Secondary Container')
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
                                                                    child: FadeTransition(
                                                                        opacity: animation,
                                                                        child: child
                                                                    )
                                                                );
                                                            },
                                                            child: Image.asset("assets/images/remaining_watch_light.png",
                                                                width: 60
                                                            )
                                                        ),
                                                        SizedBox(height: Gap(context).gap(20)),

                                                        ShaderMask(
                                                            shaderCallback: (bounds) => LinearGradient(
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                                colors: typoColor[0]
                                                            ).createShader(bounds),
                                                            child: Text(
                                                                'Start Challenge',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .headlineSmall
                                                                    ?.copyWith(
                                                                        color: Colors.white,
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
