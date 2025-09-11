
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/presentation/providers/session/session_state_provider.dart';
import 'package:kothai_app/presentation/screens/practice-page/PracticeScreen.dart';
import 'package:kothai_app/presentation/theme/app_typography.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';
import 'package:get/get.dart';

class ResetPauseScreen extends ConsumerWidget {
    const ResetPauseScreen({super.key});

    @override
    Widget build(BuildContext context, ref) {

        // final sessionState = ref.watch(sessionStateProvider);
        // final progress = ref.watch(sessionProgressProvider);

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
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Stack(
                                                children: [
                                                    Positioned(
                                                        left:0,
                                                        bottom: 0,
                                                        child: Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            height:315,
                                                            padding: EdgeInsets.all(16),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(16),
                                                                color: getFigmaColor(context, 'State Layers/Secondary/Opacity-08')
                                                            ),
                                                        ),
                                                    ),

                                                    Padding(
                                                        padding: EdgeInsets.all(16),
                                                        child: Column(
                                                            children: [
                                                                Container(
                                                                    padding: EdgeInsets.all(25),
                                                                    decoration: BoxDecoration(
                                                                        color: getFigmaColor(context, 'Schemes/On Secondary'),
                                                                        borderRadius: BorderRadius.circular(100),
                                                                    ),
                                                                    child: Icon(Icons.history, size: 60, color: getFigmaColor(context, 'Schemes/Secondary'),),
                                                                ),
                                                                SizedBox(height: 30,),
                                                                Text('Reset Progress', style: AppTypography.titleLarge.copyWith(
                                                                        color: getFigmaColor(context, 'Schemes/Secondary'),
                                                                        fontWeight: FontWeight.w600
                                                                    ),
                                                                ),
                                                                SizedBox(height: 10,),
                                                                SizedBox(
                                                                    width: MediaQuery.of(context).size.width * 0.8,
                                                                    child: Center(
                                                                        child: Text('Are you sure you want to reset your progress in this practice?',
                                                                            style: AppTypography.bodyLarge.copyWith(
                                                                                color: getFigmaColor(context, 'Schemes/On Surface')
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )

                                                                ),
                                                                SizedBox(height: 15,),
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        color: getFigmaColor(context, 'State Layers/Secondary/Opacity-08'),
                                                                        borderRadius: BorderRadius.circular(30),
                                                                    ),
                                                                    padding: EdgeInsets.all(6),
                                                                    child: Row(
                                                                        children: [
                                                                            Container(
                                                                                padding: EdgeInsets.all(12),
                                                                                decoration: BoxDecoration(
                                                                                    color: getFigmaColor(context, 'State Layers/Secondary/Opacity-08'),
                                                                                    borderRadius: BorderRadius.circular(100),
                                                                                ),
                                                                                child: Icon(Icons.warning, size: 25, color: getFigmaColor(context, 'Schemes/Secondary'),),
                                                                            ),
                                                                            SizedBox(width: 14,),
                                                                            Expanded(
                                                                                child: Text("You've made it to 88%! If you reset your progress, it will return to 0%.",
                                                                                    style: AppTypography.bodyMedium.copyWith(
                                                                                        color: getFigmaColor(context, 'Schemes/Secondary')
                                                                                    ),
                                                                                )
                                                                            )
                                                                        ],
                                                                    ),
                                                                ),
                                                                SizedBox(height: 20,),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    spacing: 16,
                                                                    children: [
                                                                        Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 16)),
                                                                                    backgroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/On Secondary')),
                                                                                    foregroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/Secondary'))
                                                                                ),
                                                                                onPressed: (){
                                                                                    ref.read(sessionStateProvider.notifier).reset();
                                                                                    Get.to(() => const PracticeScreen(), transition: Transition.fadeIn);
                                                                                },
                                                                                child: Text('Yes, Reset it', style: AppTypography.bodyLarge)
                                                                            ),
                                                                        ),

                                                                        Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                    backgroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/On Surface Variant')),
                                                                                    foregroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Schemes/Surface Variant')),
                                                                                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 16))
                                                                                ),
                                                                                onPressed: (){
                                                                                    Get.back();
                                                                                },
                                                                                child: Text('No', style: AppTypography.bodyLarge,)
                                                                            )
                                                                        )
                                                                    ],
                                                                )
                                                            ],
                                                        ),
                                                    )
                                                ],
                                            )
                                        )
                                    ],
                                ),
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}
