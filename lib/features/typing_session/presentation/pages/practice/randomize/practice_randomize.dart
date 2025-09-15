
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/practice/pause/star_burst_badge.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PracticeRandomizePage extends StatefulWidget {
    const PracticeRandomizePage({super.key});

    @override
    State<PracticeRandomizePage> createState() => _PracticeRandomizePageState();
}

class _PracticeRandomizePageState extends State<PracticeRandomizePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: Stack(
                children: [

                    Positioned.fill(
                        child: Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                'assets/images/Pattern.png',
                                fit: BoxFit.cover,               // 👈 scales to cover screen
                                filterQuality: FilterQuality.high
                            )
                        )
                    ),

                    SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                            children: [
                                Expanded(child: Container()),

                                SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                        child: Stack(
                                            clipBehavior: Clip.hardEdge,
                                            alignment: Alignment.center,
                                            children: [
                                                Opacity(
                                                    opacity: 0.6,
                                                    child: StarburstBadge(
                                                        spikes: 16,
                                                        innerRatio: 0.89,
                                                        size: MediaQuery.of(context).size.width * 0.8,
                                                        starColor: getFigmaColor(context, 'State Layers/On Background/Opacity-08'),
                                                        child: const SizedBox.shrink() // or any inner content
                                                    )
                                                ),

                                                SizedBox(
                                                    width: Gap(context).gap(130),
                                                    height: Gap(context).gap(130),
                                                    child: Image.asset('assets/images/dice-game.png')
                                                )
                                            ]
                                        )
                                    )

                                ),

                                SizedBox(height: Gap(context).gap(30)),

                                Text('Randomize...',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface')
                                    )
                                ),

                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0),
                                    child: LoadingAnimationWidget.progressiveDots(
                                        color: getFigmaColor(context, 'Schemes/On Surface'),
                                        size: Gap(context).gap(50)
                                    )
                                ),

                                Spacer(),

                                SizedBox(
                                    width: Gap(context).gap(230),
                                    height: Gap(context).gap(150),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(150)
                                        ), // optional
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                            child: GestureDetector(
                                                onTap: (){
                                                    // TODO: HANLDE TAP
                                                },
                                                child: Container(
                                                    // make it translucent so the blur is visible
                                                    color: getFigmaColor(context, 'State Layers/Secondary/Opacity-08'),
                                                    padding: EdgeInsets.all(Gap(context).gap(16)),
                                                    child: Column(
                                                        children: [
                                                            CloseButton(
                                                                color: getFigmaColor(context, 'Schemes/Secondary'),
                                                                style: ButtonStyle(
                                                                    iconSize: WidgetStateProperty.all(KxScale(context).sp(25))
                                                                )
                                                            ),

                                                            Text('Close', style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: getFigmaColor(context, 'Schemes/Secondary'),
                                                                    fontWeight: FontWeight.w600
                                                                )
                                                            )
                                                        ]
                                                    )
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

}
