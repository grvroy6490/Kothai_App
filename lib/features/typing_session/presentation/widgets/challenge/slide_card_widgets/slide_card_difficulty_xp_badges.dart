import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class SlideCardDifficultyXpBadges extends StatelessWidget {
    final String xp;
    final String difficulty;

    const SlideCardDifficultyXpBadges({
        super.key,
        required this.xp,
        required this.difficulty
    });

    @override
    Widget build(BuildContext context) {

        // ⭐ Widget ---------------------------------
        return Row(
            children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Gap(context).gap(2),
                        horizontal: Gap(context).gap(5)
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(51, 0, 0, 0),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Row(
                        children: [
                            SvgPicture.asset('assets/images/Gold_Icon.svg',
                                width: Gap(context).gap(16)
                            ),

                            Padding(
                                padding: EdgeInsets.all(Gap(context).gap(5)),
                                child: Text('${xp} XP',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: getFigmaColor(context, 'Fixed/White Fixed')
                                    )
                                )
                            )
                        ]
                    )
                ),

                SizedBox(width: 5),
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Gap(context).gap(2),
                        horizontal: Gap(context).gap(5)
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(51, 0, 0, 0),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(Gap(context).gap(5)),
                        child: Text(difficulty,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: getFigmaColor(context, 'Fixed/White Fixed')
                            )
                        )
                    )
                )
            ]
        );
    }
}