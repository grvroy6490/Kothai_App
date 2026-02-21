import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visai/presentation/providers/session/session_state_provider.dart';
import 'package:visai/presentation/theme/app_typography.dart';
import 'package:visai/presentation/theme/figma_color.dart';

class PracticeResetPauseSettings extends ConsumerWidget {
    const PracticeResetPauseSettings({super.key});

    @override
    Widget build(BuildContext context, ref) {
        return Container(
            padding: EdgeInsets.symmetric(
                horizontal: 16, vertical: 10
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
                ),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                        getFigmaColor(context, 'Schemes/Background'),
                        getFigmaColor(context, 'Schemes/Background').withAlpha(0),
                    ]
                ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    _buildResetPauseButtons(
                        context,
                        icon: FontAwesomeIcons.clockRotateLeft,
                        label: 'Reset',
                        handlePressed: () => {
                            //TODO: Reset the practice session
                            print('working'),
                        }
                    ),
                    _buildResetPauseButtons(
                        context,
                        icon: FontAwesomeIcons.circlePause,
                        label: 'Pause',
                        ref: ref,
                        flip: true,
                        handlePressed: () => {
                            ref.read(sessionStateProvider.notifier).pause(),
                        }
                    ),
                ],
            ),
        );
    }
}


Widget _buildResetPauseButtons(BuildContext context, {icon, label, WidgetRef? ref, Function()? handlePressed, flip = false}){
    return FilledButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'Schemes/Surface Variant')),
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7
                )),
        ),
        onPressed: handlePressed,
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
