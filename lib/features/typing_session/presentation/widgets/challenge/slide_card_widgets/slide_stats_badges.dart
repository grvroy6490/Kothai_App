import 'package:flutter/material.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';


class SlideStatsBadge extends StatefulWidget {
    final IconData icon;
    final String data;
    final String label;

    const SlideStatsBadge({
        super.key,
        required this.icon,
        required this.data,
        required this.label
    });

    @override
    State<SlideStatsBadge> createState() => _SlideStatsBadgeState();
}

class _SlideStatsBadgeState extends State<SlideStatsBadge> {
    // 📃 DECLARATION ----------------------------
    final _gradientColor = [
        Color.fromARGB(255, 254, 239, 208),
        Color.fromARGB(255, 252, 213, 135)
    ];

    @override
    Widget build(BuildContext context) {

        // ⭐ Widget ---------------------------------
        return Container(
            padding: EdgeInsets.symmetric(
                vertical: Gap(context).gap(5),
                horizontal: Gap(context).gap(8)
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(51, 0, 0, 0),
                borderRadius: BorderRadius.circular(16)
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                            colors: _gradientColor,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                        ).createShader(bounds),
                        child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: KxScale(context).sp(16)
                        )
                    ),

                    Padding(
                        padding: EdgeInsets.only(
                            left: Gap(context).gap(10)
                        ),
                        child: Text(widget.data,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: getFigmaColor(context, 'Fixed/White Fixed'),
                                fontWeight: FontWeight.bold
                            )
                        )
                    ),

                    Padding(
                        padding: EdgeInsets.only(
                            left: Gap(context).gap(10),
                            right: Gap(context).gap(5)
                        ),
                        child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: _gradientColor
                            ).createShader(bounds),
                            child: Text(
                                widget.label,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white, // must be white for gradient to show
                                    fontWeight: FontWeight.w600
                                )
                            )
                        )
                    )
                ]
            )
        );
    }
}