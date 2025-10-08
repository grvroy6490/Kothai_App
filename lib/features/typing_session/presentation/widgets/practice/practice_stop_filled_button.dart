import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_handler_provider.dart';


class PracticeStopFilledButton extends ConsumerWidget {
    TextEditingController controller;
    PracticeStopFilledButton({super.key, required this.controller});

    @override
    Widget build(BuildContext context, ref) {
        // 🌐 PROVIDERS ------------------------------
        final sessionController = ref.read(sessionHandlerControllerProvider.notifier);


        // ⭐ Widget ---------------------------------
        return FilledButton.icon(
            onPressed: (){
                sessionController.reset();
                controller.clear();
            },
            label: Text('Stop Practice',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: getFigmaColor(context, 'Schemes/Error')
                )
            ),
            icon: Icon(FontAwesomeIcons.solidCircleStop, size: Gap(context).gap(16)),
            style: ButtonStyle(
                iconColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'Schemes/Error')),
                backgroundColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'State Layers/Error/Opacity-08'))
            )
        );
    }
}