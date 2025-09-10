import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/presentation/providers/facades/practice_facade.dart';
import 'package:kothai_app/presentation/providers/keyboard/keyboard_provider.dart';
import 'package:kothai_app/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/presentation/theme/app_typography.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';

class PracticeStopButton extends ConsumerStatefulWidget {
    const PracticeStopButton({super.key});

    @override
    ConsumerState<PracticeStopButton> createState() => _PracticeStopButtonState();
}

class _PracticeStopButtonState extends ConsumerState<PracticeStopButton> {
    @override
    Widget build(BuildContext context) {
        void handlePracticeStop() {
            ref.read(practiceStatusProvider.notifier).stopPractice();
            ref.read(keyboardProvider.notifier).hideKeyboard();
            ref.read(practiceFacadeProvider.notifier).endSession();
        }

        return FilledButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    getFigmaColor(context, 'State Layers/Error/Opacity-08'),
                ),
                padding: WidgetStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                ),
            ),
            onPressed: handlePracticeStop,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                    Container(
                        decoration: BoxDecoration(
                            color: getFigmaColor(context, 'Schemes/Error'),
                            borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.all(3),
                        child: Icon(
                            Icons.stop,
                            size: 20,
                            color: getFigmaColor(context, 'Schemes/On Error'),
                        ),
                    ),
                    Text(
                        'Stop Practice',
                        style: AppTypography.labelLarge.copyWith(
                            color: getFigmaColor(context, 'Schemes/Error'),
                            fontWeight: FontWeight.w500,
                        ),
                    ),
                ],
            ),
        );
    }
}
