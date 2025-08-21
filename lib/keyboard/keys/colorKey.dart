import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/keyboard/keys/kothaiKey.dart';

class Colorkey extends StatelessWidget {
    final dynamic data;
    final Color? bgColor;
    final Color? color;
    final VoidCallback? onPressed;

    const Colorkey({
        super.key,
        required this.data,
        this.bgColor,
        this.color,
        this.onPressed,
    });

    @override
    Widget build(BuildContext context) {
        Widget child;

        if (data is String) {
            child = Text(
                data,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: color ?? Colors.black,
                    fontFamily: 'NotoSansTamil',
                    height: 1,
                ),
            );
        } else if (data is IconData) {
            child = Icon(data, size: 18, color: color ?? Colors.black);
        } else {
            child = Icon(FontAwesomeIcons.question, size: 18, color: color ?? Colors.black);
        }

        return KothaiKey(
            height: 40,
            background: bgColor,
            onPressed: onPressed,
            child: child,
        );
    }
}
