

import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class StatsBadge extends StatelessWidget {
    final Color bgColor;
    final IconData icon;
    final String label;
    final String value;

    const StatsBadge({
        super.key,
        required this.bgColor,
        required this.icon,
        required this.label,
        required this.value
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            constraints: BoxConstraints(
                minWidth: Gap(context).gap(250)
            ),
            padding: EdgeInsets.symmetric(
                horizontal: Gap(context).gap(20), vertical: Gap(context).gap(10)
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: bgColor ?? getFigmaColor(context, 'State Layers/Background/Opacity-60')
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Expanded(
                        child: Row(
                            children: [
                                Icon(icon, size: KxScale(context).sp(16), color: getFigmaColor(context, 'Schemes/On Surface Variant')),
                                SizedBox(width: Gap(context).gap(10)),
                                Expanded(
                                    child: Text(label,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                        )
                                    )
                                )
                            ]
                        )
                    ),
                    SizedBox(
                        width: Gap(context).gap(10)
                    ),
                    Text(value,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: getFigmaColor(context, 'Schemes/Primary'),
                            fontWeight: FontWeight.w700
                        )
                    )
                ]
            )
        );
    }
}
