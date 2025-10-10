import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/session/stop/session_stop_page.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';


class PracticeStopFilledButton extends ConsumerWidget {
    TextEditingController controller;
    PracticeStopFilledButton({super.key, required this.controller});

    @override
    Widget build(BuildContext context, ref) {
        // 🌐 PROVIDERS ------------------------------

        // 🚀 METHODS --------------------------------
        void handleStop() {
            Get.to(
                () => const SessionStopPage(),
                arguments: {
                    'route': Get.currentRoute,
                    'controller': controller,
                },
                transition: Transition.fadeIn,
                curve: Curves.easeInOutQuad,
            );
        }

        // ⭐ Widget ---------------------------------
        return FilledButton.icon(
            onPressed: () => handleStop(),
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
