import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/enums/PracticeStatusEnum.dart';
import 'package:kothai_app/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';

class TypingProgressBar extends ConsumerStatefulWidget {
    double width;
    TypingProgressBar({super.key, required this.width});

    @override
    ConsumerState<TypingProgressBar> createState() => _TypingProgressBarState();
}

class _TypingProgressBarState extends ConsumerState<TypingProgressBar> {

    @override
    Widget build(BuildContext context) {
        final practiceStatus = ref.watch(practiceStatusProvider);

        return Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            decoration: BoxDecoration(
                color: practiceStatus == PracticeStatus.start ? Colors.transparent : getFigmaColor(context, 'Schemes/Surface Container Highest'),
                borderRadius: BorderRadius.circular(55),
            ),
            clipBehavior: Clip.hardEdge,
            child:  practiceStatus == PracticeStatus.start ? Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                        widthFactor: widget.width,
                        child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                        getFigmaColor(context, 'Palettes/Secondary 80'),
                                        getFigmaColor(context, 'Palettes/Primary 60'),
                                    ],
                                ),
                                borderRadius: BorderRadius.circular(0),
                            ),
                        ),
                    ),
                ) : Container(),
        );
    }
}
