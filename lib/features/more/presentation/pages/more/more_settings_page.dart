import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
// import 'package:visai/features/authentication/presentation/providers/auth_service_provider.dart';
import 'package:visai/features/more/presentation/pages/achievement/achievement_gallery_page.dart';
import 'package:visai/features/more/presentation/pages/streak_board/streak_board_page.dart';
import 'package:visai/features/more/presentation/pages/xp_milestones/xp_milestones_page.dart';
import 'package:visai/features/typing_session/presentation/widgets/bottom_navigation_bar.dart';
import 'package:visai/features/user_profile/presentation/widgets/user_settings.dart';
import 'package:visai/presentation/shared/app_bar_compact.dart';

class MoreSettingsPage extends ConsumerStatefulWidget {
  const MoreSettingsPage({super.key});

  @override
  ConsumerState<MoreSettingsPage> createState() => _MoreSettingsPageState();
}

class _MoreSettingsPageState extends ConsumerState<MoreSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
      appBar: AppBarCompact(title: 'More'),
      bottomNavigationBar: BottomNavigationBarWidget(),
      body: SizedBox(
        height: double.infinity,
        child: Container(
          padding: EdgeInsets.only(
            // top: Gap(context).gap(10),
            left: Gap(context).gap(16),
            right: Gap(context).gap(16),
          ),
          decoration: BoxDecoration(
            color: getFigmaColor(context, 'Schemes/Background'),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Gap(context).gap(10)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Gap(context).gap(10),
                    vertical: Gap(context).gap(8),
                  ),
                  child: Text(
                    'Progress',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: getFigmaColor(context, 'Schemes/On Surface'),
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
                Divider(),

                SizedBox(height: Gap(context).gap(8)),

                // SETTING CONTAINER
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Gap(context).gap(13),
                    vertical: Gap(context).gap(10),
                  ),
                  decoration: BoxDecoration(
                    color: getFigmaColor(context, 'Schemes/Surface Container'),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.trophy,
                        size: Gap(context).gap(20),
                        color: getFigmaColor(context, 'Schemes/On Surface'),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Achievements Gallery',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/On Surface',
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'View your earned badges',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/On Surface Variant',
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => AchievementGalleryPage(),
                            transition: Transition.fadeIn,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        icon: Icon(
                          Icons.chevron_right,
                          size: KxScale(context).sp(30),
                          color: getFigmaColor(context, 'Schemes/On Surface'),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Gap(context).gap(10)),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Gap(context).gap(13),
                    vertical: Gap(context).gap(10),
                  ),
                  decoration: BoxDecoration(
                    color: getFigmaColor(context, 'Schemes/Surface Container'),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: Gap(context).gap(25),
                        color: getFigmaColor(context, 'Schemes/On Surface'),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Streak Board',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/On Surface',
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Track your daily Tamil typing practice',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/On Surface Variant',
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => StreakBoardPage(),
                            transition: Transition.fadeIn,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        icon: Icon(
                          Icons.chevron_right,
                          size: KxScale(context).sp(30),
                          color: getFigmaColor(context, 'Schemes/On Surface'),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Gap(context).gap(10)),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Gap(context).gap(13),
                    vertical: Gap(context).gap(10),
                  ),
                  decoration: BoxDecoration(
                    color: getFigmaColor(context, 'Schemes/Surface Container'),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.stars,
                        size: Gap(context).gap(23),
                        color: getFigmaColor(context, 'Schemes/On Surface'),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'XP & Milestones',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/On Surface',
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Track your தமிழ் typing mastery progress',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: getFigmaColor(
                                      context,
                                      'Schemes/On Surface Variant',
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => XpMilestonesPage(),
                            transition: Transition.fadeIn,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                        icon: Icon(
                          Icons.chevron_right,
                          size: KxScale(context).sp(30),
                          color: getFigmaColor(context, 'Schemes/On Surface'),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Gap(context).gap(10)),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Gap(context).gap(10),
                    vertical: Gap(context).gap(8),
                  ),
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: getFigmaColor(context, 'Schemes/On Surface'),
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),

                Divider(),

                SizedBox(height: Gap(context).gap(8)),

                UserSettings(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
