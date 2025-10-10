import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/challenge/challenge_tracking_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/bend_line_painter.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/weekly_streak_display.dart';

class ChallengeStartButton extends ConsumerStatefulWidget {
    final void Function() handleStart;
    final int currentIndex;

    const ChallengeStartButton({
        super.key,
        required this.handleStart,
        this.currentIndex = 0
    });

    @override
    ConsumerState<ChallengeStartButton> createState() => _State();
}

class _State extends ConsumerState<ChallengeStartButton>
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
            getFigmaColor(context, 'Schemes/On Green Container'),
            getFigmaColor(context, 'Schemes/Green')
        ],
        [
            getFigmaColor(context, 'Extended Colors/Blue'),
            getFigmaColor(context, 'Extended Colors/Blue Container')
        ],
        [
            getFigmaColor(context, 'Schemes/Tertiary'),
            getFigmaColor(context, 'Schemes/Tertiary Container')
        ]
    ];

    @override
    void initState() {
        super.initState();
        _timerController = AnimationController(
            duration: const Duration(seconds: 1),
            vsync: this
        );
        _startTimer();
    }

    @override
    void dispose() {
        _timer?.cancel();
        _timerController.dispose();
        _remainingTimeNotifier.dispose();
        super.dispose();
    }

    void _startTimer() {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (mounted) {
                    // Calculate remaining time without calling setState
                    final hiddenChallenges = ref.read(hiddenChallengesSyncProvider);
                    final completionTimestamps = ref.read(
                        challengeCompletionTimestampsSyncProvider
                    );

                    // Determine if current challenge is blocked
                    DifficultyEnum currentDifficulty;
                    switch (widget.currentIndex) {
                        case 0:
                            currentDifficulty = DifficultyEnum.easy;
                            break;
                        case 1:
                            currentDifficulty = DifficultyEnum.medium;
                            break;
                        case 2:
                            currentDifficulty = DifficultyEnum.hard;
                            break;
                        default:
                        currentDifficulty = DifficultyEnum.easy;
                    }

                    final isCurrentChallengeBlocked = hiddenChallenges.contains(
                        currentDifficulty
                    );

                    Duration? remainingTime;
                    if (isCurrentChallengeBlocked) {
                        final completionTime = completionTimestamps[currentDifficulty];
                        if (completionTime != null) {
                            final now = DateTime.now();
                            final timeSinceCompletion = now.difference(completionTime);
                            final totalRemainingTime =
                                Duration(hours: 24) - timeSinceCompletion;

                            if (totalRemainingTime.isNegative) {
                                remainingTime = null;
                            } else {
                                remainingTime = totalRemainingTime;
                            }
                        }
                    }

                    // Update the ValueNotifier instead of calling setState
                    _remainingTimeNotifier.value = remainingTime;
                }
            });
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
        final hiddenChallenges = ref.watch(hiddenChallengesSyncProvider);
        final completionTimestamps = ref.watch(
            challengeCompletionTimestampsSyncProvider
        );

        // Determine if current challenge is blocked
        DifficultyEnum currentDifficulty;
        switch (widget.currentIndex) {
            case 0:
                currentDifficulty = DifficultyEnum.easy;
                break;
            case 1:
                currentDifficulty = DifficultyEnum.medium;
                break;
            case 2:
                currentDifficulty = DifficultyEnum.hard;
                break;
            default:
            currentDifficulty = DifficultyEnum.easy;
        }

        final isCurrentChallengeBlocked = hiddenChallenges.contains(
            currentDifficulty
        );

        // Initialize the remaining time notifier on first build
        if (isCurrentChallengeBlocked) {
            final completionTime = completionTimestamps[currentDifficulty];
            if (completionTime != null) {
                final now = DateTime.now();
                final timeSinceCompletion = now.difference(completionTime);
                final totalRemainingTime = Duration(hours: 24) - timeSinceCompletion;

                if (totalRemainingTime.isNegative) {
                    _remainingTimeNotifier.value = null;
                } else {
                    _remainingTimeNotifier.value = totalRemainingTime;
                }
            }
        } else {
            _remainingTimeNotifier.value = null;
        }

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
                                opacity: widget.currentIndex == 1 ? 1 : 0.2,
                                child: CustomPaint(
                                    size: const Size(250 / 4, 20),
                                    painter: BendLinePainter(
                                        color: getFigmaColor(context, 'Extended Colors/Blue')
                                    )
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
                                        painter: BendLinePainter(
                                            color: getFigmaColor(
                                                context,
                                                'Schemes/On Green Container'
                                            )
                                        )
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
                                        painter: BendLinePainter(
                                            color: getFigmaColor(context, 'Schemes/Tertiary')
                                        )
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
                                                            child: Image.asset(
                                                                isCurrentChallengeBlocked
                                                                    ? 'assets/images/remaining_watch_light.png'
                                                                    : images[widget.currentIndex],
                                                                width: 60
                                                            )
                                                        ),
                                                        SizedBox(height: Gap(context).gap(3)),

                                                        isCurrentChallengeBlocked
                                                            ?
                                                            // BLOCKED TYPO
                                                            ValueListenableBuilder<Duration?>(
                                                                valueListenable: _remainingTimeNotifier,
                                                                builder: (context, remainingTime, child) {
                                                                    return Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                            Text(
                                                                                '${remainingTime?.inHours ?? 0}h remaining',
                                                                                style: Theme.of(context)
                                                                                    .textTheme
                                                                                    .headlineSmall
                                                                                    ?.copyWith(
                                                                                        color: getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/Secondary'
                                                                                        ),
                                                                                        fontWeight: FontWeight.w600
                                                                                    )
                                                                            ),
                                                                            if (remainingTime != null)
                                                                            Text(
                                                                                'Challenge resets in ${_formatDuration(remainingTime)}',
                                                                                style: Theme.of(context)
                                                                                    .textTheme
                                                                                    .labelLarge
                                                                                    ?.copyWith(
                                                                                        color: getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/On Background'
                                                                                        ),
                                                                                        fontWeight: FontWeight.w400
                                                                                    )
                                                                            )
                                                                        ]
                                                                    );
                                                                }
                                                            )
                                                            : ShaderMask(
                                                                shaderCallback: (bounds) => LinearGradient(
                                                                    begin: Alignment.topCenter,
                                                                    end: Alignment.bottomCenter,
                                                                    colors: typoColor[widget.currentIndex]
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
