
import 'package:flutter/material.dart';
import 'package:visai/presentation/theme/app_typography.dart';
import 'package:visai/presentation/theme/figma_color.dart';

class InfoBadge extends StatelessWidget {

    IconData icon;
    String label;
    String value;

    InfoBadge({super.key, required this.icon, required this.label, required this.value});

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8,
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
                                size: 12,
                                color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                                child: Text(label,
                                    style: AppTypography.labelMedium.copyWith(
                                      letterSpacing: 0.1,
                                        color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                    )
                                ),
                            )
                        ],
                    ),
                    SizedBox(height: 3),
                    FittedBox(
                        fit: BoxFit.fill,
                        child: Text(value,
                            style: AppTypography.labelLarge.copyWith(
                                color: getFigmaColor(context, 'Schemes/On Surface'),
                                fontWeight: FontWeight.bold,
                            )
                        ),
                    )
                ],
            ),
        );
    }
}
