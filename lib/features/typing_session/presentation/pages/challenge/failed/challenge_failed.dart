import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/core/utils/time_utils.dart';
import 'package:visai/core/widgets/safe_svg.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/lottie_player.dart';
import 'package:visai/features/typing_session/presentation/widgets/star_burst_badge.dart';
import 'package:logger/logger.dart';

class ChallengeFailed extends ConsumerStatefulWidget {
  const ChallengeFailed({super.key});

  @override
  ConsumerState<ChallengeFailed> createState() => _ChallengeFailedState();
}

class _ChallengeFailedState extends ConsumerState<ChallengeFailed> {
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    final sessionEngineController = ref.read(
      sessionControllerProvider.notifier,
    );
    final sesstionStatusController = ref.read(
      sessionStatusControllerProvider.notifier,
    );
    final metricsStateController = ref.read(metricsStateControllerProvider);

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
              'assets/images/failed_bg.jpg',
              fit: BoxFit.cover, // 👈 second image covers too
              filterQuality: FilterQuality.high,
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/Pattern.png',
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
                          'Time limit exceeded! You\'ve completed this easy challenge',
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
                    StarburstBadge(
                      spikes: 16,
                      starColor: Colors.white.withAlpha(170),
                      child: const SizedBox.shrink(), // or any inner content
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
                              metricsStateController.wpm.toStringAsFixed(0),
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
                              '${(metricsStateController.accuracy * 100).toStringAsFixed(0)}%',
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
                              formatDuration(
                                Duration(
                                  milliseconds:
                                      metricsStateController.elapsedMs,
                                ),
                              ),
                              failed: true,
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
                                  color: Color.fromARGB(255, 29, 26, 34),
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
                                      color: Color.fromARGB(255, 29, 26, 34),
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
        Container(
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
                : Color.fromARGB(255, 0, 110, 28),
            size: KxScale(context).sp(30),
          ),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: failed
                ? getFigmaColor(context, 'Schemes/Error')
                : Color.fromARGB(255, 0, 55, 10),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Color.fromARGB(255, 74, 69, 77),
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
