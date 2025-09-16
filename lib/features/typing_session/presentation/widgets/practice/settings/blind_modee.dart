
import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/entities/practice/practice_config.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/settings/switch_button.dart';

Widget blindMode(
    BuildContext context,
    PracticeConfig config,
    void Function(PracticeConfig) updateConfiguration
    ){
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: getFigmaColor(context, 'State Layers/On Background/Opacity-08'),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12), right: Radius.circular(12))
        ),
        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(10), vertical: Gap(context).gap(5)),
        child: Row(
            children: [
                Icon(
                    Icons.visibility_off,
                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                    size: 20
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                'Blind Mode',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: getFigmaColor(
                                        context,
                                        'Schemes/On Surface Variant'
                                    ),
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                    'No errors or incorrect words are highlighted.',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: getFigmaColor(
                                            context,
                                            'Schemes/On Surface Variant'
                                        ),
                                        fontWeight: FontWeight.w500
                                    )
                                )
                            )
                        ]
                    )
                ),
                SizedBox(width: 10),
                switchButton(context, config.blindMode, (_) => updateConfiguration(config.copyWith(blindMode: !config.blindMode)))
            ]
        )
    );
}
