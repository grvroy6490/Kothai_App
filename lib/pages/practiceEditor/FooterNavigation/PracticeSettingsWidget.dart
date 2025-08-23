
import 'package:flutter/material.dart';
import 'package:kothai_app/theme/figma_color.dart';
import 'package:kothai_app/theme/theme_manager.dart';
import 'package:kothai_app/widgets/CircularIconButton.dart';
import 'package:kothai_app/widgets/DifficultySegmentedButton.dart';

class PracticeSettingsWidget extends StatefulWidget {
    const PracticeSettingsWidget({super.key});

    @override
    State<PracticeSettingsWidget> createState() => _PracticeSettingsWidgetState();
}

class _PracticeSettingsWidgetState extends State<PracticeSettingsWidget> {
    Difficulty _selected = Difficulty.easy;

    void _updateDifficulty(Difficulty newValue) {
        setState(() {
                _selected = newValue;
            });
    }

    @override
    Widget build(BuildContext context) {
        final bgColor = getFigmaColor(context, 'Schemes/Background');
        final onSurfaceVariant = getFigmaColor(context, 'Schemes/On Surface Variant');

        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Container(
                        padding: const EdgeInsets.only(left: 14, right: 8, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                ),
                            ],
                        ),
                        child: Row(
                            children: [
                                Text(
                                    'Difficulty',
                                    style: AppTypography.bodyMedium.copyWith(
                                        color: onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                                const SizedBox(width: 7),
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: getFigmaColor(context, 'State Layers/On Background/Opacity-08'),
                                        borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                        children: Difficulty.values.map((difficulty) {
                                                final isActive = _selected == difficulty;
                                                return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                                    child: ElevatedButton(
                                                        onPressed: () => _updateDifficulty(difficulty),
                                                        style: ButtonStyle(
                                                            elevation: MaterialStateProperty.all(isActive ? 3 : 0),
                                                            backgroundColor: MaterialStateProperty.all(
                                                                isActive
                                                                    ? getFigmaColor(context, 'Schemes/On Background')
                                                                    : Colors.transparent,
                                                            ),
                                                            padding: MaterialStateProperty.all(
                                                                isActive
                                                                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                                                                    : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                            ),
                                                            minimumSize: MaterialStateProperty.all(Size.zero),
                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                            visualDensity: VisualDensity.compact,
                                                            shape: MaterialStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(24),
                                                                ),
                                                            ),
                                                        ),
                                                        child: Text(
                                                            difficulty.label,
                                                            style: AppTypography.bodyMedium.copyWith(
                                                                color: isActive
                                                                    ? bgColor
                                                                    : onSurfaceVariant,
                                                                fontWeight: FontWeight.w500,
                                                            ),
                                                        ),
                                                    ),
                                                );
                                            }).toList(),
                                    ),
                                ),
                            ],
                        ),
                    ),
                    const SizedBox(width: 5),
                    SvgCircularIconButton(
                        svgPath: 'assets/images/dice.svg',
                        onPressed: () => print('Dice tapped'),
                        backgroundColor: getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
                        size: 45,
                        iconSize: 24,
                    ),
                    const SizedBox(width: 5),
                    SvgCircularIconButton(
                        svgPath: 'assets/images/chevron_up.svg',
                        onPressed: () => print('Chevron tapped'),
                        backgroundColor: getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
                        size: 45,
                        iconSize: 10,
                    ),
                ],
            ),
        );
    }
}
