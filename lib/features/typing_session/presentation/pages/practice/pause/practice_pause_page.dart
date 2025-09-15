
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/pause/star_burst_badge.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/pause/stats_badge.dart';

class PracticePausePage extends StatefulWidget {
    const PracticePausePage({super.key});

    @override
    State<PracticePausePage> createState() => _PracticePausePageState();
}

class _PracticePausePageState extends State<PracticePausePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: Stack(
                children: [
                    Opacity(opacity: 0.5,
                        child: Image.asset('assets/images/Pattern.png',
                            width: double.infinity,
                            height: double.infinity
                        )
                    ),

                    SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Column(
                            children: [
                                Container(
                                    alignment: Alignment.topCenter,         // center the child horizontally
                                    child: SizedBox(
                                        width: Gap(context).gap(230),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(115),
                                                bottomRight: Radius.circular(115)
                                            ),
                                            child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                                child:  Container(
                                                    padding: EdgeInsets.only(
                                                        top: Gap(context).gap(20),
                                                        left: Gap(context).gap(16),
                                                        right: Gap(context).gap(16),
                                                        bottom: Gap(context).gap(40)
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: getFigmaColor(context, 'State Layers/Error/Opacity-08').withAlpha(20),

                                                        borderRadius: const BorderRadius.only(
                                                            bottomLeft: Radius.circular(115),
                                                            bottomRight: Radius.circular(115)
                                                        ),
                                                        border: Border.all(
                                                            color: Colors.white.withOpacity(0.2), // subtle glass edge
                                                            width: 1.5
                                                        )
                                                    ),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            StatsBadge(
                                                                bgColor: getFigmaColor(
                                                                    context, 'State Layers/Background/Opacity-60'),
                                                                icon: Icons.text_fields,
                                                                label: 'WPM',
                                                                value: '45'
                                                            ),
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            StatsBadge(
                                                                bgColor: getFigmaColor(
                                                                    context, 'State Layers/Background/Opacity-60'),
                                                                icon: Icons.my_location,
                                                                label: 'Accuracy',
                                                                value: '45%'
                                                            ),
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            StatsBadge(
                                                                bgColor: getFigmaColor(
                                                                    context, 'State Layers/Background/Opacity-60'),
                                                                icon: FontAwesomeIcons.clock,
                                                                label: 'Time',
                                                                value: '1m 2s'
                                                            ),
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            StatsBadge(
                                                                bgColor: getFigmaColor(
                                                                    context, 'State Layers/Background/Opacity-60'),
                                                                icon: Icons.rotate_right,
                                                                label: 'Progress',
                                                                value: '98%'
                                                            ),
                                                            SizedBox(height: Gap(context).gap(15)),
                                                            _iconLabelButton(
                                                                context,
                                                                color: getFigmaColor(context, 'Schemes/Error'),
                                                                label: 'Stop this Practice',
                                                                icon: Icons.front_hand,
                                                                tapBehavior: () {

                                                                }
                                                            )
                                                        ]
                                                    )

                                                )
                                            )
                                        )
                                    )
                                ),

                                Spacer(),

                                // START BURST
                                SizedBox(
                                    width: double.infinity,
                                    height: Gap(context).gap(180),
                                    child: StarburstBadge(
                                        size: Gap(context).gap(180),
                                        spikes: 20,           // try 16–24 for different scallops
                                        innerRatio: 0.78,
                                        starColor: getFigmaColor(context, 'State Layers/Primary/Opacity-08'),// closer to 1.0 = less spiky
                                        onTap: () {
                                        },
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                // play button
                                                Container(
                                                    width: Gap(context).gap(55),
                                                    height: Gap(context).gap(55),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: getFigmaColor(context, 'Schemes/Primary') // deep indigo
                                                    ),
                                                    child: Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.white,
                                                        size: KxScale(context).sp(40)
                                                    )
                                                ),
                                                SizedBox(height: Gap(context).gap(10)),
                                                // “Resume” (underlined)
                                                Text(
                                                    'Resume',
                                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                        color: getFigmaColor(context, 'Schemes/Primary')
                                                    )
                                                )
                                            ]
                                        )
                                    )

                                ),

                                Spacer(),

                                SizedBox(
                                    width: Gap(context).gap(230),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(115),
                                            topRight: Radius.circular(115)
                                        ),
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                            child: Container(
                                                width: Gap(context).gap(230),
                                                padding: EdgeInsets.only(
                                                    bottom: Gap(context).gap(16),
                                                    left: Gap(context).gap(16),
                                                    right: Gap(context).gap(16),
                                                    top: Gap(context).gap(40)
                                                ),
                                                decoration: BoxDecoration(
                                                    color: getFigmaColor(context, 'State Layers/Error/Opacity-08').withAlpha(20),
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(115),
                                                        topRight: Radius.circular(115)
                                                    )
                                                ),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        _iconLabelButton(
                                                            context,
                                                            color: getFigmaColor(context, 'Schemes/Secondary'),
                                                            label: 'Reset Progress',
                                                            icon: FontAwesomeIcons.clockRotateLeft,
                                                            tapBehavior: ()  {
                                                            }
                                                        ),
                                                        SizedBox(height: Gap(context).gap(20))
                                                    ]
                                                )
                                            )
                                        )
                                    )
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }

    Widget _iconLabelButton(
        BuildContext context,
        {
            required String label,
            required IconData icon,
            required Color color,
            void Function()? tapBehavior
        }
    ){
        return GestureDetector(
            onTap: tapBehavior,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Icon(icon,
                        color: color,
                        size: KxScale(context).sp(17)
                    ),
                    SizedBox(height: Gap(context).gap(10)),
                    Text(label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500
                        )
                    )
                ]
            )
        );

    }
}
