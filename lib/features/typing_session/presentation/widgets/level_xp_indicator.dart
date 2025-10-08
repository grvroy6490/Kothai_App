
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/domain/entities/gamification/gamification_entity.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:logger/logger.dart';

class LevelXPIndicatior extends ConsumerWidget {
    final double? width;
    final bool isCompact;

    const LevelXPIndicatior({
        super.key,
        this.width = 165,
        this.isCompact = true
    });

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        // final _logger = Logger();
        // 🌐 PROVIDERS ------------------------------
        final GamificationEntity? gamificationData = ref.watch(gamificationDataControllerProvider);

        // 📃 DECLARATION ----------------------------
        final levels = gamificationData != null ? gamificationData.levels : [];
        // _logger.i(levels);

        // 🚀 METHODS ---------------------------------
        // ⭐ Widget --------------------------------------
        return Container(
            width: width,
            decoration: BoxDecoration(
                color: getFigmaColor(context, 'State Layers/On Surface/Opacity-08'),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 1.0, color: getFigmaColor(context, 'State Layers/On Surface/Opacity-10'))
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
                children: [
                    //Background Progress Bar
                    // Background Progress Bar
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                                widthFactor: 0.3, // xp.progress, // 60% progress, adjust as needed // TODO: get XP progress here
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
                                    padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(5), vertical: Gap(context).gap(8)),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                    child: Stack(
                                        children: [
                                            SvgPicture.asset('assets/images/Gold_Icon.svg',
                                                width: Gap(context).gap(16)
                                            )
                                        ]
                                    )
                                ),

                                Text('Level 1', // ${xp.level}', // TODO: Need to get user level here
                                    style: isCompact ? Theme.of(context).textTheme.labelMedium?.copyWith(
                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                        ) : Theme.of(context).textTheme.labelLarge?.copyWith(
                                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                            fontWeight: FontWeight.w700
                                        )
                                ),
                                Icon(
                                    Icons.circle,
                                    size: KxScale(context).sp(5),
                                    color: Colors.white
                                ),
                                Expanded(
                                    child: Text('50 XP', //'${xp.totalXp} XP', // TODO: Need to get total XP here
                                        style: isCompact ? Theme.of(context).textTheme.labelMedium?.copyWith(
                                                color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                            ) : Theme.of(context).textTheme.labelLarge?.copyWith(
                                                color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                fontWeight: FontWeight.w700
                                            )
                                    )
                                ),

                                if (!isCompact) ...[
                                    Spacer(),

                                    Text('XP to next level', // '${xp.xpPerLevel - xp.xpIntoLevel} XP to next level', // TODO: get XP need for next level
                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                            fontWeight: FontWeight.w700
                                        )
                                    )
                                ]
                            ]
                        )
                    )
                ]
            )
        );
    }
}
