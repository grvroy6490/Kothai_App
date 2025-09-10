
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kothai_app/presentation/theme/app_typography.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';


class LevelXP_Indicatior extends StatefulWidget {
    const LevelXP_Indicatior({super.key});

    @override
    State<LevelXP_Indicatior> createState() => _LevelXP_IndicatiorState();
}

class _LevelXP_IndicatiorState extends State<LevelXP_Indicatior> {
    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 1.0, color: getFigmaColor(context, 'State Layers/On Surface/Opacity-10'))
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
                children: [
                    //Background Progress Bar
                    // Background Progress Bar
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                                widthFactor: 0.01, // 60% progress, adjust as needed
                                child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                                getFigmaColor(context, 'Palettes/Secondary 90'),
                                                getFigmaColor(context, 'Palettes/Primary 80'),
                                            ],
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                    ),
                                ),
                            ),
                        ),
                    ),

                    // Foreground Container
                    Container(
                        padding: EdgeInsets.only(
                            left: 5,
                            right: 10,
                            top: 3,
                            bottom: 3
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Stack(
                                        children: [
                                            SvgPicture.asset('assets/images/Gold_Icon.svg',
                                                width: 20,
                                            )
                                        ],
                                    )
                                ),

                                Text('Level 1',
                                    style: AppTypography.labelLarge.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                    )
                                ),
                                Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.white,
                                ),
                                Text('0 XP',
                                    style: AppTypography.labelLarge.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                    )
                                )
                            ],
                        ),
                    )
                ],
            )
        );
    }
}
