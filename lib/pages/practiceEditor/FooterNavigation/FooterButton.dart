
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/theme/figma_color.dart';


class FooterNavButton extends StatelessWidget {
    final String label;
    final IconData icon;
    final VoidCallback? onPressed;
    final bool isActive;
    final BuildContext context;

    const FooterNavButton({
        super.key,
        required this.label,
        required this.icon,
        this.onPressed,
        this.isActive = false,
        required this.context,
    });

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: onPressed,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 5,
                        ),
                        decoration: BoxDecoration(
                            color: isActive ? getFigmaColor(context, 'State Layers/On Primary Container/Opacity-08')
                            : getFigmaColor(context, 'State Layers/On Primary Container/Opacity-08').withAlpha(0),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Icon(
                            icon,
                            color: isActive ? getFigmaColor(context, 'Schemes/Primary')
                                : getFigmaColor(context, 'Schemes/On Background').withAlpha(127),
                            size: 19,
                        ),
                    ),
                    SizedBox(height: 3,),
                    Text(
                        label,
                        style: TextStyle(
                            color: isActive ? getFigmaColor(context, 'Schemes/Primary')
                                : getFigmaColor(context, 'Schemes/On Background').withAlpha(127),
                            fontSize: 12
                        )
                    )
                ],
            ),
        );
    }
}
