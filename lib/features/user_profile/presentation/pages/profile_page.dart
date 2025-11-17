import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/providers/auth/auth_provider.dart';
import 'package:kothai_app/di/providers/navigation/navigation_provider.dart';
import 'package:kothai_app/features/authentication/presentation/providers/auth_service_provider.dart';
import 'package:kothai_app/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/bottom_navigation_bar.dart';
import 'package:kothai_app/features/user_profile/presentation/widgets/badge_display.dart';
import 'package:kothai_app/features/user_profile/presentation/widgets/user_badge_gallery.dart';
import 'package:kothai_app/features/user_profile/presentation/widgets/user_detail_widet.dart';
import 'package:kothai_app/features/user_profile/presentation/widgets/user_settings.dart';
import 'package:logger/logger.dart';

class ProfilePage extends ConsumerStatefulWidget {
    const ProfilePage({super.key});

    @override
    ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
    final _logger = Logger();

    @override
    Widget build(BuildContext context) {
        // 🌐 PROVIDERS ------------------------------
        final _auth = ref.watch(authUserProvider);
        final isLoggedIn = ref.watch(isLoggedInProvider);
        final badges = ref.read(badgeControllerProvider);

        // _logger.d(_auth.value?.email != null);

        // 📃 DECLARATION ----------------------------
        final idx = ref.watch(selectNavProvider);
        final nav = ref.read(selectNavProvider.notifier);
        final currentIndex = (idx >= 0 && idx < 4) ? idx : 0;

        // ⭐ Widget ---------------------------------
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
            appBar: AppBar(
                backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
                automaticallyImplyLeading: false,
                title: Text('Profile', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    )
                ),
                actions: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
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
                        child:  _auth.value?.email != null // TODO: update auth
                            ?  FilledButton.icon(
                                onPressed: (){
                                },
                                label: Text('Save your progress',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface')
                                    )
                                ),
                                icon: Icon(Icons.cloud_upload_rounded),
                                style: ButtonStyle(
                                    iconColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'Schemes/On Surface')),
                                    backgroundColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'State Layers/On Surface/Opacity-08'))
                                )
                            )

                            : FilledButton.icon(
                                onPressed: (){
                                },
                                label: Text('Share Progress',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: getFigmaColor(context, 'Schemes/On Surface')
                                    )
                                ),
                                icon: Icon(Icons.share),
                                style: ButtonStyle(
                                    iconColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'Schemes/On Surface')),
                                    backgroundColor: WidgetStateProperty.all<Color>(getFigmaColor(context, 'State Layers/On Surface/Opacity-08'))
                                )
                            )
                    ),

                    SizedBox(width: 5),
                    IconButton(
                        padding: const EdgeInsets.all(11),
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                getFigmaColor(context, 'State Layers/On Surface/Opacity-08')
                            ),
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                            )
                        ),
                        onPressed: (){
                        },
                        icon: Icon(
                            FontAwesomeIcons.bell,
                            size: KxScale(context).sp(18),
                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                        )
                    )
                ]
            ),
            bottomNavigationBar: BottomNavigationBarWidget(),

            body: SizedBox(
                height: double.infinity,
                child: Container(
                    padding: EdgeInsets.only(top: Gap(context).gap(5), left: Gap(context).gap(5), right: Gap(context).gap(5)),
                    decoration: BoxDecoration(
                        color: getFigmaColor(context, 'Schemes/Surface Container Highest'),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                            children: [
                                UserDetailWidet(auth: _auth),

                                SizedBox(height: Gap(context).gap(10)),

                                BadgeDisplay(),

                                SizedBox(height: Gap(context).gap(10)),

                                UserBadgeGallery(badges: badges),

                                SizedBox(height: Gap(context).gap(10)),
                                // SETTING CONTAINER
                                UserSettings(),

                                SizedBox(height: Gap(context).gap(10)),
                                // SETTING CONTAINER
                                Container(
                                    padding: EdgeInsets.only(top: Gap(context).gap(10), bottom: Gap(context).gap(10), left: Gap(context).gap(16), right: Gap(context).gap(16)),
                                    decoration: BoxDecoration(
                                        color: getFigmaColor(context, 'Schemes/Surface Container'),
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(10), vertical: Gap(context).gap(8)),

                                        child: Row(
                                            children: [
                                                Icon(
                                                    Icons.help,
                                                    color: true ? getFigmaColor(context, 'Schemes/On Surface Variant') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            Text('Help',
                                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                    color: getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                                    fontWeight: FontWeight.w600
                                                                )
                                                            ),
                                                            Text('Schemes/On Surface Variant',
                                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                                )
                                                            )
                                                        ]
                                                    )
                                                ),
                                                SizedBox(width: 10),
                                                IconButton(
                                                    onPressed: (){
                                                    },
                                                    icon: Icon(Icons.chevron_right, size: KxScale(context).sp(30), color: getFigmaColor(context, 'Schemes/On Surface'))
                                                )
                                            ]
                                        )
                                    )
                                )

                            ]
                        )
                    )
                )
            )

        );
    }
}

