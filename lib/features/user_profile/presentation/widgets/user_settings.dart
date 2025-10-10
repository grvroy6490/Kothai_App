import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/di/providers/theme/theme_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';

class UserSettings extends ConsumerStatefulWidget {
    const UserSettings({super.key});

    @override
    ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {

    @override
    Widget build(BuildContext context) {
        final practiceConfig = ref.watch(practiceConfigurationProvider);

        // 🚀 METHODS --------------------------------
        void toggleSound(val){
        }

        void toggleVibration(val){
        }

        return Container(
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
                            color: practiceConfig.soundEnabled ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                        ),
                        child: Row(
                            children: [
                                Icon(
                                    Icons.volume_up,
                                    color: practiceConfig.soundEnabled ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Sound Effects',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: practiceConfig.soundEnabled ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant'),
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
                            color: false ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                        ),
                        child: Row(
                            children: [
                                Icon(
                                    Icons.vibration,
                                    color: false ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Vibration',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: false ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant'),
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
                                                    color: true ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant'),
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
                                    (val) {
                                        ref.read(themeProvider.notifier).toggleTheme();
                                    }
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
                                                    color: true ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant'),
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
        );
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
}
