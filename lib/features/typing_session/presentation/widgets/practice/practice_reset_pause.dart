import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';

class PracticeResetPause extends ConsumerWidget {
    void Function(TextEditingController) handlePause;
    void Function(TextEditingController) handleReset;
    final TextEditingController controller;
    PracticeResetPause({super.key, required this.handlePause, required this.handleReset, required this.controller});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        // 📃 DECLARATION ----------------------------

        // 🌐 PROVIDERS ------------------------------
        final practiceConfig = ref.watch(practiceConfigurationProvider);
        final sessionState = ref.watch(sessionStatusControllerProvider);

        // 🚀 METHODS ---------------------------------

        // ⭐ Widget --------------------------------------
        return Container(
            width: double.infinity,
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
                        getFigmaColor(context, 'Schemes/Background').withAlpha(0)
                    ]
                )
            ),
            padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(16), vertical: Gap(context).gap(5)),
            child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Expanded(
                        flex: 2,
                        child: _buildResetPauseButtons(
                            context,
                            icon: Icons.restore,
                            label: 'Reset',
                            handlePressed: () => handleReset(controller)
                        )
                    ),
                    Expanded(
                        flex: sessionState.mode == SessionMode.practice ? 3 : 5,
                        child: Text('')
                    ),

                    if(sessionState.mode == SessionMode.practice)
                    Expanded(
                        flex: 2,
                        child: practiceConfig.allowPauses // 👈 ALLOW PAUSES SETTINGS
                            ? _buildResetPauseButtons(
                                context,
                                icon: Icons.pause_circle,
                                label: 'Pause',
                                flip: true,
                                handlePressed: () => handlePause(controller)
                            ) : Text('')

                    )
                ]
            )
        );
    }

    Widget _buildResetPauseButtons(BuildContext context, {icon, label, Function()? handlePressed, flip = false}){
        return FilledButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'Schemes/Surface Variant')),
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
                        horizontal: Gap(context).gap(12), vertical: Gap(context).gap(7)
                    ))
            ),
            onPressed: handlePressed,
            child: Row(
                textDirection: flip ? TextDirection.rtl : TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: Gap(context).gap(10),
                children: [
                    Icon(
                        icon,
                        size: KxScale(context).sp(18),
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    ),
                    Text(label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                            fontWeight: FontWeight.w500
                        )
                    )
                ]
            )
        );
    }
}