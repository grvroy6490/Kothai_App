
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/XP/xp_controller.dart';

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
        final xp = ref.watch(xpControllerProvider);

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
                                widthFactor: xp.progress, // 60% progress, adjust as needed
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

                                Text('Level ${xp.level}',
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
                                    child: Text('${xp.totalXp} XP',
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

                                    Text('${xp.xpPerLevel - xp.xpIntoLevel} XP to next level',
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
