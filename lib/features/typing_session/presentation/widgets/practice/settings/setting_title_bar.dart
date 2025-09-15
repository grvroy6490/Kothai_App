import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';


Widget settingsTitleBar(context){
    return Container(
        color: getFigmaColor(context, 'State Layers/On Background/Opacity-08'),
        padding: EdgeInsets.symmetric(
            horizontal: Gap(context).gap(16),
            vertical: Gap(context).gap(10)
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Expanded(
                    child: Row(
                        children: [
                            Icon(
                                FontAwesomeIcons.gear,
                                color: getFigmaColor(context, 'Schemes/On Surface'),
                                size: Gap(context).gap(18)
                            ),
                            SizedBox(width: Gap(context).gap(8)),
                            Text(
                                'Test Settings',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: getFigmaColor(context, 'Schemes/On Surface')
                                )
                            )
                        ]
                    )
                ),
                Spacer(),
                Flexible(
                    child: IconButton(
                        onPressed: () {
                            Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: getFigmaColor(context, 'Schemes/On Surface'),
                            size: Gap(context).gap(15)
                        )
                    )
                )
            ]
        )
    );
}


