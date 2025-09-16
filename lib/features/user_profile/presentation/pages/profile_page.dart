
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/poviders/navigation_provider.dart';
import 'package:kothai_app/di/poviders/theme_provider.dart';
import 'package:kothai_app/features/authentication/presentation/pages/common_auth.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/practise_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/practice/level_xp_indicator.dart';

class ProfilePage extends ConsumerStatefulWidget {
    const ProfilePage({super.key});

    @override
    ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

    @override
    Widget build(BuildContext context) {
        final practiceConfig = ref.watch(practiceConfigurationProvider);
        final idx = ref.watch(selectNavProvider);
        final nav = ref.read(selectNavProvider.notifier);
        final currentIndex = (idx >= 0 && idx < 4) ? idx : 0;

        void toggleSound(val){
            ref.read(practiceConfigurationProvider.notifier).toggleSound();
        }

        void toggleVibration(val){
            ref.read(practiceConfigurationProvider.notifier).toggleHaptics();
        }

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
                    child: SingleChildScrollView(
                        child: Column(
                            children: [
                                Container(
                                    padding: EdgeInsets.only(top: Gap(context).gap(10), left: Gap(context).gap(16), right: Gap(context).gap(16)),
                                    decoration: BoxDecoration(
                                        color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Expanded(
                                                        child: Row(
                                                            children: [
                                                                CircleAvatar(
                                                                    backgroundColor: getFigmaColor(context, 'Schemes/Primary'),
                                                                    radius: 25,
                                                                    foregroundColor: getFigmaColor(context, 'Schemes/On Primary Container'),
                                                                    child: Text("JD", style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/On Primary Container')
                                                                        ))
                                                                ),
                                                                SizedBox(width: Gap(context).gap(10)),
                                                                Expanded(
                                                                    child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                            Text('Guest User',
                                                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                                                    color: getFigmaColor(context, 'Schemes/On Surface')
                                                                                )
                                                                            ),

                                                                            Text('Login or Signup to save your progress',
                                                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                                                )
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    ),

                                                    SizedBox(width: Gap(context).gap(15)),

                                                    PopupMenuButton<String>(
                                                        icon: Icon(Icons.more_vert, color: getFigmaColor(context, 'Schemes/On Surface Variant')),
                                                        onSelected: (String result) {
                                                            // Handle the selection
                                                            switch (result) {
                                                                case 'Login / Signup':
                                                                    showModalBottomSheet(
                                                                        context: context,
                                                                        isScrollControlled: true,
                                                                        backgroundColor: getFigmaColor(context, 'Schemes/Background'),       // optional
                                                                        shape: const RoundedRectangleBorder( // optional
                                                                            borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                                                                        ),
                                                                        builder: (context) {
                                                                            return FractionallySizedBox(       // or SizedBox(height: MediaQuery.of(context).size.height * 0.8)
                                                                                heightFactor: 0.9,               // 80% of screen
                                                                                child: Padding(                   // keeps content above keyboard if needed
                                                                                    padding: EdgeInsets.only(
                                                                                        bottom: MediaQuery.of(context).viewInsets.bottom
                                                                                    ),
                                                                                    child: CommonAuth()
                                                                                )
                                                                            );
                                                                        }
                                                                    );
                                                                    break;
                                                            }
                                                        },
                                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                            const PopupMenuItem<String>(
                                                                value: 'Login / Signup',
                                                                child: Text('Login / Signup')
                                                            )
                                                        ]
                                                    )
                                                ]
                                            ),

                                            SizedBox(height: Gap(context).gap(20)),
                                            PracticeLevelXPIndicatior(
                                                width: double.infinity,
                                                isCompact: false
                                            ),
                                            SizedBox(height: Gap(context).gap(20))
                                        ]
                                    )
                                ),

                                SizedBox(height: Gap(context).gap(10)),
                                // SETTING CONTAINER
                                Container(
                                    padding: EdgeInsets.only(top: Gap(context).gap(10), left: Gap(context).gap(16), right: Gap(context).gap(16)),
                                    decoration: BoxDecoration(
                                        color: getFigmaColor(context, 'Schemes/Surface Container'),
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: Column(
                                        children: [
                                            Container(
                                                width:double.infinity,
                                                padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(10), vertical: Gap(context).gap(8)),
                                                child: Text('Settings',
                                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                        color: getFigmaColor(context, 'Schemes/On Surface'),
                                                        fontWeight: FontWeight.w800,
                                                        height: 1
                                                    )
                                                )
                                            ),
                                            Divider(),
                                            SizedBox(height: Gap(context).gap(8)),

                                            Container(
                                                padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(10), vertical: Gap(context).gap(8)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: true ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                                                ),
                                                child: Row(
                                                    children: [
                                                        Icon(
                                                            Icons.volume_up,
                                                            color: true ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Text('Sound Effects',
                                                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/Primary'),
                                                                            fontWeight: FontWeight.w600
                                                                        )
                                                                    ),
                                                                    Text('Play sounds when typing',
                                                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        ),
                                                        SizedBox(width: 10),
                                                        _switchButton(context, practiceConfig.soundEnabled, toggleSound  )
                                                    ]
                                                )
                                            ),

                                            SizedBox(height: 15),

                                            Container(
                                                padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(10), vertical: Gap(context).gap(8)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: true ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                                                ),
                                                child: Row(
                                                    children: [
                                                        Icon(
                                                            Icons.vibration,
                                                            color: true ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Text('Vibration',
                                                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/Primary'),
                                                                            fontWeight: FontWeight.w600
                                                                        )
                                                                    ),
                                                                    Text('Vibrate on key press',
                                                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        ),
                                                        SizedBox(width: 10),
                                                        _switchButton(context, practiceConfig.hapticEnabled, toggleVibration)
                                                    ]
                                                )
                                            ),

                                            SizedBox(height: 15),

                                            Container(
                                                padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(10), vertical: Gap(context).gap(8)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: true ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                                                ),
                                                child: Row(
                                                    children: [
                                                        Icon(
                                                            Icons.dark_mode,
                                                            color: true ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Text('Dark Mode',
                                                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/Primary'),
                                                                            fontWeight: FontWeight.w600
                                                                        )
                                                                    ),
                                                                    Text('Use dark theme',
                                                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        ),
                                                        SizedBox(width: 10),
                                                        _switchButton(context, 
                                                            ref.watch(themeProvider) == ThemeMode.dark,
                                                            (val) {ref.read(themeProvider.notifier).toggleTheme();}
                                                        )
                                                    ]
                                                )
                                            ),

