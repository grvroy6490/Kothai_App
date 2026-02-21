import 'package:flutter/material.dart';
import 'package:visai/presentation/theme/app_typography.dart';
import 'package:visai/presentation/theme/figma_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatelessWidget {
    const SplashPage({super.key});

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
                children: [
                    const SizedBox(height: 100),
                    Expanded(
                        flex: 8,
                        child: SizedBox(
                            height: double.infinity,
                            child: Image.asset(
                                'assets/images/Kothai_logo.png',
                                fit: BoxFit.contain,
                                width: 100,
                            ),
                        ),
                    ),
                    Text(
                        "வணக்கம்!",
                        style: AppTypography.headlineSmall.copyWith(
                            color: getFigmaColor(context, 'Schemes/Primary'),
                            fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                    ),
                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                                "கோதை செயலியில் உங்களை வரவேற்கிறோம். நீங்கள் எழுதுவது போல் தட்டச்சு செய்யலாம்.",
                                style: AppTypography.bodyMedium.copyWith(
                                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                ),
                                textAlign: TextAlign.center,
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: LoadingAnimationWidget.progressiveDots(
                            color: getFigmaColor(context, 'Schemes/Primary'),
                            size: 50,
                        ),
                    ),
                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                "உங்கள் தட்டச்சு பயணத்தை தயாரிக்கிறோம்...",
                                style: AppTypography.bodyMedium.copyWith(
                                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                ),
                                textAlign: TextAlign.center,
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
