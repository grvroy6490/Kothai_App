import 'package:flutter/material.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MetricsInfoBadge extends StatelessWidget {

    IconData? icon;
    String? value;
    String? label;

    MetricsInfoBadge({
        super.key,
        this.icon,
        this.label,
        this.value
    });

    @override
    Widget build(BuildContext context) {

        // ⭐ Widget ---------------------------------
        return Container(
            decoration: BoxDecoration(
                color: getFigmaColor(context, 'Schemes/Surface Container Highest'),
                borderRadius: BorderRadius.circular(100)
            ),
            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(12)),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Icon(
                                    icon ?? Icons.text_fields,
                                    size: KxScale(context).sp(12),
                                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                ),
                                SizedBox(width: Gap(context).gap(5)),
                                Flexible(
                                    child: AutoSizeText(label ?? '',
                                        maxLines: 2,
                                        wrapWords: true,
                                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            letterSpacing: 0.1,
                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                        )
                                    )
                                )
                            ]
                        ),

                        SizedBox(height: Gap(context).gap(3)),
                        FittedBox(
                            fit: BoxFit.fill,
                            child: Text(value ?? '',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: getFigmaColor(context, 'Schemes/On Surface'),
                                    fontWeight: FontWeight.bold
                                )
                            )
                        )
                    ]
                )
            )
        );
    }
}