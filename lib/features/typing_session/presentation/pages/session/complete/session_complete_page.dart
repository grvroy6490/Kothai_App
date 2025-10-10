import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/widgets/safe_svg.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/core/utils/time_utils.dart';
import 'package:kothai_app/di/providers/auth/auth_provider.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/metrics/metrics_state_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/lottie_player.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/star_burst_badge.dart';
import 'package:kothai_app/features/typing_session/usecases/score/score_calculation.dart';

class SessionCompletePage extends ConsumerStatefulWidget {
    const SessionCompletePage({super.key});

    @override
    ConsumerState<SessionCompletePage> createState() =>
    _SessionCompletePageState();
}

class _SessionCompletePageState extends ConsumerState<SessionCompletePage> {
    @override
    Widget build(BuildContext context) {
        // 📃 DECLARATION ----------------------------

        // 🌐 PROVIDERS ------------------------------
        final sessionEngineWatcher = ref.watch(sessionControllerProvider);
        final sessionEngineController = ref.read(
            sessionControllerProvider.notifier
        );
        final sesstionStatusController = ref.read(
            sessionStatusControllerProvider.notifier
        );
        final sesstionStatusWatcher = ref.watch(sessionStatusControllerProvider);
        final metricsStateController = ref.read(metricsStateControllerProvider);
        final isLoggedIn = ref.watch(isLoggedInProvider);
        final gamificationDataController = ref.watch(
            gamificationDataControllerProvider
        );

        // 🚀 METHODS --------------------------------
        void handleNextPractice() async {
            sessionEngineController.reset();
            sessionEngineController.stop();
            await ref.read(textContentControllerProvider.notifier).rollNewContent();
            Get.back();
        }

        void handleClose() async {
            // Complete the session to save challenge data
            await sessionEngineController.complete();
            sessionEngineController.reset();
            sesstionStatusController.updateMode(SessionMode.none);
            sesstionStatusController.updateStatus(SessionStatusEnum.stop);
            Navigator.of(context).pop();
        }

        void shareResults() {
            // TODO: SHARE YOUR PROGRESS
        }

        void handleSave() {
            // TODO: SAVE YOUR PROGRESS
        }

        void handleRepeat() async {
            // Complete the session to save challenge data
            await sessionEngineController.complete();
            sessionEngineController.reset();
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
                            .toLowerCase()
                )
                .firstOrNull;

            double xp = calculateXP(
                totalChars: metricsStateController.totalChars,
                difficultyMultiplier: difficultyCriteria,
                accuracyPercent: metricsStateController.accuracy,
                wpm: metricsStateController.wpm
            );

            return xp;
        }

