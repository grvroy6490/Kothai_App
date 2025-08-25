

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/keyboard/Keyboard.dart';
import 'package:kothai_app/provider/StartStopPracticeModel.dart';
import 'package:kothai_app/theme/figma_color.dart';
import 'package:kothai_app/theme/theme_manager.dart';
import 'package:provider/provider.dart';

Widget CustomKeyboard({
    required BuildContext context,
    required Function(String) handleKeyPress,
}){
    final isPracticeRunning = context.watch<StartStopPracticeModel>().isPracticeRunning;

    return AnimatedPositioned(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        bottom: isPracticeRunning ? 0 : -MediaQuery.of(context).size.height,
        left: 0,
        right: 0,
        child: Stack(
            clipBehavior: Clip.none, // allows the -10 overflow to show
            children: [
                Container(
                    constraints: BoxConstraints(minHeight: 50),
                    padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                        top: 25
                    ),
                    decoration: BoxDecoration(
                        color: getFigmaColor(context, 'Schemes/Surface Container'),
                        border: Border(top: BorderSide(color: Colors.transparent)),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min, // keeps it only as tall as needed
                        children: [
                            Keyboard(onKeyPressed: handleKeyPress),
                        ],
                    ),
                ),
                Positioned(
                    left: 0, right: 0, top: -55, // <-- now width is constrained
                    child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20)
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                    getFigmaColor(context, 'Schemes/Surface Container'),
                                    getFigmaColor(context, 'Schemes/Surface Container').withAlpha(0),
                                ]
                            ),
                        ), 
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                _buildResetPauseButtons(context, FontAwesomeIcons.clockRotateLeft, 'Reset'),
                                _buildResetPauseButtons(context, FontAwesomeIcons.circlePause, 'Pause', flip: true),
                            ],
                        ),
                    ),
                ),

            ],
        )
    );
}


Widget _buildResetPauseButtons(BuildContext context, icon, label, {flip = false}){
    return FilledButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(getFigmaColor(context, 'Schemes/Surface Variant')),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
                horizontal: 12, vertical: 7
            )),
        ),
        onPressed: () => {
            context.read<StartStopPracticeModel>().stopPractice(),
        },
        child: Row(
            textDirection: flip ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
                Icon(
                    icon,
                    size: 18,
                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                ),
                Text(label,
                    style: AppTypography.bodyMedium.copyWith(
                        color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                        fontWeight: FontWeight.w500
                    ),
                )
            ],
        )
    );
}
