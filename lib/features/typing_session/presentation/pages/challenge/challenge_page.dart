
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/challenge/challenge_home_screen.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/challenge/challenge_ui_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/bottom_navigation_bar_widget.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/level_xp_indicator.dart';

class ChallengePage extends ConsumerStatefulWidget {
    const ChallengePage({super.key});

    @override
    ConsumerState<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends ConsumerState<ChallengePage> {

    @override
    Widget build(BuildContext context) {
        final selectedChallengeSlide = ref.watch(selectedChallengeUIProvider);

        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: getFigmaColor(context, selectedChallengeSlide.bgColor),
                automaticallyImplyLeading: false,
                title: Text('Challenge', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    )
                ),
                actions: [
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
                        child: LevelXPIndicatior(isCompact: true)
                    ),
                    SizedBox(width: Gap(context).gap(5)),
                    IconButton(
                        padding: EdgeInsets.all(Gap(context).gap(11)),
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                getFigmaColor(context, 'State Layers/On Surface/Opacity-08')
                            ),
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                            )
                        ),
                        onPressed: () {
                        },
                        icon: Icon(
                            FontAwesomeIcons.bell,
                            size: KxScale(context).sp(18),
                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                        )
                    ),
                    SizedBox(width: Gap(context).gap(16))
                ]
            ),
            bottomNavigationBar: BottomNavigationBarWidget(),

            body: ChallengeHomeScreen()
        );
    }
}
