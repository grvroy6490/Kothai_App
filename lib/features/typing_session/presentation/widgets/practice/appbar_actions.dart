
import 'package:flutter/material.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/notifications/presentation/widgets/notification_bell_button.dart';
import 'package:visai/features/typing_session/presentation/widgets/level_xp_indicator.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/practice_stop_filled_button.dart';

List<Widget> appBarActions(
    ctx,
    bool practiceStatus,
    TextEditingController controller,
) {
    return [
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
            // keep the larger of the two children visible width-wise
            layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                    alignment: Alignment.centerRight,
                    children: [
                        ...previousChildren,
                        if (currentChild != null) currentChild
                    ]
                );
            },
            child: practiceStatus
                ? LevelXPIndicatior(isCompact: true)
                : PracticeStopFilledButton(controller: controller)
        ),
        const SizedBox(width: 5),
        const NotificationBellIconButton(),
        const SizedBox(width: 16)
    ];
}
