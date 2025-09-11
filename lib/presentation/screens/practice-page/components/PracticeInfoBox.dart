import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/domain/entities/session/session_state.dart';
import 'package:kothai_app/enums/difficulty/DifficultyWPM.dart';
import 'package:kothai_app/enums/PracticeStatusEnum.dart';
import 'package:kothai_app/presentation/providers/content/text_provider.dart';
import 'package:kothai_app/presentation/providers/session/difficulty_provider.dart';
import 'package:kothai_app/presentation/providers/session/session_selector.dart';
import 'package:kothai_app/presentation/providers/session/session_state_provider.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/InfoBadge.dart';
import 'package:kothai_app/presentation/screens/practice-page/components/StatBadge.dart';
import 'package:kothai_app/presentation/providers/practice/practice_status_provider.dart';
import 'package:kothai_app/presentation/theme/figma_color.dart';
import 'package:kothai_app/presentation/shared/toast.dart';

class PracticeInfoBox extends ConsumerStatefulWidget {
    const PracticeInfoBox({super.key});

    @override
    ConsumerState<PracticeInfoBox> createState() => _PracticeInfoBoxState();
}

class _PracticeInfoBoxState extends ConsumerState<PracticeInfoBox> {
    late bool showToast;
    String wordsCount = '0 (~0 Character)';
    String avgTime = '~0 mins 0 secs';
    DifficultyWPMEnum wpm = DifficultyWPMEnum.wpmEasy;

    @override
    void initState() {
        super.initState();
        showToast = true;
    }

    void handleShowToast() {
        setState(() {
                showToast = true;
            });
        Future.delayed(const Duration(milliseconds: 10000), () {
                if (mounted) {
                    setState(() {
                            showToast = false;
                        });
                }
            });
    }

    void hideToast() {
      print('not working');
        setState(() {
                showToast = false;
            });
    }

    @override
    Widget build(BuildContext context) {
        // Generate contents parameters
        final practiceStatus = ref.watch(practiceStatusProvider);
        wpm = ref.watch(difficultyNotifierProvider).wpmThreshold;


        // Session state
        final sessionState = ref.watch(sessionStateProvider);
        ref.listen(textContentProvider, (prev, next) {
                if (next != null && next != prev) {
                    setState(() {
                            showToast = true;
                            wordsCount = '${next.content.split(' ').length} (~${(next.content.length / 5).round()} Character)';
                            avgTime = '~${(next.content.split(' ').length / 40).round()} mins ${(next.content.split(' ').length % 40 * 1.5).round()} secs';
                        });
                }
            });

        final s = ref.watch(sessionStateProvider);
        final wpmValue = ref.watch(sessionWpmProvider);

        return Container(
            width: MediaQuery.of(context).size.width,
            color: practiceStatus == PracticeStatus.start ? getFigmaColor(context, 'Schemes/Background')
                : getFigmaColor(context, 'Schemes/Surface Container'),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Stack(
                children: [

                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 500),
                            crossFadeState: practiceStatus == PracticeStatus.start ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            firstChild: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                    Expanded(child: InfoBadge(icon: Icons.text_fields, label: 'Words', value: wordsCount,)),
                                    Expanded(child: InfoBadge(icon: Icons.schedule, label: 'Avg. Time @ ${wpm.wpm} WPM', value: avgTime,)),
                                ],
                            ),
                            secondChild: Row(
                                spacing: 5,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                    Expanded(child: StatBadge(context: context, label: wpmValue.toStringAsFixed(0), value: 'WPM')),
                                    Expanded(child: StatBadge(context: context, label: '${s.accuracy.toStringAsFixed(2)}%', value: 'Accuracy', icon: Icons.my_location )),
                                    Expanded(child: StatBadge(context: context, label: sessionState.formattedElapsed, value: 'Time', icon: Icons.schedule)),
                                ],
                            ),
                        ),
                    ),

                    if (showToast)
                    Toast(
                        label: 'New text is created & ready for your practice',
                        bgColor: getFigmaColor(context, 'Palettes/Secondary 90'),
                        textColor: getFigmaColor(context, 'Schemes/Secondary'),
                        showToast: showToast,
                        animationTime: 2,
                        onClosePressed: hideToast,
                        onCompleted: () {
                            // e.g., tell parent to hide it or log analytics
                            setState(() => showToast = false);
                        },
                        onDismissed: () {
                            setState(() => showToast = false);
                        },
                    ),
                ],
            ),
        );
    }
}
