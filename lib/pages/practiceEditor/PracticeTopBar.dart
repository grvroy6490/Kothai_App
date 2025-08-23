
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/theme/figma_color.dart';
import 'package:kothai_app/theme/theme_manager.dart';
import 'package:kothai_app/widgets/Level_XP_Badge.dart';


Widget BuildPracticeTopBar(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text('Practice',
                        style: AppTypography.titleLarge.copyWith(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                            fontWeight: FontWeight.w400,
                        )
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 4,
                        children: [
                            LevelXP_Badge(),

                            IconButton(
                                padding: EdgeInsets.all(11),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        getFigmaColor(context, 'State Layers/On Surface/Opacity-08')
                                    ),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                        )
                                    )
                                ),
                                onPressed: () => {},
                                icon: Icon(
                                    FontAwesomeIcons.bell,
                                    size: 20,
                                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                )
                            ),

                        ],
                    )
                ],
            ),
        )
    );
}