                                            SizedBox(height: 15),

                                            Container(
                                                padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(10), vertical: Gap(context).gap(8)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(24),
                                                    color: true ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                                                ),
                                                child: Row(
                                                    children: [
                                                        Icon(
                                                            Icons.notifications,
                                                            color: true ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    Text('Notifications',
                                                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/Primary'),
                                                                            fontWeight: FontWeight.w600
                                                                        )
                                                                    ),
                                                                    Text('Daily remainders and updates',
                                                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                                            color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        ),
                                                        SizedBox(width: 10),
                                                        _switchButton(context, true, (val) => val = !val )
                                                    ]
                                                )
                                            ),

                                            SizedBox(height: Gap(context).gap(10))

                                        ]
                                    )
                                ),

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


Widget _switchButton(
    BuildContext context,
    bool switchValue,
    ValueChanged<bool> onChanged
){
    return Transform.scale(
        scale: 0.7, // Adjust the scale factor to make the switch smaller
        child: Switch(
            value: switchValue,
            inactiveTrackColor: getFigmaColor(context, 'Schemes/Surface Container Highest'),
            inactiveThumbColor: getFigmaColor(context, 'Schemes/Outline'),
            activeTrackColor: getFigmaColor(context, 'Schemes/On Primary'),
            activeThumbColor: getFigmaColor(context, 'Schemes/Primary'),
            trackOutlineColor: WidgetStateProperty.all(getFigmaColor(context, 'State Layers/On Surface Variant/Opacity-04')),
            onChanged: (val) => onChanged(val)
        )
    );
}