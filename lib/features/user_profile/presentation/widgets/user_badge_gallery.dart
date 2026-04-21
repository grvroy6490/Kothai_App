import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/badges/data/model/badge_entity.dart';
import 'package:visai/features/badges/data/repositories_impl/badge_repository.dart';
import 'package:visai/features/badges/domain/enums/badge_type_enum.dart';
import 'package:visai/features/more/presentation/pages/achievement/achievement_gallery_page.dart';

class UserBadgeGallery extends ConsumerStatefulWidget {
    final Set<String> badges;
    const UserBadgeGallery({super.key, required this.badges});

    @override
    ConsumerState<UserBadgeGallery> createState() => _UserBadgeGalleryState();
}

class _UserBadgeGalleryState extends ConsumerState<UserBadgeGallery> {
    String _getCategoryFromType(BadgeType type) {
        switch (type) {
            case BadgeType.xp:
                return 'XP';
            case BadgeType.streak:
                return 'Streak';
            case BadgeType.speed:
                return 'Speed';
            case BadgeType.accuracy:
                return 'Accuracy';
            case BadgeType.general:
                return 'General';
        }
    }

    @override
    Widget build(BuildContext context) {
        final allBadges = BadgeRepository.allBadges;
        final unlockedBadges = allBadges
            .where((badge) => widget.badges.contains(badge.id))
            .toList();
        final unlockedCount = unlockedBadges.length;
        final totalCount = allBadges.length;
        final previewBadges = unlockedBadges.take(4).toList();
        final remainingBadgeCount = unlockedCount - previewBadges.length;

        return Container(
            padding: EdgeInsets.only(
                top: Gap(context).gap(10),
                left: Gap(context).gap(16),
                right: Gap(context).gap(16),
                bottom: Gap(context).gap(16)
            ),
            decoration: BoxDecoration(
                color: getFigmaColor(context, 'Schemes/Surface Container'),
                borderRadius: BorderRadius.circular(24)
            ),
            child: Column(
                children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: Gap(context).gap(10),
                            // vertical: Gap(context).gap(8)
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    'Achievement Gallery ($unlockedCount/$totalCount)',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface'),
                                        fontWeight: FontWeight.w800,
                                        height: 1
                                    )
                                ),

                                IconButton(
                                    onPressed: () {
                                        Get.to(() => AchievementGalleryPage(), transition: Transition.fadeIn, curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 500));
                                    },
                                    icon: Icon(
                                        Icons.arrow_forward,
                                        color: getFigmaColor(context, 'Schemes/On Surface')
                                    )
                                )
                            ]
                        )
                    ),
                    Divider(),
                    SizedBox(height: Gap(context).gap(8)),

                    // INSERT_YOUR_CODE
                    unlockedBadges.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(Gap(context).gap(20)),
                            child: Text(
                                'No badges unlocked yet. Complete challenges to earn badges!',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: getFigmaColor(
                                        context,
                                        'Schemes/On Surface Variant'
                                    )
                                ),
                                textAlign: TextAlign.center
                            )
                        )
                        : Column(
                            children: [
                                GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: previewBadges.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: Gap(context).gap(10),
                                        mainAxisSpacing: Gap(context).gap(10),
                                        mainAxisExtent: Gap(context).gap(160)
                                    ),
                                    itemBuilder: (context, index) {
                                        final badge = previewBadges[index];
                                        return _galleryBadge(badge: badge, isUnlocked: true);
                                    }
                                ),
                                if (remainingBadgeCount > 0) ...[
                                    SizedBox(height: Gap(context).gap(10)),
                                    Text(
                                        '+$remainingBadgeCount more badges. Tap the arrow to view all.',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: getFigmaColor(
                                                context,
                                                'Schemes/On Surface Variant'
                                            )
                                        ),
                                        textAlign: TextAlign.center
                                    )
                                ]
                            ]
                        )
                ]
            )
        );
    }

    Widget _galleryBadge({required BadgeEntity badge, required bool isUnlocked}) {
        final category = _getCategoryFromType(badge.type);

        return Container(
            width: Gap(context).gap(64),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: getFigmaColor(context, 'Schemes/Surface Container Highest')
            ),
            child: Stack(
                children: [
                    Positioned(
                        right: -50,
                        bottom: -60,
                        child: Opacity(
                            opacity: 0.1 ,
                            child: Image(
                                image: AssetImage(badge.imagePath),
                                fit: BoxFit.cover,
                                width: Gap(context).gap(
                                    200
                                ) // Make the image noticeably bigger than parent (parent is 64)
                            )
                        )
                    ),

                    Padding(
                        padding: EdgeInsets.all(Gap(context).gap(8)),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Expanded(
                                                flex: 1,
                                                child:Image(
                                                    image: AssetImage(badge.imagePath),
                                                    width: Gap(context).gap(60),
                                                    height: Gap(context).gap(60),
                                                    fit: BoxFit.contain
                                                )
                                            ),

                                            SizedBox(width: Gap(context).gap(4)),

                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: getFigmaColor(
                                                            context,
                                                            'State Layers/On Surface/Opacity-08'
                                                        ),
                                                        borderRadius: BorderRadius.circular(25)
                                                    ),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Gap(context).gap(6),
                                                        vertical: Gap(context).gap(4)
                                                    ),
                                                    child: Text(
                                                        category,
                                                        style: Theme.of(context).textTheme.labelSmall
                                                            ?.copyWith(
                                                                color: getFigmaColor(
                                                                    context,
                                                                    'Schemes/On Surface Variant'
                                                                )
                                                            ),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        textAlign: TextAlign.center
                                                    )
                                                )
                                            )
                                        ]
                                    )
                                ),

                                Text(
                                    badge.name,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/Secondary')
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2
                                ),
                                SizedBox(height: Gap(context).gap(4)),
                                Text(
                                    badge.condition,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: getFigmaColor(
                                            context,
                                            'Schemes/On Surface Variant'
                                        )
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }
}
