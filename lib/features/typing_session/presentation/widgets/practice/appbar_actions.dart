
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/level_xp_indicator.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/practice_stop_filled_button.dart';

List<Widget> appBarActions(
    ctx,
    bool practiceStatus,
    void Function() showNotifications,
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
        IconButton(
            padding: const EdgeInsets.all(11),
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    getFigmaColor(ctx, 'State Layers/On Surface/Opacity-08')
                ),
                shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                )
            ),
            onPressed: showNotifications,
            icon: Icon(
                FontAwesomeIcons.bell,
                size: KxScale(ctx).sp(18),
                color: getFigmaColor(ctx, 'Schemes/On Surface Variant')
            )
        ),
        const SizedBox(width: 16)
    ];
}
