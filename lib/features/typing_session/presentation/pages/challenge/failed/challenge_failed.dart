import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/core/utils/time_utils.dart';
import 'package:visai/di/providers/theme/theme_provider.dart';
// import 'package:visai/core/widgets/safe_svg.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
// import 'package:visai/features/typing_session/presentation/widgets/lottie_player.dart';
import 'package:visai/features/typing_session/presentation/widgets/star_burst_badge.dart';
// import 'package:logger/logger.dart';
import 'package:visai/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';

class ChallengeFailed extends ConsumerStatefulWidget {
  const ChallengeFailed({super.key});

  @override
  ConsumerState<ChallengeFailed> createState() => _ChallengeFailedState();
}

class _ChallengeFailedState extends ConsumerState<ChallengeFailed>
    with SingleTickerProviderStateMixin {
  // final _logger = Logger();
  AnimationController? _starburstRotationController;

  // Snapshots captured the moment this page is created.
  // Nothing that happens after navigation (resets, new sessions, timer ticks)
  // can mutate these — they are the definitive end-of-session values.
  late final Duration _finalElapsed;
  late final double _finalWpm;
  late final double _finalAccuracy;

  @override
  void initState() {
    super.initState();
    final metrics = ref.read(metricsStateControllerProvider);
    _finalElapsed  = ref.read(sessionControllerProvider).elapsed;
    _finalWpm      = metrics.wpm;
    _finalAccuracy = metrics.accuracy;

    _starburstRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _starburstRotationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionEngineController = ref.read(
      sessionControllerProvider.notifier,
    );
    final sesstionStatusController = ref.read(
      sessionStatusControllerProvider.notifier,
    );

    final gamification = ref.watch(gamificationDataControllerProvider);
    final selectedDifficulty = ref.watch(challengeDifficultyControllerProvider);
    final criteria = gamification?.difficultyCriteria
        .where(
          (c) =>
              c.type.toLowerCase() == selectedDifficulty.name.toLowerCase(),
        )
        .firstOrNull;
    final difficultyLabel =
        _difficultyLabel(selectedDifficulty);

    final failureMessage = criteria == null
        ? "This challenge wasn’t met. Try again!"
        : _buildChallengeFailureMessage(
            criteria: criteria,
            difficultyLabel: difficultyLabel,
            wpm: _finalWpm,
            accuracy: _finalAccuracy,
            elapsedMs: _finalElapsed.inMilliseconds,
          );

    // Aligned with [_buildChallengeFailureMessage] / session validation: which bar did not pass.
    final bool wpmFailed;
    final bool accFailed;
    final bool timeFailed;
    if (criteria == null) {
      wpmFailed = accFailed = timeFailed = true;
    } else {
      final timeLimitMs = _parseChallengeTimeLimitToMs(criteria.timelimit);
      wpmFailed = _finalWpm < criteria.wpm;
      accFailed = _finalAccuracy * 100.0 < criteria.accuracy;
      timeFailed = _finalElapsed.inMilliseconds > timeLimitMs;
    }

    final themeMode = ref.watch(themeProvider);

    final isDarkMode = themeMode == ThemeMode.dark ||
    (themeMode == ThemeMode.system &&
    MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final failedBg = isDarkMode ? 'assets/images/failed_bg_dark.png' : 'assets/images/failed_bg.jpg';

    void handleClose() async {
      // Session is already completed before navigating to this page
      // Just reset and navigate back
      sessionEngineController.reset();
      sesstionStatusController.updateMode(SessionMode.none);
      sesstionStatusController.updateStatus(SessionStatusEnum.stop);
      Navigator.of(context).pop();
    }

    void handleRepeat() {
      ref.read(sessionControllerProvider.notifier).reset();
      Get.back();
    }

    // _logger.d(metricsStateController.elapsedMs);

    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Schemes/Background'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              failedBg,
              fit: BoxFit.cover, // 👈 second image covers too
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/Pattern.png',
                color: isDarkMode ? Colors.white : null,
                colorBlendMode: isDarkMode ? BlendMode.srcIn : BlendMode.srcATop,
                fit: BoxFit.cover, // 👈 scales to cover screen
                filterQuality: FilterQuality.high,
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(child: Container()),

                Container(
                  child: Column(
                    children: [
                      Text(
                        'Oops!',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: getFigmaColor(context, 'Schemes/Error'),
                            ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Gap(context).gap(40),
                        ),
                        child: Text(
                          failureMessage,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: getFigmaColor(
                                  context,
                                  'Schemes/On Surface Variant',
                                ),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                Stack(
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns:
                          _starburstRotationController ??
                          const AlwaysStoppedAnimation<double>(0),
                      child: StarburstBadge(
                        spikes: 16,
                        innerRatio: 0.89,
                        starColor: getFigmaColor(
                          context,
                          'State Layers/Background/Opacity-60',
                        ),
                        child: const SizedBox.shrink(), // or any inner content
                      ),
                    ),

                    Positioned(
                      child: SizedBox(
                        // width: Gap(context).gap(60),
                        height: Gap(context).gap(100),
                        child: Icon(
                          Icons.mood_bad,
                          size: 80,
                          color: getFigmaColor(context, 'Schemes/Error'),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: Gap(context).gap(16),
                    ),
                    child: Row(
                      spacing: Gap(context).gap(10),
                      children: [
                        Expanded(
                          child: Container(
                            child: _statBlock(
                              context,
                              Icons.text_fields,
                              'WPM',
                              _finalWpm.toStringAsFixed(0),
                              failed: wpmFailed,
                            ),
                          ),
                        ),
                        SizedBox(width: Gap(context).gap(15)),
                        Expanded(
                          child: Container(
                            child: _statBlock(
                              context,
                              Icons.my_location,
                              'Accuracy',
                              '${(_finalAccuracy * 100).toStringAsFixed(0)}%',
                              failed: accFailed,
                            ),
                          ),
                        ),
                        SizedBox(width: Gap(context).gap(15)),
                        Expanded(
                          child: Container(
                            child: _statBlock(
                              context,
                              Icons.schedule,
                              'Time Taken',
                              formatDuration(_finalElapsed),
                              failed: timeFailed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Gap(context).gap(30)),

                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: Gap(context).gap(16),
                    ),
                    child: FilledButton(
                      onPressed: () => handleRepeat(),
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          EdgeInsetsGeometry.symmetric(
                            vertical: Gap(context).gap(16),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          getFigmaColor(context, 'Extended Colors/Blue'),
                        ),
                      ),
                      child: Text(
                        'Try Again',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: getFigmaColor(context, 'Schemes/On Green'),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Gap(context).gap(70)),

                SizedBox(
                  width: Gap(context).gap(230),
                  height: Gap(context).gap(150),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(150),
                    ), // optional
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: GestureDetector(
                        onTap: () => handleClose(),
                        child: Container(
                          // make it translucent so the blur is visible
                          color: getFigmaColor(
                            context,
                            'State Layers/On Background/Opacity-08',
                          ),
                          padding: EdgeInsets.all(Gap(context).gap(16)),
                          child: Column(
                            children: [
                              AbsorbPointer(
                                child: CloseButton(
                                  color: getFigmaColor(context, 'Schemes/On Background'),
                                  style: ButtonStyle(
                                    iconSize: WidgetStateProperty.all(
                                      KxScale(context).sp(25),
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                'Close',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: getFigmaColor(context, 'Schemes/On Background'),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // The definition is not fully "correct" by Dart/Flutter best practices.
  // Better to make the parameter types explicit for type safety/readability,
  // and place optional/named params after required ones. Here's a more proper version:
  Widget _statBlock(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool failed = false,
  }) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: Gap(context).gap(16),
                vertical: Gap(context).gap(10),
              ),
              decoration: BoxDecoration(
                color: failed
                    ? getFigmaColor(context, 'State Layers/Error/Opacity-10')
                    : getFigmaColor(context, 'State Layers/Success/Opacity-10'),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: failed
                      ? getFigmaColor(context, 'Schemes/Error')
                      : getFigmaColor(context, 'State Layers/Success/Opacity-16'),
                  width: 1.15,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                icon,
                color: failed
                    ? getFigmaColor(context, 'Schemes/Error')
                    : getFigmaColor(context, 'Schemes/Green'),
                size: KxScale(context).sp(30),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: failed
                ? getFigmaColor(context, 'Schemes/Error')
                : getFigmaColor(context, 'Schemes/On Green Container'),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _customIconButton(
    BuildContext context,
    Widget icon,
    String text,
    VoidCallback handlePress,
    double padding,
    Color? bgColor,
  ) {
    return TextButton.icon(
      label: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: getFigmaColor(context, 'Schemes/On Green'),
        ),
      ),
      onPressed: () => handlePress(),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          bgColor ??
              getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: Gap(context).gap(padding + 4),
            vertical: Gap(context).gap(padding),
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide.none,
          ),
        ),
      ),
      icon: icon,
    );
  }
}

// Must stay aligned with [SessionController._validateChallenge] math.
int _parseChallengeTimeLimitToMs(String timeLimit) {
  try {
    if (timeLimit.endsWith('m')) {
      final minutes = int.parse(timeLimit.substring(0, timeLimit.length - 1));
      return minutes * 60 * 1000;
    }
    final parts = timeLimit.split(':');
    if (parts.length == 2) {
      final minutes = int.parse(parts[0]);
      final seconds = int.parse(parts[1]);
      return (minutes * 60 + seconds) * 1000;
    }
  } catch (_) {}
  return 5 * 60 * 1000;
}

String _difficultyLabel(DifficultyEnum d) {
  return d.name[0].toUpperCase() + d.name.substring(1);
}

String _andJoinClauses(List<String> clauses) {
  if (clauses.isEmpty) return '';
  if (clauses.length == 1) return clauses.first;
  if (clauses.length == 2) {
    return '${clauses[0]} and ${clauses[1]}';
  }
  return '${clauses.sublist(0, clauses.length - 1).join(', ')}, and ${clauses.last}';
}

String _buildChallengeFailureMessage({
  required DifficultyCriteriaEntity criteria,
  required String difficultyLabel,
  required double wpm,
  required double accuracy,
  required int elapsedMs,
}) {
  final timeLimitMs = _parseChallengeTimeLimitToMs(criteria.timelimit);
  final accuracyPercent = accuracy * 100.0;
  final wpmFailed = wpm < criteria.wpm;
  final accFailed = accuracyPercent < criteria.accuracy;
  final timeFailed = elapsedMs > timeLimitMs;

  if (!wpmFailed && !accFailed && !timeFailed) {
    return "This $difficultyLabel challenge wasn’t met. Try again!";
  }

  // One clear line when only a single bar was missed
  if (wpmFailed && !accFailed && !timeFailed) {
    return 'WPM is too low! You need at least ${criteria.wpm} for this $difficultyLabel challenge.';
  }
  if (accFailed && !wpmFailed && !timeFailed) {
    return 'Accuracy is too low! You need at least ${criteria.accuracy}% for this $difficultyLabel challenge.';
  }
  if (timeFailed && !wpmFailed && !accFailed) {
    return 'Time limit exceeded! You had to finish within ${criteria.timelimit} for this $difficultyLabel challenge.';
  }

  // Two or more criteria: same order as validation — WPM, then accuracy, then time
  final issues = <String>[];
  if (wpmFailed) {
    issues.add('WPM is below the required ${criteria.wpm}');
  }
  if (accFailed) {
    issues.add('accuracy is below the required ${criteria.accuracy}%');
  }
  if (timeFailed) {
    issues.add("you’ve exceeded the time limit (${criteria.timelimit})");
  }
  return 'This $difficultyLabel challenge was not met: ${_andJoinClauses(issues)}.';
}
