
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/poviders/navigation_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
    const ProfilePage({super.key});

    @override
    ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
    @override
    Widget build(BuildContext context) {
        final idx = ref.watch(selectNavProvider);
        final nav = ref.read(selectNavProvider.notifier);
        final currentIndex = (idx >= 0 && idx < 4) ? idx : 0;

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
                        child: false
                            ? FilledButton.icon(
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
                            : FilledButton.icon(
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
            bottomNavigationBar: BottomNavigationBar(
                iconSize: 20,
                enableFeedback: false,
                currentIndex: currentIndex,
                onTap: (index) {
                    nav.set(index);
                    final route = nav.currentRoute;
                    if (Get.currentRoute != route) {
                        Get.offNamed(route);
                    }
                },
                selectedLabelStyle: null,
                unselectedLabelStyle: null,
                type: BottomNavigationBarType.fixed,
                backgroundColor: getFigmaColor(context, 'Schemes/Surface'),
                selectedItemColor: getFigmaColor(context, 'Schemes/Primary'),
                unselectedItemColor: getFigmaColor(
                    context,
                    'Schemes/On Background'
                ).withAlpha(153),
                items: [
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.solidKeyboard), label: 'Practice'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.trophy), label: 'Challenge'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.circleUser), label: 'Profile'),
                    BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.grip), label: 'More')
                ]
            ),

            body: SizedBox(
                height: double.infinity,
                child: Container(
                    padding: EdgeInsets.only(top: Gap(context).gap(5), left: Gap(context).gap(5), right: Gap(context).gap(5)),
                    decoration: BoxDecoration(
                        color: getFigmaColor(context, 'Schemes/Surface Container Highest'),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                    ),
                    child: Container(
                        padding: EdgeInsets.only(top: Gap(context).gap(10), left: Gap(context).gap(16), right: Gap(context).gap(16)),
                        decoration: BoxDecoration(
                            color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                        )
                        // child: ,
                    )
                )
            )

        );
    }
}
