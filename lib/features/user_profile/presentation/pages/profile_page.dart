import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/features/authentication/presentation/providers/auth_service_provider.dart';
import 'package:visai/domain/usecases/show_modal.dart';
import 'package:visai/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';
import 'package:visai/features/share/presentation/pages/share_page.dart';
import 'package:visai/features/typing_session/presentation/widgets/bottom_navigation_bar.dart';
import 'package:visai/features/user_profile/presentation/widgets/badge_display.dart';
import 'package:visai/features/user_profile/presentation/widgets/user_badge_gallery.dart';
import 'package:visai/features/user_profile/presentation/widgets/user_detail_widet.dart';
import 'package:visai/features/authentication/presentation/pages/login.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/score/score_controller_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
    const ProfilePage({super.key});

    @override
    ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
    @override
    Widget build(BuildContext context) {
        // 🌐 PROVIDERS ------------------------------
        final _auth = ref.watch(authUserProvider);
        final badges = ref.read(badgeControllerProvider);

        // _logger.d(_auth.value?.email != null);

        // 📃 DECLARATION ----------------------------
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
                        child:  _auth.value?.email == null // TODO: update auth
                            ?  FilledButton.icon(
                                onPressed: () async {
                                    final user = FirebaseAuth.instance.currentUser;
                                    if (user == null) {
                                        await showAppModalWithChild(
                                            context: context,
                                            child: const LoginPage(),
                                            heightFactor: 0.67,
                                        );
                                        if (!mounted) return;
                                    }

                                    final u = FirebaseAuth.instance.currentUser;
                                    if (u == null) return;
                                    try {
                                        await ref
                                            .read(scoreControllerProvider.notifier)
                                            .syncAll();
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                                content: Text('Progress synced successfully.'),
                                                backgroundColor: Colors.green),
                                        );
                                    } catch (e, _) {
                                        // Keep UI responsive; prevent crash on sync failure.
                                        // ignore: avoid_print
                                        print('syncAll failed: $e');
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text('Sync failed: ${e.toString()}'),
                                                backgroundColor: Colors.red),
                                        );
                                    }
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
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                            return Center(
                                                child: Material(
                                                    type: MaterialType.transparency,
                                                    child: Container(
                                                        clipBehavior: Clip.hardEdge,
                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                        child: SharePage()
                                                    )
                                                )
                                            );
                                        }
                                    );
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
                    ),
                    SizedBox(width: 15)
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

                                SizedBox(height: Gap(context).gap(10))

                            ]
                        )
                    )
                )
            )

        );
    }
}

