import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';

class StreakBadge extends ConsumerWidget {
    const StreakBadge({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final streak = ref.watch(streakControllerProvider);

        return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: EdgeInsets.symmetric(
                horizontal: Gap(context).gap(12),
                vertical: Gap(context).gap(8)
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                    color: getFigmaColor(context, 'Fixed/Secondary Fixed'),
                    width: 2
                ),
                image: DecorationImage(
                    image: AssetImage('assets/images/streak_board.png'),
                    fit: BoxFit.cover
                )
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Image.asset(
                        'assets/images/streak_badge.png',
                        width: Gap(context).gap(32),
                        height: Gap(context).gap(32)
                    ),
                    SizedBox(width: Gap(context).gap(4)),
                    Text(
                        '${streak.current} Streak',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: getFigmaColor(context, 'Fixed/Secondary Fixed'),
                            fontWeight: FontWeight.w700
                        )
                    )
                ]
            )
        );
    }
}
