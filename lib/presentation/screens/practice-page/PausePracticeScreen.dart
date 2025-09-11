
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/presentation/providers/session/session_progress_provider.dart';
import 'package:kothai_app/presentation/providers/session/session_state_provider.dart';
import 'package:kothai_app/presentation/screens/practice-page/ResetPracticeScreen.dart';
import 'package:kothai_app/presentation/screens/practice-page/StopPracticeScreen.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/StarburstBadge.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/StatsBadge.dart';
import 'package:kothai_app/presentation/theme/app_typography.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PracticePauseScreen extends ConsumerWidget {
    const PracticePauseScreen({super.key});

    @override
    Widget build(BuildContext context, ref) {

        final sessionState = ref.watch(sessionStateProvider);
        final progress = ref.watch(sessionProgressProvider);



        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                    children: [
                        Opacity(opacity: 0.5,
                            child: Image.asset('assets/images/Pattern.png',
                                width: double.infinity,
                                height: double.infinity,
                            ),
                        ),
                        SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Column(
                                children: [
                                    // Top Button
                                    ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(115),
                                            bottomRight: Radius.circular(115),
                                        ),
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // blur strength
                                            child: Container(
                                                width: 230,
                                                padding: const EdgeInsets.only(
                                                    top: 20,
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 40,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: getFigmaColor(context, 'State Layers/Error/Opacity-08').withAlpha(20),

                                                    borderRadius: const BorderRadius.only(
                                                        bottomLeft: Radius.circular(115),
                                                        bottomRight: Radius.circular(115),
                                                    ),
                                                    border: Border.all(
                                                        color: Colors.white.withOpacity(0.2), // subtle glass edge
                                                        width: 1.5,
                                                    ),
                                                ),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

                                                        StatsBadge(
                                                            bgColor: getFigmaColor(
                                                                context, 'State Layers/Background/Opacity-60'),
                                                            icon: Icons.text_fields,
                                                            label: 'WPM',
                                                            value: sessionState.wpm.toStringAsFixed(0),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        StatsBadge(
                                                            bgColor: getFigmaColor(
                                                                context, 'State Layers/Background/Opacity-60'),
                                                            icon: Icons.my_location,
                                                            label: 'Accuracy',
                                                            value: '${sessionState.accuracy.toStringAsFixed(2)}%',
                                                        ),
                                                        const SizedBox(height: 10),
                                                        StatsBadge(
                                                            bgColor: getFigmaColor(
                                                                context, 'State Layers/Background/Opacity-60'),
                                                            icon: FontAwesomeIcons.clock,
                                                            label: 'Time',
                                                            value: sessionState.formattedElapsed,
                                                        ),
                                                        const SizedBox(height: 10),
                                                        StatsBadge(
                                                            bgColor: getFigmaColor(
                                                                context, 'State Layers/Background/Opacity-60'),
                                                            icon: Icons.rotate_right,
                                                            label: 'Progress',
                                                            value: '${(progress * 100).toStringAsFixed(1)}%',
                                                        ),
                                                        const SizedBox(height: 20),
                                                        _iconLabelButton(
                                                            context,
                                                            color: getFigmaColor(context, 'Schemes/Error'),
                                                            label: 'Stop this Practice',
                                                            icon: Icons.front_hand,
                                                            tapBehavior: () {

                                                                Get.to(() => const StopPracticeScreen(), transition: Transition.fadeIn);
                                                            },
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        ),
                                    ),

                                    Expanded(
                                        child: StarburstBadge(
                                            size: 180,
                                            spikes: 20,           // try 16–24 for different scallops
                                            innerRatio: 0.78,
                                            starColor: getFigmaColor(context, 'State Layers/Primary/Opacity-08'),// closer to 1.0 = less spiky
                                            onTap: () {
                                                ref.read(sessionStateProvider.notifier).resume();
                                                Get.back();
                                            },
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    // play button
                                                    Container(
                                                        width: 55,
                                                        height: 55,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: getFigmaColor(context, 'Schemes/Primary'), // deep indigo
                                                        ),
                                                        child: const Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.white,
                                                            size: 40
                                                        ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    // “Resume” (underlined)
                                                    Text(
                                                        'Resume',
                                                        style: AppTypography.labelLarge.copyWith(
                                                            color: getFigmaColor(context, 'Schemes/Primary')
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        )
                                    ),

                                    ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(115),
                                            topRight: Radius.circular(115),
                                        ),
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                            child: Container(
                                                width: 230,
                                                padding: EdgeInsets.only(
                                                    bottom: 16,
                                                    left: 16,
                                                    right: 16,
                                                    top: 40
                                                ),
                                                decoration: BoxDecoration(
                                                    color: getFigmaColor(context, 'State Layers/Error/Opacity-08').withAlpha(20),
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(115),
                                                        topRight: Radius.circular(115)
                                                    )
                                                ),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        _iconLabelButton(
                                                            context,
                                                            color: getFigmaColor(context, 'Schemes/Secondary'),
                                                            label: 'Reset Progress',
                                                            icon: FontAwesomeIcons.clockRotateLeft,
                                                            tapBehavior: ()  {
                                                               Get.to(() => const ResetPauseScreen(), transition: Transition.fadeIn);
                                                            }
                                                        ),
                                                        SizedBox(height: 20,),
                                                    ],
                                                ),
                                            ),
                                        ),
                                    )
                                ],
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}

Widget _iconLabelButton(
    BuildContext context,
    {
        required String label,
        required IconData icon,
        required Color color,
        void Function()? tapBehavior
    }
){
    return GestureDetector(
        onTap: tapBehavior,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Icon(icon,
                    color: color,
                    size: 17,
                ),
                SizedBox(height: 10,),
                Text(label,
                    style: AppTypography.labelLarge.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500
                    ),
                )
            ],
        )
    );

}
