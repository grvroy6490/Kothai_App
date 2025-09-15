
import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class MetricsStatBadge extends StatelessWidget {
    Color? bgColor;
    IconData? icon;
    String? label;
    String? value;
    MetricsStatBadge({
      super.key,
      this.bgColor,
      this.icon,
      this.value,
      this.label
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: bgColor ?? getFigmaColor(context, 'State Layers/On Background/Opacity-08')
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Icon(icon ?? Icons.text_fields, size: KxScale(context).sp(14), color: getFigmaColor(context, 'Schemes/Primary')),
                                SizedBox(width: Gap(context).gap(10)),
                                Text(value ?? '0',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/Primary')
                                    )
                                ),
                            ]
                        ),
                        SizedBox(height: Gap(context).gap(5)),
                        SizedBox(
                            child: Text(label ?? '',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                )
                            )
                        )
                    ]
                )
            )
<<<<<<< HEAD
        );;
=======
        );
>>>>>>> 12fa72b (updated IOS build)
    }
}
