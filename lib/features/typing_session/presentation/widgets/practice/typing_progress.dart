
import 'package:flutter/material.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class TypingProgress extends StatefulWidget {
    double width;
    TypingProgress({super.key, required this.width});

    @override
    State<TypingProgress> createState() => _TypingProgressState();
}

class _TypingProgressState extends State<TypingProgress> {
    @override
    Widget build(BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            decoration: BoxDecoration(
                color: getFigmaColor(context, 'Schemes/Surface Container Highest'),
                borderRadius: BorderRadius.circular(24)
            ),
            clipBehavior: Clip.hardEdge,
            child:  Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                    widthFactor: widget.width,
                    child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                    getFigmaColor(context, 'Palettes/Secondary 80'),
                                    getFigmaColor(context, 'Palettes/Primary 60')
                                ]
                            ),
                            borderRadius: BorderRadius.circular(0)
                        )
                    )
                )
            )

        );
    }
}
