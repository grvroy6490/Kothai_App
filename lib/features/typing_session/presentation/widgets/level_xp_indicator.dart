import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
// import 'package:visai/domain/entities/gamification/gamification_entity.dart';
import 'package:visai/features/more/presentation/pages/xp_milestones/xp_milestones_page.dart';
// import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/score/score_controller_provider.dart';
// import 'package:logger/logger.dart';

class LevelXPIndicatior extends ConsumerWidget {
    final double? width;
    final bool isCompact;

    const LevelXPIndicatior({super.key, this.width = 170, this.isCompact = true});

    // Helper function to format XP with suffixes
    String formatXP(int xp) {
        if (xp < 1000) {
            return xp.toString();
        } else if (xp < 1000000) {
            // Format as K with one decimal place (e.g., 1271 -> 1.2K)
            return '${(xp / 1000).toStringAsFixed(1)}K';
        } else if (xp < 1000000000) {
            // Format as M with one decimal place (e.g., 1271000 -> 1.2M)
            return '${(xp / 1000000).toStringAsFixed(1)}M';
        } else {
            // Format as B with one decimal place (e.g., 1271000000 -> 1.2B)
            return '${(xp / 1000000000).toStringAsFixed(1)}B';
        }
    }

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        // 🌐 PROVIDERS ------------------------------
        // final GamificationEntity? gamificationData = ref.watch(
        //     gamificationDataControllerProvider
        // );
        final score = ref.watch(scoreControllerProvider);

        // 📃 DECLARATION ----------------------------
        final currentLevelXp = score.xpNextLevel - score.xpIntoLevel;
        final xpEarnedInCurrentLevel = score.totalXp - currentLevelXp;
        final progress = score.xpIntoLevel == 0
            ? 0.0
            : (xpEarnedInCurrentLevel / score.xpIntoLevel).clamp(0.0, 1.0);

        // 🚀 METHODS ---------------------------------
        // ⭐ Widget --------------------------------------
        return Container(
            width: width,
            decoration: BoxDecoration(
                color: getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    width: 1.0,
                    color: getFigmaColor(context, 'State Layers/On Surface/Opacity-10')
                )
            ),
            clipBehavior: Clip.hardEdge,
            child: GestureDetector(
              onTap: () {
                Get.to(() => XpMilestonesPage(), transition: Transition.fadeIn, curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 500));
              },
              child: Stack(
                  children: [
                    //Background Progress Bar
                    // Background Progress Bar
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                    height: Gap(context).gap(40),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              getFigmaColor(context, 'Palettes/Secondary 90'),
                                              getFigmaColor(context, 'Palettes/Primary 80')
                                            ]
                                        ),
                                        borderRadius: BorderRadius.circular(25)
                                    )
                                )
                            )
                        )
                    ),

                    // Foreground Container
                    Container(
                        padding: EdgeInsets.only(
                            left: Gap(context).gap(5),
                            right: Gap(context).gap(10),
                            top: Gap(context).gap(3),
                            bottom: Gap(context).gap(3)
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: Gap(context).gap(5),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Gap(context).gap(5),
                                      vertical: Gap(context).gap(8)
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/Gold_Icon.svg',
                                            width: Gap(context).gap(16)
                                        )
                                      ]
                                  )
                              ),

                              Text(
                                  'Level ${score.level}', // TODO: Need to get user level here
                                  style: isCompact
                                      ? Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: getFigmaColor(
                                          context,
                                          'Schemes/On Surface Variant'
                                      )
                                  )
                                      : Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: getFigmaColor(
                                          context,
                                          'Schemes/On Surface Variant'
                                      ),
                                      fontWeight: FontWeight.w700
                                  )
                              ),
                              Icon(
                                  Icons.circle,
                                  size: KxScale(context).sp(5),
                                  color: Colors.white
                              ),
                              Text(
                                  '${formatXP(score.totalXp)} XP',
                                  style: isCompact
                                      ? Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: getFigmaColor(
                                          context,
                                          'Schemes/On Surface Variant'
                                      )
                                  )
                                      : Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: getFigmaColor(
                                          context,
                                          'Schemes/On Surface Variant'
                                      ),
                                      fontWeight: FontWeight.w700
                                  )
                              ),

                              if (!isCompact) ...[
                                Spacer(),

                                Text(
                                    '${formatXP(score.xpIntoLevel)} XP to next level',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: getFigmaColor(
                                            context,
                                            'Schemes/On Surface Variant'
                                        ),
                                        fontWeight: FontWeight.w700
                                    )
                                )
                              ]
                            ]
                        )
                    )
                  ]
              ),
            )
        );
    }
}
