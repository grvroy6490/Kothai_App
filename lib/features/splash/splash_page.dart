

import 'package:flutter/material.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatelessWidget {
    const SplashPage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Surface'),
            body: Stack(
                children: [
                    Opacity(opacity: 0.3,
                        child: Image.asset('assets/images/Pattern.png',
                            width: double.infinity,
                            height: double.infinity
                        )
                    ),

                    SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child:  Column(
                            children: [
                                Expanded(
                                    flex: 15,
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Center(
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.asset(
                                                    'assets/images/logo.png',
                                                    fit: BoxFit.contain,
                                                    width: 100
                                                )
                                            )
                                        )
                                    )
                                ),
                                Text(
                                    "வணக்கம்!",
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/Primary'),
                                        fontWeight: FontWeight.w600
                                    ),
                                    textAlign: TextAlign.center
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 50),
                                    child: Text(
                                        "தமிழ் தட்டச்சுத் திறனை மேம்படுத்தலாம் வாங்க!",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                        ),
                                        textAlign: TextAlign.center
                                    )
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: LoadingAnimationWidget.progressiveDots(
                                        color: getFigmaColor(context, 'Schemes/Primary'),
                                        size: 50
                                    )
                                ),
                                // Padding(padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(20)),
                                //     child: Text(
                                //         "தட்டச்சு களம் தயாராகிறது...",
                                //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                //             color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                //         ),
                                //         textAlign: TextAlign.center
                                //     )
                                // ),
                                Expanded(
                                    flex: 1,
                                    child: Container()
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }
}


