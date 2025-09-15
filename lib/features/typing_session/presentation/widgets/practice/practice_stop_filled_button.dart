
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practice_status_provider.dart';


class PracticeStopFilledButton extends ConsumerWidget {
    const PracticeStopFilledButton({super.key});

    @override
    Widget build(BuildContext context, ref) {

        return FilledButton.icon(
            onPressed: (){
                ref.read(practiceStatusProvider.notifier).stopPractice();
            },
            label: Text('Stop Practice',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: getFigmaColor(context, 'Schemes/Error')
                )
            ),
            icon: Icon(FontAwesomeIcons.solidCircleStop),
            style: ButtonStyle(
                iconColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'Schemes/Error')),
                backgroundColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'State Layers/Error/Opacity-08'))
            )
        );
    }
}
