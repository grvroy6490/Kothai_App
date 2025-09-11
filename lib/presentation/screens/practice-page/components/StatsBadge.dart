

import 'package:flutter/material.dart';
import 'package:kothai_app/presentation/theme/app_typography.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';

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
                minWidth: 250
            ),
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 12
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: bgColor ?? getFigmaColor(context, 'State Layers/Background/Opacity-60'),
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Icon(icon, size: 16, color: getFigmaColor(context, 'Schemes/On Surface Variant'),),
                    SizedBox(width: 10,),
                    Text(label,
                        style: AppTypography.bodyLarge.copyWith(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                        )
                    ),
                    Expanded(child: SizedBox(width: 70,)),
                    Text(value,
                        style: AppTypography.titleMedium.copyWith(
                            color: getFigmaColor(context, 'Schemes/Primary'),
                            fontWeight: FontWeight.w700
                        ),
                    )
                ],
            ),
        );
    }
}