        // ⭐ Widget ---------------------------------
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: Stack(
                children: [
                    Positioned.fill(
                        child: Image.asset(
                            'assets/images/complete_screen_gradient.png',
                            fit: BoxFit.cover, // 👈 second image covers too
                            filterQuality: FilterQuality.high
                        )
                    ),
                    Positioned.fill(
                        child: Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                'assets/images/Pattern.png',
                                fit: BoxFit.cover, // 👈 scales to cover screen
                                filterQuality: FilterQuality.high
                            )
                        )
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
                                                            'Schemes/On Green Container'
                                                        )
                                                    )
                                            ),

                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Gap(context).gap(20)
                                                ),
                                                child: Text(
                                                    'You\'ve successfully completed this easy challenge',
                                                    style: Theme.of(context).textTheme.bodyLarge
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Surface Variant'
                                                            )
                                                        )
                                                )
                                            )
                                        ]
                                    )
                                ),

                                SizedBox(height: 40),

                                Stack(
                                    clipBehavior: Clip.hardEdge,
                                    alignment: Alignment.center,
                                    children: [
                                        StarburstBadge(
                                            spikes: 16,
                                            starColor: Colors.white.withAlpha(170),
                                            child: const SizedBox.shrink() // or any inner content
                                        ),

                                        Positioned(
                                            child: SizedBox(
                                                // width: Gap(context).gap(60),
                                                height: Gap(context).gap(100),
                                                child: LottiePlayer(
                                                    asset: 'assets/lottie/trophy.json',
                                                    repeat: true
                                                )
                                            )
                                        ),

                                        Positioned(
                                            bottom: Gap(context).gap(0),
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Gap(context).gap(5),
                                                    vertical: Gap(context).gap(5)
                                                ),
                                                constraints: BoxConstraints(
                                                    maxWidth: MediaQuery.of(context).size.width * 0.45
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Color.fromARGB(
                                                            255,
                                                            110,
                                                            69,
                                                            0
                                                        ).withAlpha(127)
                                                    ),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                            getFigmaColor(context, 'Palettes/Secondary 95'),
                                                            getFigmaColor(context, 'Palettes/Secondary 80')
                                                        ]
                                                    )
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
                                                                            'Schemes/Secondary'
                                                                        )
                                                                    )
                                                            )
                                                        ),
                                                        Text(
                                                            '+${getAwardedXp().toInt().toString()} XP',
                                                            style: Theme.of(context).textTheme.titleMedium
                                                                ?.copyWith(
                                                                    color: getFigmaColor(
                                                                        context,
                                                                        'Schemes/Secondary'
                                                                    ),
                                                                    fontWeight: FontWeight.w900
                                                                )
                                                        ),
                                                        SizedBox(width: Gap(context).gap(10))
                                                    ]
                                                )
                                            )
                                        )
                                    ]
                                ),

                                SizedBox(height: 40),

                                SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                        padding: EdgeInsetsGeometry.symmetric(
                                            horizontal: Gap(context).gap(16)
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
                                                            metricsStateController.wpm.toStringAsFixed(0)
                                                        )
                                                    )
                                                ),
                                                SizedBox(width: Gap(context).gap(15)),
                                                Expanded(
                                                    child: Container(
                                                        child: _statBlock(
                                                            context,
                                                            Icons.my_location,
                                                            'Accuracy',
                                                            '${(metricsStateController.accuracy * 100).toStringAsFixed(0)}%'
                                                        )
                                                    )
                                                ),
                                                SizedBox(width: Gap(context).gap(15)),
                                                Expanded(
                                                    child: Container(
                                                        child: _statBlock(
                                                            context,
                                                            Icons.schedule,
                                                            'Time Taken',
                                                            formatDuration(sessionEngineWatcher.elapsed)
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                ),

                                SizedBox(height: Gap(context).gap(30)),

                                SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                        padding: EdgeInsetsGeometry.symmetric(
                                            horizontal: Gap(context).gap(16)
                                        ),
                                        child: FilledButton(
                                            onPressed: () =>
                                            sesstionStatusWatcher.mode == SessionMode.practice
                                                ? handleNextPractice()
                                                : handleClose(),
                                            style: ButtonStyle(
                                                padding: WidgetStateProperty.all(
                                                    EdgeInsetsGeometry.symmetric(
                                                        vertical: Gap(context).gap(16)
                                                    )
                                                ),
                                                backgroundColor:
                                                sesstionStatusWatcher.mode == SessionMode.practice
                                                    ? WidgetStateProperty.all(
                                                        getFigmaColor(context, 'Schemes/Green')
                                                    )
                                                    : WidgetStateProperty.all(
                                                        getFigmaColor(context, 'Extended Colors/Blue')
                                                    )
                                            ),
                                            child: sesstionStatusWatcher.mode == SessionMode.practice
                                                ? Text(
                                                    'Try Next Practice',
                                                    style: Theme.of(context).textTheme.bodyLarge
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Green'
                                                            )
                                                        )
                                                )
                                                : Text(
                                                    'Try Next Challenge',
                                                    style: Theme.of(context).textTheme.bodyLarge
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Green'
                                                            )
                                                        )
                                                )
                                        )
                                    )
                                ),

                                SizedBox(height: Gap(context).gap(30)),

                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gap(context).gap(16)
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
                                                            'Schemes/On Secondary'
                                                        )
                                                    ),
                                                    'Retry',
                                                    handleRepeat,
                                                    Gap(context).gap(12),
                                                    getFigmaColor(context, 'Schemes/Secondary')
                                                )
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

                                            isLoggedIn
                                                ? Expanded(
                                                    child: _customIconButton(
                                                        context,
                                                        Icon(
                                                            Icons.cloud_upload_rounded,
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Secondary'
                                                            )
                                                        ),
                                                        'Save your results',
                                                        handleSave,
                                                        Gap(context).gap(12),
                                                        getFigmaColor(context, 'Schemes/Tertiary')
                                                    )
                                                )
                                                : Expanded(
                                                    child: _customIconButton(
                                                        context,
                                                        Icon(
                                                            Icons.share,
                                                            color: getFigmaColor(
                                                                context,
                                                                'Schemes/On Secondary'
                                                            )
                                                        ),
                                                        'Share',
                                                        shareResults,
                                                        Gap(context).gap(12),
                                                        getFigmaColor(context, 'Schemes/Tertiary')
                                                    )
                                                )
                                        ]
                                    )
                                ),

                                SizedBox(height: Gap(context).gap(30)),

                                SizedBox(
                                    width: Gap(context).gap(230),
                                    height: Gap(context).gap(150),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(150)
                                        ), // optional
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                            child: GestureDetector(
                                                onTap: () => handleClose(),
                                                child: Container(
                                                    // make it translucent so the blur is visible
                                                    color: getFigmaColor(
                                                        context,
                                                        'State Layers/On Background/Opacity-08'
                                                    ),
                                                    padding: EdgeInsets.all(Gap(context).gap(16)),
                                                    child: Column(
                                                        children: [
                                                            AbsorbPointer(
                                                                child: CloseButton(
                                                                    color: Color.fromARGB(255, 29, 26, 34),
                                                                    style: ButtonStyle(
                                                                        iconSize: WidgetStateProperty.all(
                                                                            KxScale(context).sp(25)
                                                                        )
                                                                    )
                                                                )
                                                            ),

                                                            Text(
                                                                'Close',
                                                                style: Theme.of(context).textTheme.labelLarge
                                                                    ?.copyWith(
                                                                        color: Color.fromARGB(255, 29, 26, 34),
                                                                        fontWeight: FontWeight.w600
                                                                    )
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }

    Widget _statBlock(context, icon, label, value) {
        return Column(
            children: [
                Container(
                    width: double.infinity,
                    padding: EdgeInsetsGeometry.symmetric(
                        horizontal: Gap(context).gap(16),
                        vertical: Gap(context).gap(10)
                    ),
                    decoration: BoxDecoration(
                        color: getFigmaColor(context, 'State Layers/Success/Opacity-10'),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: getFigmaColor(context, 'State Layers/Success/Opacity-16'),
                            width: 1.15,
                            style: BorderStyle.solid
                        )
                    ),
                    child: Icon(
                        icon,
                        color: Color.fromARGB(255, 0, 110, 28),
                        size: KxScale(context).sp(30)
                    )
                ),
                SizedBox(height: 10),
                Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Color.fromARGB(255, 0, 55, 10),
                        fontWeight: FontWeight.w600
                    )
                ),
                Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Color.fromARGB(255, 74, 69, 77)
                    )
                )
            ]
        );
    }

    Widget _customIconButton(
        BuildContext context,
        Widget icon,
        String text,
        VoidCallback handlePress,
        double padding,
        Color? bgColor
    ) {
        return TextButton.icon(
            label: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: getFigmaColor(context, 'Schemes/On Green')
                )
            ),
            onPressed: () => handlePress(),
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    bgColor ??
                        getFigmaColor(context, 'State Layers/On Surface/Opacity-08')
                ),
                padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(
                        horizontal: Gap(context).gap(padding + 4),
                        vertical: Gap(context).gap(padding)
                    )
                ),
                shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide.none
                    )
                )
            ),
            icon: icon
        );
    }
}
