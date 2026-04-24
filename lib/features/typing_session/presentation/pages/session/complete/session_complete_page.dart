import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/widgets/safe_svg.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/core/utils/time_utils.dart';
import 'package:visai/di/providers/auth/auth_provider.dart';
import 'package:visai/di/providers/theme/theme_provider.dart';
import 'package:visai/features/share/presentation/pages/share_page.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/score/score_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/lottie_player.dart';
import 'package:visai/features/typing_session/presentation/widgets/star_burst_badge.dart';
import 'package:visai/features/typing_session/usecases/score/score_calculation.dart';
// import 'package:logger/logger.dart';

class SessionCompletePage extends ConsumerStatefulWidget {
  const SessionCompletePage({super.key});

  @override
  ConsumerState<SessionCompletePage> createState() =>
      _SessionCompletePageState();
}

class _SessionCompletePageState extends ConsumerState<SessionCompletePage>
    with TickerProviderStateMixin {
  // final _logger = Logger();
  AnimationController? _starburstRotationController;
  AnimationController? _xpPulseController;
  Animation<double>? _xpPulseAnimation;

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
    _xpPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _xpPulseAnimation = Tween<double>(begin: 1, end: 1.06).animate(
      CurvedAnimation(parent: _xpPulseController!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _starburstRotationController?.dispose();
    _xpPulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 📃 DECLARATION ----------------------------
    final themeMode = ref.watch(themeProvider);

    final isDarkMode =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final completeScreenGradient = isDarkMode
        ? 'assets/images/complete_screen_gradient_dark.png'
        : 'assets/images/complete_screen_gradient.png';

    // 🌐 PROVIDERS ------------------------------
    final sessionEngineController = ref.read(
      sessionControllerProvider.notifier,
    );
    final sesstionStatusController = ref.read(
      sessionStatusControllerProvider.notifier,
    );
    final sesstionStatusWatcher = ref.watch(sessionStatusControllerProvider);
    final metricsStateController = ref.read(metricsStateControllerProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final gamificationDataController = ref.watch(
      gamificationDataControllerProvider,
    );

    // 🚀 METHODS --------------------------------
    void handleNextPractice() async {
      sessionEngineController.reset();
      sessionEngineController.stop();
      await ref.read(textContentControllerProvider.notifier).rollNewContent();
      sessionEngineController.start();
      Get.back();
    }

    void handleClose() async {
      // Session is already completed before navigating to this page
      // Just reset and navigate back
      sessionEngineController.reset();
      sesstionStatusController.updateMode(SessionMode.none);
      sesstionStatusController.updateStatus(SessionStatusEnum.stop);
      Navigator.of(context).pop();
    }

    void shareResults() {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: getFigmaColor(
                    context,
                    'Schemes/Surface Container Lowest',
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SharePage(),
              ),
            ),
          );
        },
      );
    }

    Future<void> handleSave() async {
      try {
        await ref.read(scoreControllerProvider.notifier).syncAll();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress synced successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void handleRepeat() async {
      // Complete the session to save challenge data
      ref.read(sessionControllerProvider.notifier).restart();
      Get.back();
    }

    double getAwardedXp() {
      if (sesstionStatusWatcher.mode == SessionMode.practice) {
        return 50;
      }

      final difficultyCriteria = gamificationDataController?.difficultyCriteria
          .where(
            (criteria) =>
                criteria.type.toLowerCase() ==
                ref
                    .read(challengeDifficultyControllerProvider)
                    .name
                    .toLowerCase(),
          )
          .firstOrNull;

      double xp = calculateXP(
        totalChars: metricsStateController.totalChars,
        difficultyMultiplier: difficultyCriteria,
        accuracyPercent: metricsStateController.accuracy,
        wpm: metricsStateController.wpm,
      );

      return xp;
    }

    // _logger.d(metricsStateController.elapsedMs);

    // ⭐ Widget ---------------------------------
    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Schemes/Background'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              completeScreenGradient,
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
                colorBlendMode: isDarkMode
                    ? BlendMode.srcIn
                    : BlendMode.srcATop,
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
                        'Woooow!!!',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: getFigmaColor(
                                context,
                                'Schemes/On Green Container',
                              ),
                            ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Gap(context).gap(20),
                        ),
                        child: Text(
                          'You\'ve successfully completed this easy challenge',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: getFigmaColor(
                                  context,
                                  'Schemes/On Surface Variant',
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

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
                        innerRatio: 0.85,
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
                        child: LottiePlayer(
                          asset: 'assets/lottie/trophy.json',
                          repeat: true,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: Gap(context).gap(0),
                      child: ScaleTransition(
                        scale:
                            _xpPulseAnimation ??
                            const AlwaysStoppedAnimation<double>(1),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Gap(context).gap(5),
                            vertical: Gap(context).gap(5),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.45,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 1,
                              color: Color.fromARGB(
                                255,
                                110,
                                69,
                                0,
                              ).withAlpha(127),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                getFigmaColor(context, 'Palettes/Secondary 95'),
                                getFigmaColor(context, 'Palettes/Secondary 80'),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              SafeSvgAsset('assets/images/Gold_Star_Icon.svg'),
                              SizedBox(width: Gap(context).gap(10)),
                              Expanded(
                                child: Text(
                                  'Earned',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: getFigmaColor(
                                          context,
                                          'Schemes/Secondary',
                                        ),
                                      ),
                                ),
                              ),
                              Text(
                                '+${getAwardedXp().toInt().toString()} XP',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: getFigmaColor(
                                        context,
                                        'Schemes/Secondary',
                                      ),
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              SizedBox(width: Gap(context).gap(10)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Gap(context).gap(20)),

                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: Gap(context).gap(16),
                    ),
                    child: FilledButton(
                      onPressed: () =>
                          sesstionStatusWatcher.mode == SessionMode.practice
                          ? handleNextPractice()
                          : handleClose(),
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          EdgeInsetsGeometry.symmetric(
                            vertical: Gap(context).gap(16),
                          ),
                        ),
                        backgroundColor:
                            sesstionStatusWatcher.mode == SessionMode.practice
                            ? WidgetStateProperty.all(
                                getFigmaColor(context, 'Schemes/Green'),
                              )
                            : WidgetStateProperty.all(
                                getFigmaColor(context, 'Extended Colors/Blue'),
                              ),
                      ),
                      child: sesstionStatusWatcher.mode == SessionMode.practice
                          ? Text(
                              'Try Next Practice',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/On Green',
                                    ),
                                  ),
                            )
                          : Text(
                              'Try Next Challenge',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/On Green',
                                    ),
                                  ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: Gap(context).gap(20)),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Gap(context).gap(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _customIconButton(
                          context,
                          Icon(
                            Icons.repeat,
                            color: getFigmaColor(
                              context,
                              'Schemes/On Secondary',
                            ),
                          ),
                          'Retry',
                          handleRepeat,
                          Gap(context).gap(12),
                          getFigmaColor(context, 'Schemes/Secondary'),
                        ),
                      ),

                      // SizedBox(width: Gap(context).gap(15)),
                      //
                      // Expanded(
                      //     flex: 3,
                      //     child: FilledButton(
                      //         onPressed: () => isLoggedIn ? shareResults() : handleAuthentication(),
                      //         style: ButtonStyle(
                      //             backgroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/On Background'))
                      //         ),
                      //         child: Text(isLoggedIn ? 'Share your results' : 'Sign up to save results',
                      //             textAlign: TextAlign.center,
                      //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      //                 color: getFigmaColor(context, 'Schemes/Background')
                      //             )
                      //         )
                      //     )
                      // ),
                      SizedBox(width: Gap(context).gap(15)),

                      Expanded(
                              child: _customIconButton(
                                context,
                                Icon(
                                  Icons.share,
                                  color: getFigmaColor(
                                    context,
                                    'Schemes/On Secondary',
                                  ),
                                ),
                                'Share',
                                shareResults,
                                Gap(context).gap(12),
                                getFigmaColor(context, 'Schemes/Tertiary'),
                              ),
                            ),
                    ],
                  ),
                ),

                SizedBox(height: Gap(context).gap(30)),

                SizedBox(
                  width: Gap(context).gap(230),
                  height: Gap(context).gap(120),
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
                                  color: getFigmaColor(
                                    context,
                                    'Schemes/On Background',
                                  ),
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
                                      color: getFigmaColor(
                                        context,
                                        'Schemes/On Background',
                                      ),
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

  Widget _statBlock(context, icon, label, value) {
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
                color: getFigmaColor(
                  context,
                  'State Layers/Success/Opacity-10',
                ),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: getFigmaColor(
                    context,
                    'State Layers/Success/Opacity-16',
                  ),
                  width: 1.15,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                icon,
                color: getFigmaColor(context, 'Schemes/Green'),
                size: KxScale(context).sp(30),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: getFigmaColor(context, 'Schemes/On Green Container'),
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
