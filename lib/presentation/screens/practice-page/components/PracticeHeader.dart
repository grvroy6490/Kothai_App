import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/enums/PracticeStatusEnum.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/Level_XP_Indicator.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/PractiseStopButton.dart';
import 'package:kothai_app/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/presentation/shared/switch_theme_mode.dart';
import 'package:kothai_app/presentation/theme/app_typography.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';

class PracticeHeader extends ConsumerStatefulWidget {
    const PracticeHeader({super.key});

    @override
    ConsumerState<PracticeHeader> createState() => _PracticeHeaderState();
}

class _PracticeHeaderState extends ConsumerState<PracticeHeader> {
    @override
    Widget build(BuildContext context) {
        final practiseStatus = ref.watch(practiceStatusProvider);

        return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 25,
                bottom: 20,
                right: 16,
                left: 16
            ),
            decoration: BoxDecoration(
                color: practiseStatus == PracticeStatus.start
                    ? getFigmaColor(context, 'Schemes/Surface Container')
                    : getFigmaColor(context, 'Schemes/Background'),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                        'Practice',
                        style: AppTypography.titleLarge.copyWith(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                        ),
                    ),
                    SwitchThemeMode(),
                    Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            // Fixed-width crossfade (width = max(first, second))
                            AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeInOut,
                                switchOutCurve: Curves.easeInOut,
                                transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                                // Stack current & previous so width is max of both
                                layoutBuilder: (currentChild, previousChildren) {
                                    return Stack(
                                        alignment: Alignment.centerRight, // or .centerLeft to pin the other side
                                        children: <Widget>[
                                            ...previousChildren,
                                            if (currentChild != null) currentChild,
                                        ],
                                    );
                                },
                                child: ref.watch(practiceStatusProvider) == PracticeStatus.start
                                    ? const PracticeStopButton(key: ValueKey('stop'))
                                    : const LevelXP_Indicatior(key: ValueKey('xp')),
                            ),

                            // Notification Button
                            IconButton(
                                padding: const EdgeInsets.all(11),
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<Color>(
                                        getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
                                    ),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                    ),
                                ),
                                onPressed: () {},
                                icon: Icon(
                                    FontAwesomeIcons.bell,
                                    size: 20,
                                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                ),
                            ),
                        ],
                    )

                ],
            ),
        );
    }
}
