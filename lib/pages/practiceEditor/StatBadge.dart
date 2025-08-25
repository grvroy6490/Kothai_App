
import 'package:flutter/material.dart';
import 'package:kothai_app/theme/figma_color.dart';
import 'package:kothai_app/theme/theme_manager.dart';

Widget StatBadge({
    required BuildContext context,
    required String label,
    required String value,
    IconData icon = Icons.text_fields,
}) {
    return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
        ),
        decoration: BoxDecoration(
            color: getFigmaColor(context, 'Schemes/Surface Container Highest'),
            borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Icon(
                            icon,
                            size: 14,
                            color: getFigmaColor(context, 'Schemes/Primary'),
                        ),
                        SizedBox(width: 3),
                        Text(label,
                            style: AppTypography.labelMedium.copyWith(
                                color: getFigmaColor(context, 'Schemes/Primary'),
                            )
                        ),
                    ],
                ),
                SizedBox(height: 5),
                FittedBox(
                    fit: BoxFit.fill,
                    child: Text(value,
                        style: AppTypography.labelMedium.copyWith(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                            fontWeight: FontWeight.w600,
                        )
                    ),
                )
            ],
        ),
    );
}