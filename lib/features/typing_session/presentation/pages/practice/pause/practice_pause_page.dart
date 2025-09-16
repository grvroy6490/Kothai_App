
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/core/utils/time_utils.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/pause/star_burst_badge.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/pause/stats_badge.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/reset/practice_reset_page.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/stop/practice_stop_page.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/metrics/metrics_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practise_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/progress/practice_progress_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/sessions/practice/practice_session_controller.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/sessions/session_state/session_state_provider.dart';

class PracticePausePage extends ConsumerStatefulWidget {
    final TextEditingController controller;
    const PracticePausePage({super.key, required this.controller});

    @override
    ConsumerState<PracticePausePage> createState() => _PracticePausePageState();
}

class _PracticePausePageState extends ConsumerState<PracticePausePage> {
    @override
    Widget build(BuildContext context) {
      final engine = ref.watch(sessionStateNotifierProvider);
      final metrics = ref.watch(metricsNotifierProvider);
      final practiceConfig = ref.watch(practiceConfigurationProvider);
      final progress = ref.watch(practiceProgressProvider);

        void handlePracticeStopConfirmation(){
            Get.to(() => PracticeStopPage(), transition: Transition.fadeIn, curve: Curves.easeInOutQuad);
        }

        void handlePracticeResume(){
            ref.read(practiceSessionControllerProvider.notifier).resume();
            Get.back();
        }

        void handlePracticeResetConfirmation(){
            Get.to(() => PracticeResetPage(controller: widget.controller,), arguments: 'fromPause', transition: Transition.fadeIn, curve: Curves.easeInOutQuad);
        }

        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: Stack(
                children: [
                    Opacity(opacity: 0.5,
                        child: Image.asset('assets/images/Pattern.png',
                            width: double.infinity,
                            height: double.infinity
                        )
                    ),

                    SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Column(
                            children: [
                                Container(
                                    alignment: Alignment.topCenter,         // center the child horizontally
                                    child: SizedBox(
                                        width: Gap(context).gap(230),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(115),
                                                bottomRight: Radius.circular(115)
                                            ),
                                            child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                                child:  Container(
                                                    padding: EdgeInsets.only(
                                                        top: Gap(context).gap(20),
                                                        left: Gap(context).gap(16),
                                                        right: Gap(context).gap(16),
                                                        bottom: Gap(context).gap(40)
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: getFigmaColor(context, 'State Layers/Error/Opacity-08').withAlpha(20),

                                                        borderRadius: const BorderRadius.only(
                                                            bottomLeft: Radius.circular(115),
                                                            bottomRight: Radius.circular(115)
                                                        ),
                                                        border: Border.all(
                                                            color: Colors.white.withOpacity(0.2), // subtle glass edge
                                                            width: 1.5
                                                        )
                                                    ),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            StatsBadge(
                                                                bgColor: getFigmaColor(
                                                                    context, 'State Layers/Background/Opacity-60'),
                                                                icon: Icons.text_fields,
                                                                label: 'WPM',
                                                                value: practiceConfig.wpmEnabled ? metrics.wpm.toStringAsFixed(0) : '--'
                                                            ),
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            StatsBadge(
                                                                bgColor: getFigmaColor(
                                                                    context, 'State Layers/Background/Opacity-60'),
                                                                icon: Icons.my_location,
                                                                label: 'Accuracy',
                                                                value: practiceConfig.accuracyEnabled ? '${(metrics.accuracy*100).toStringAsFixed(0)}%' : '--'
                                                            ),
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            StatsBadge(
                                                                bgColor: getFigmaColor(
                                                                    context, 'State Layers/Background/Opacity-60'),
                                                                icon: FontAwesomeIcons.clock,
                                                                label: 'Time',
                                                                value: practiceConfig.timerEnabled ? formatDuration(engine.elapsed) : '--'
                                                            ),
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            StatsBadge(
                                                                bgColor: getFigmaColor(
                                                                    context, 'State Layers/Background/Opacity-60'),
                                                                icon: Icons.rotate_right,
                                                                label: 'Progress',
                                                                value: '${(progress * 100).toStringAsFixed(1)}%'
                                                            ),
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            _iconLabelButton(
                                                                context,
                                                                color: getFigmaColor(context, 'Schemes/Error'),
                                                                label: 'Stop this Practice',
                                                                icon: Icons.front_hand,
                                                                tapBehavior: () => handlePracticeStopConfirmation()
                                                            )
                                                        ]
                                                    )

                                                )
                                            )
                                        )
                                    )
                                ),

                                Spacer(),

                                // START BURST
                                SizedBox(
                                    width: double.infinity,
                                    height: Gap(context).gap(180),
                                    child: StarburstBadge(
                                        size: Gap(context).gap(180),
                                        spikes: 20,           // try 16–24 for different scallops
                                        innerRatio: 0.78,
                                        starColor: getFigmaColor(context, 'State Layers/Primary/Opacity-08'),// closer to 1.0 = less spiky
                                        onTap: () => handlePracticeResume(),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                // play button
                                                Container(
                                                    width: Gap(context).gap(55),
                                                    height: Gap(context).gap(55),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: getFigmaColor(context, 'Schemes/Primary') // deep indigo
                                                    ),
                                                    child: Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.white,
                                                        size: KxScale(context).sp(40)
                                                    )
                                                ),
                                                SizedBox(height: Gap(context).gap(10)),
                                                // “Resume” (underlined)
                                                Text(
                                                    'Resume',
                                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                        color: getFigmaColor(context, 'Schemes/Primary')
                                                    )
                                                )
                                            ]
                                        )
                                    )

                                ),

                                Spacer(),

                                SizedBox(
                                    width: Gap(context).gap(230),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(115),
                                            topRight: Radius.circular(115)
                                        ),
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                            child: Container(
                                                width: Gap(context).gap(230),
                                                padding: EdgeInsets.only(
                                                    bottom: Gap(context).gap(16),
                                                    left: Gap(context).gap(16),
                                                    right: Gap(context).gap(16),
                                                    top: Gap(context).gap(40)
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
                                                            tapBehavior: ()  => handlePracticeResetConfirmation()
                                                        ),
                                                        SizedBox(height: Gap(context).gap(20))
                                                    ]
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
                        size: KxScale(context).sp(17)
                    ),
                    SizedBox(height: Gap(context).gap(10)),
                    Text(label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500
                        )
                    )
                ]
            )
        );

    }
}
