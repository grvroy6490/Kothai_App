import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/badges/data/model/badge_entity.dart';
import 'package:visai/features/badges/data/repositories_impl/badge_repository.dart';
import 'package:visai/features/badges/domain/enums/badge_type_enum.dart';
import 'package:visai/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/bottom_navigation_bar.dart';
import 'package:visai/presentation/shared/app_bar_compact.dart';

class AchievementGalleryPage extends ConsumerStatefulWidget {
  const AchievementGalleryPage({super.key});

  @override
  ConsumerState<AchievementGalleryPage> createState() =>
      _AchievementGalleryPageState();
}

enum _FilterSegment { all, earned, locked }

class _AchievementGalleryPageState
    extends ConsumerState<AchievementGalleryPage> {
  int _selectedTabIndex = 0;
  _FilterSegment _selectedFilter = _FilterSegment.all;

  final List<Map<String, dynamic>> _tabs = [
    {'label': 'All', 'type': null},
    {'label': 'XP Milestones', 'type': BadgeType.xp},
    {'label': 'Streak Milestones', 'type': BadgeType.streak},
  ];

  List<BadgeEntity> _getFilteredBadges() {
    final allBadges = BadgeRepository.allBadges;
    final unlockedBadgeIds = ref.read(badgeControllerProvider);

    // Filter by tab (category)
    BadgeType? selectedType = _tabs[_selectedTabIndex]['type'] as BadgeType?;
    List<BadgeEntity> categoryFiltered = selectedType == null
        ? allBadges
        : allBadges.where((badge) => badge.type == selectedType).toList();

    // Filter by segment (earned/locked)
    if (_selectedFilter == _FilterSegment.earned) {
      return categoryFiltered
          .where((badge) => unlockedBadgeIds.contains(badge.id))
          .toList();
    } else if (_selectedFilter == _FilterSegment.locked) {
      return categoryFiltered
          .where((badge) => !unlockedBadgeIds.contains(badge.id))
          .toList();
    }

    // _FilterSegment.all - show all badges
    return categoryFiltered;
  }

  int _getTabCount(int tabIndex) {
    final allBadges = BadgeRepository.allBadges;
    final unlockedBadgeIds = ref.read(badgeControllerProvider);
    BadgeType? selectedType = _tabs[tabIndex]['type'] as BadgeType?;

    final categoryBadges = selectedType == null
        ? allBadges
        : allBadges.where((badge) => badge.type == selectedType).toList();

    if (_selectedFilter == _FilterSegment.earned) {
      return categoryBadges
          .where((badge) => unlockedBadgeIds.contains(badge.id))
          .length;
    } else if (_selectedFilter == _FilterSegment.locked) {
      return categoryBadges
          .where((badge) => !unlockedBadgeIds.contains(badge.id))
          .length;
    }

    return categoryBadges.length;
  }

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
    final unlockedBadgeIds = ref.watch(badgeControllerProvider);
    final allBadges = BadgeRepository.allBadges;
    final unlockedBadges = allBadges
        .where((badge) => unlockedBadgeIds.contains(badge.id))
        .toList();
    final unlockedCount = unlockedBadges.length;
    final totalCount = allBadges.length;
    final filteredBadges = _getFilteredBadges();

    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
      appBar: AppBarCompact(leading: true, title: 'Achievements Gallery'),
      bottomNavigationBar: BottomNavigationBarWidget(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.only(
            top: Gap(context).gap(10),
            left: Gap(context).gap(10),
            right: Gap(context).gap(10),
          ),
          decoration: BoxDecoration(
            color: getFigmaColor(context, 'Schemes/Surface Container Highest'),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Badge Summary
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: AssetImage('assets/images/badge_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Gap(context).gap(10),
                    horizontal: Gap(context).gap(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/badges_earned.png'),
                        width: KxScale(context).sp(80),
                      ),

                      SizedBox(width: Gap(context).gap(7)),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Text(
                                '$unlockedCount Badge${unlockedCount != 1 ? 's' : ''} Earned',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.black.withOpacity(0.4),
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black45,
                                          offset: Offset(2, 4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 230, 134),
                                        Color.fromARGB(255, 252, 144, 14),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ).createShader(
                                      Rect.fromLTWH(
                                        0,
                                        0,
                                        bounds.width,
                                        bounds.height,
                                      ),
                                    ),
                                blendMode: BlendMode.srcIn,
                                child: Text(
                                  '$unlockedCount Badge${unlockedCount != 1 ? 's' : ''} Earned',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Gap(context).gap(5)),
                          Text(
                            '${totalCount - unlockedCount} Badge${totalCount - unlockedCount != 1 ? 's' : ''} ready to be Unlocked',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: getFigmaColor(
                                    context,
                                    'Fixed/Secondary Fixed',
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Gap(context).gap(15)),

              // Tabs
              Container(
                width: double.infinity,
                // padding: EdgeInsets.all(Gap(context).gap(10)),
                decoration: BoxDecoration(
                  color: getFigmaColor(context, 'Schemes/Surface Container'),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: Gap(context).gap(10)),
                  decoration: BoxDecoration(
                    color: getFigmaColor(context, 'Schemes/Surface'),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: getFigmaColor(
                          context,
                          'Schemes/Outline Variant',
                        ),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      SegmentedButton<_FilterSegment>(
                        segments: [
                          ButtonSegment<_FilterSegment>(
                            value: _FilterSegment.all,
                            label: Text('All'),
                          ),
                          ButtonSegment<_FilterSegment>(
                            value: _FilterSegment.earned,
                            label: Text('Earned'),
                          ),
                          ButtonSegment<_FilterSegment>(
                            value: _FilterSegment.locked,
                            label: Text('Locked'),
                          ),
                        ],
                        selected: {_selectedFilter},
                        onSelectionChanged: (Set<_FilterSegment> newSelection) {
                          setState(() {
                            _selectedFilter = newSelection.first;
                          });
                        },
                        style: SegmentedButton.styleFrom(
                          backgroundColor: getFigmaColor(
                            context,
                            'Schemes/Surface Container Highest',
                          ),
                          selectedBackgroundColor: getFigmaColor(
                            context,
                            'Schemes/Primary',
                          ),
                          selectedForegroundColor: Colors.white,
                          foregroundColor: getFigmaColor(
                            context,
                            'Schemes/Primary',
                          ),
                          side: BorderSide(
                            color: getFigmaColor(context, 'Schemes/Primary'),
                            width: 1,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Gap(context).gap(16),
                            vertical: Gap(context).gap(10),
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_tabs.length, (index) {
                            final tab = _tabs[index];
                            final isSelected = _selectedTabIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTabIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: Gap(context).gap(10),
                                  right: index == _tabs.length - 1
                                      ? Gap(context).gap(10)
                                      : 0,
                                  top: Gap(context).gap(10),
                                  // bottom: Gap(context).gap(10)
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: Gap(context).gap(12),
                                  vertical: Gap(context).gap(8),
                                ),
                                decoration: BoxDecoration(
                                  color: getFigmaColor(
                                    context,
                                    'Schemes/Surface',
                                  ),
                                  border: isSelected
                                      ? Border(
                                          bottom: BorderSide(
                                            color: getFigmaColor(
                                              context,
                                              'Schemes/Primary',
                                            ),
                                            width: 1.5,
                                          ),
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Opacity(
                                      opacity: isSelected ? 1.0 : 0.5,
                                      child: Text(
                                        tab['label'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: isSelected
                                                  ? getFigmaColor(
                                                      context,
                                                      'Schemes/Primary',
                                                    )
                                                  : getFigmaColor(
                                                      context,
                                                      'Schemes/On Surface Variant',
                                                    ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: Gap(context).gap(6)),
                                    Opacity(
                                      opacity: isSelected ? 1.0 : 0.5,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Gap(context).gap(8),
                                          vertical: Gap(context).gap(4),
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? getFigmaColor(
                                                  context,
                                                  'Schemes/Surface Variant',
                                                )
                                              : getFigmaColor(
                                                  context,
                                                  'Schemes/On Surface Variant',
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${_getTabCount(index)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: isSelected
                                                    ? getFigmaColor(
                                                        context,
                                                        'Schemes/On Surface Variant',
                                                      )
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: KxScale(
                                                  context,
                                                ).sp(12),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Gap(context).gap(5),
                      vertical: Gap(context).gap(10),
                    ),
                    decoration: BoxDecoration(
                      color: getFigmaColor(
                        context,
                        'Schemes/Surface Container',
                      ),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredBadges.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: Gap(context).gap(10),
                        mainAxisSpacing: Gap(context).gap(10),
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final badge = filteredBadges[index];
                        final isUnlocked = unlockedBadgeIds.contains(badge.id);
                        return _galleryBadge(
                          badge: badge,
                          isUnlocked: isUnlocked,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _galleryBadge({required BadgeEntity badge, required bool isUnlocked}) {
    final category = _getCategoryFromType(badge.type);

    return Container(
      width: Gap(context).gap(64),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isUnlocked ? getFigmaColor(context, 'Schemes/Surface Container Highest') : getFigmaColor(context, 'Schemes/Surface Container Lowest'),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            bottom: -60,
            child: Opacity(
              opacity: isUnlocked ? 0.1 : 0.05,
              child: isUnlocked
                  ? Image(
                      image: AssetImage(badge.imagePath),
                      fit: BoxFit.cover,
                      width: Gap(context).gap(200),
                    )
                  : ColorFiltered(
                      colorFilter: ColorFilter.matrix([
                        0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                        0.2126, 0.7152, 0.0722, 0, 0, // Green channel
                        0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                        0, 0, 0, 1, 0, // Alpha channel
                      ]),
                      child: Image(
                        image: AssetImage(badge.imagePath),
                        fit: BoxFit.cover,
                        width: Gap(context).gap(200),
                      ),
                    ),
            ),
          ),

          // if (!isUnlocked)
          // Positioned.fill(
          //     child: Container(
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(16),
          //             color: Colors.black.withOpacity(0.4)
          //         ),
          //         child: Center(
          //             child: Icon(
          //                 Icons.lock,
          //                 color: Colors.white,
          //                 size: KxScale(context).sp(32)
          //             )
          //         )
          //     )
          // ),
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
                        child: isUnlocked
                            ? Image(
                                image: AssetImage(badge.imagePath),
                                width: Gap(context).gap(60),
                                height: Gap(context).gap(60),
                                fit: BoxFit.contain,
                              )
                            : ColorFiltered(
                                colorFilter: ColorFilter.matrix([
                                  0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                                  0.2126, 0.7152, 0.0722, 0, 0, // Green channel
                                  0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                                  0, 0, 0, 1, 0, // Alpha channel
                                ]),
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Image(
                                    image: AssetImage(badge.imagePath),
                                    width: Gap(context).gap(60),
                                    height: Gap(context).gap(60),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                      ),

                      SizedBox(width: Gap(context).gap(4)),

                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? getFigmaColor(
                                    context,
                                    'State Layers/On Surface/Opacity-08',
                                  )
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Gap(context).gap(6),
                            vertical: Gap(context).gap(4),
                          ),
                          child: !isUnlocked
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      category,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: getFigmaColor(
                                              context,
                                              'Schemes/On Surface Variant',
                                            ),
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(width: Gap(context).gap(5)),

                                    Opacity(
                                      opacity: 0.5,
                                      child: Icon(
                                        Icons.lock,
                                        size: KxScale(context).sp(16),
                                        color: getFigmaColor(
                                          context,
                                          'Schemes/On Surface Variant',
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  category,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: getFigmaColor(
                                          context,
                                          'Schemes/On Surface Variant',
                                        ),
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  badge.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isUnlocked
                        ? getFigmaColor(context, 'Schemes/Secondary')
                        : getFigmaColor(context, 'Schemes/On Surface Variant'),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: Gap(context).gap(4)),
                Text(
                  badge.condition,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
