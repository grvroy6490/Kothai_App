
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/theme/figma_color.dart';

class PracticeAppBar extends StatefulWidget{
    const PracticeAppBar({super.key});

    @override
    State<PracticeAppBar> createState() => _PracticeAppBarState();
}

class _PracticeAppBarState extends State<PracticeAppBar> {

    late bool showXP;

    @override
    void initState() {
        super.initState();
        showXP = true;
    }

    @override
    Widget build(BuildContext ctx) {
        return AppBar(
            automaticallyImplyLeading: false,
            title: Text('Practice', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    color: getFigmaColor(ctx, 'Schemes/On Surface Variant')
                )
            ),
            actions: [
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                    // Stack current & previous so width is max of both
                    layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                            alignment: Alignment.centerRight, // or .centerLeft to pin the other side
                            children: <Widget>[
                                ...previousChildren,
                                if (currentChild != null) currentChild
                            ]
                        );
                    },
                    child: showXP ? Text('Show Xp Badge') : Text('Show Stop Button')
                ),
                SizedBox(width: 10),
                IconButton(
                    padding: const EdgeInsets.all(11),
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            getFigmaColor(context, 'State Layers/On Surface/Opacity-08')
                        ),
                        shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                        )
                    ),
                    onPressed: () {
                        setState(() {
                                showXP = !showXP;
                            });
                    },
                    icon: Icon(
                        FontAwesomeIcons.bell,
                        size: 20,
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    )
                ),
                SizedBox(width: 16)
            ]
        );
    }
}
