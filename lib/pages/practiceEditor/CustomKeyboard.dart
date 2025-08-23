

import 'package:flutter/material.dart';
import 'package:kothai_app/keyboard/Keyboard.dart';
import 'package:kothai_app/provider/StartStopPracticeModel.dart';
import 'package:provider/provider.dart';

Widget CustomKeyboard({
    required BuildContext context,
    required Function(String) handleKeyPress,
}){
    final isRunning = context.watch<StartStopPracticeModel>().isPracticeRunning;

    return AnimatedPositioned(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        bottom: isRunning ? 0 : -MediaQuery.of(context).size.height,
        left: 0,
        right: 0,
        child: Container(
            constraints: BoxConstraints(minHeight: 50),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 233, 234, 238),
                border: Border(
                    top: BorderSide(color: Colors.black12),
                ),
            ),
            child: Keyboard(
                onKeyPressed: handleKeyPress,
            ),
        ),
    );
}