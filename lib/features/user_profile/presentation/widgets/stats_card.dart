import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class StatCard extends StatelessWidget {
    final String value;
    final String label;
    final IconData icon;

    const StatCard({
        super.key,
        required this.value,
        required this.label,
        required this.icon
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            padding:  EdgeInsets.symmetric(
              horizontal: Gap(context).gap(8),
              vertical: Gap(context).gap(10)
            ),
            decoration: BoxDecoration(
                color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                borderRadius: BorderRadius.circular(16)
                // boxShadow: [
                //     BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                // ]
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Expanded(
                                child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface')
                                    )
                                )
                            ),
                            const SizedBox(width: 6),
                            Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: getFigmaColor(context, 'State Layers/On Primary Container/Opacity-08'),
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Icon(icon, color: Colors.deepPurple, size: 18)
                            )
                        ]
                    ),
                    const SizedBox(height: 10),
                    Text(
                        label,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                        )
                    )
                ]
            )
        );
    }
}
