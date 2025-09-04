import 'package:flutter/material.dart';
import 'package:kothai_ui/kothai_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatelessWidget {
    const SplashPage({super.key});

    void _showFullPagePopup(BuildContext context) {
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            barrierColor: Colors.transparent, // no dark overlay
            backgroundColor: Colors.transparent, // fully transparent background
            builder: (BuildContext context) {
                return const Text('Drawer');
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
                children: [
                    const SizedBox(height: 100,),
                    const SwitchThemeMode(),
                    Expanded(
                        flex: 8,
                        child: SizedBox(
                            height: double.infinity,
                            child: Image.asset(
                                KAssets.image('Kothai_logo.png'),
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
                      size: 80,
                    ),
                  ),
                ],
            ),
        );
    }
}
