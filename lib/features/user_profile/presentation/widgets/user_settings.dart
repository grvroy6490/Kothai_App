import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/constants/notifications_constants.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/di/providers/theme/theme_provider.dart';
import 'package:visai/features/badges/presentation/riverpod/controllers/badge_controller_provider.dart';
import 'package:visai/features/typing_session/domain/entities/challenge/challenge_config.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_config_provider.dart';

class UserSettings extends ConsumerStatefulWidget {
    const UserSettings({super.key});

    @override
    ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {

    @override
    Widget build(BuildContext context) {
        // 🌐 PROVIDERS ------------------------------
        final config = ref.watch(challengeConfigurationProvider);
        final themeMode = ref.watch(themeProvider);
        // When following system, reflect device dark/light; otherwise use saved choice
        final isDarkMode = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        // 📃 DECLARATION ----------------------------
        final ChallengeConfig configuration = ChallengeConfig(
            soundEnabled: config.soundEnabled,
            hapticEnabled: config.hapticEnabled,
            darkMode: config.darkMode,
            notificationsEnabled: config.notificationsEnabled
        );

        // 🚀 METHODS --------------------------------
        void toggleSound(val){
            ref.read(challengeConfigurationProvider.notifier).toggleSound();
        }

        void toggleVibration(val){
            ref.read(challengeConfigurationProvider.notifier).toggleHaptics();
        }

        Future<void> toggleNotifications(bool val) async {
            await ref.read(challengeConfigurationProvider.notifier).toggleNotifications();
        }

        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24)
            ),
            child: Column(
                children: [

                    Container(
                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(13), vertical: Gap(context).gap(10)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: configuration.soundEnabled ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                        ),
                        child: Row(
                            children: [
                                Icon(
                                    Icons.volume_up,
                                    size: Gap(context).gap(23),
                                    color: configuration.soundEnabled ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Sound Effects',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: configuration.soundEnabled ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                    fontWeight: FontWeight.w600
                                                )
                                            ),
                                            Text('Play sounds when typing',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                )
                                            )
                                        ]
                                    )
                                ),
                                SizedBox(width: 10),
                                _switchButton(context, configuration.soundEnabled, toggleSound  )
                            ]
                        )
                    ),

                    SizedBox(height: 15),

                    Container(
                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(13), vertical: Gap(context).gap(10)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: configuration.hapticEnabled ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                        ),
                        child: Row(
                            children: [
                                Icon(
                                    Icons.vibration,
                                    size: Gap(context).gap(23),
                                    color: configuration.hapticEnabled ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Vibration',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: configuration.hapticEnabled ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                    fontWeight: FontWeight.w600
                                                )
                                            ),
                                            Text('Vibrate on key press',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                )
                                            )
                                        ]
                                    )
                                ),
                                SizedBox(width: 10),
                                _switchButton(context, configuration.hapticEnabled, toggleVibration)
                            ]
                        )
                    ),

                    SizedBox(height: 15),

                    Container(
                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(13), vertical: Gap(context).gap(10)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: isDarkMode ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                        ),
                        child: Row(
                            children: [
                                Icon(
                                    Icons.dark_mode,
                                    size: Gap(context).gap(23),
                                    color: isDarkMode ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Dark Mode',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: isDarkMode ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                    fontWeight: FontWeight.w600
                                                )
                                            ),
                                            Text('Use dark theme',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                )
                                            )
                                        ]
                                    )
                                ),
                                SizedBox(width: 10),
                                _switchButton(context, isDarkMode, (val) {
                                    ref.read(themeProvider.notifier).setTheme(
                                        isDarkMode ? ThemeMode.light : ThemeMode.dark,
                                    );
                                })
                            ]
                        )
                    ),

                    SizedBox(height: 15),

                    Container(
                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(13), vertical: Gap(context).gap(10)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: configuration.notificationsEnabled ? getFigmaColor(context, 'Schemes/Surface Container Lowest') : getFigmaColor(context, 'Schemes/Surface Container High')
                        ),
                        child: Row(
                            children: [
                                Icon(
                                    Icons.notifications,
                                    size: Gap(context).gap(23),
                                    color: configuration.notificationsEnabled ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant')
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Notifications',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: configuration.notificationsEnabled ? getFigmaColor(context, 'Schemes/Primary') : getFigmaColor(context, 'Schemes/On Surface Variant'),
                                                    fontWeight: FontWeight.w600
                                                )
                                            ),
                                            Text('Daily remainders and updates',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: getFigmaColor(context, 'Schemes/On Surface Variant')
                                                )
                                            )
                                        ]
                                    )
                                ),
                                SizedBox(width: 10),
                                _switchButton(context, configuration.notificationsEnabled, (v) {
                                    toggleNotifications(v);
                                })
                            ]
                        )
                    ),

                    if (configuration.notificationsEnabled) ...[
                        SizedBox(height: Gap(context).gap(10)),
                        Material(
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () async {
                                    final prefs = ref.read(sharedPrefsServiceProvider);
                                    final h = prefs.getInt(kDailyReminderHourKey) ?? 9;
                                    final m = prefs.getInt(kDailyReminderMinuteKey) ?? 0;
                                    final picked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(hour: h, minute: m),
                                    );
                                    if (picked != null && context.mounted) {
                                        await ref
                                            .read(challengeConfigurationProvider.notifier)
                                            .setDailyReminderTime(picked.hour, picked.minute);
                                        setState(() {});
                                    }
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gap(context).gap(13),
                                        vertical: Gap(context).gap(10),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: getFigmaColor(
                                            context,
                                            'Schemes/Surface Container Lowest',
                                        ),
                                    ),
                                    child: Row(
                                        children: [
                                            Icon(
                                                Icons.schedule,
                                                size: Gap(context).gap(23),
                                                color: getFigmaColor(
                                                    context,
                                                    'Schemes/On Surface',
                                                ),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Text(
                                                            'Daily reminder time',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                                    color: getFigmaColor(
                                                                        context,
                                                                        'Schemes/On Surface',
                                                                    ),
                                                                    fontWeight: FontWeight.w600,
                                                                ),
                                                        ),
                                                        Text(
                                                            _reminderTimeLabel(context),
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
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
                                            Icon(
                                                Icons.chevron_right,
                                                size: KxScale(context).sp(30),
                                                color: getFigmaColor(
                                                    context,
                                                    'Schemes/On Surface',
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    ],

                    SizedBox(height: Gap(context).gap(10)),

                    Container(
                        padding: EdgeInsets.symmetric(horizontal: Gap(context).gap(13), vertical: Gap(context).gap(10)),
                        decoration: BoxDecoration(
                            color: getFigmaColor(context, 'Schemes/Surface Container'),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        child: Row(
                            children: [
                                Icon(
                                    Icons.help,
                                    size: Gap(context).gap(23),
                                    color: getFigmaColor(context, 'Schemes/On Surface')
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text('Help',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: getFigmaColor(context, 'Schemes/On Surface'),
                                                    fontWeight: FontWeight.w600
                                                )
                                            ),
                                            Text('Learn how to use this app',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    ),

                    if (kDebugMode) ...[
                        SizedBox(height: Gap(context).gap(10)),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: Gap(context).gap(13),
                                vertical: Gap(context).gap(10),
                            ),
                            decoration: BoxDecoration(
                                color: getFigmaColor(context, 'Schemes/Surface Container Lowest'),
                                borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        'Debug - Badge Testing',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: getFigmaColor(context, 'Schemes/On Surface'),
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                    SizedBox(height: Gap(context).gap(8)),
                                    Row(
                                        children: [
                                            Expanded(
                                                child: OutlinedButton(
                                                    onPressed: () async {
                                                        await ref
                                                            .read(badgeControllerProvider.notifier)
                                                            .resetProgressCounters();
                                                        if (!context.mounted) return;
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(
                                                                content: Text('Badge progress counters reset.'),
                                                            ),
                                                        );
                                                    },
                                                    child: const Text('Reset progress'),
                                                ),
                                            ),
                                            SizedBox(width: Gap(context).gap(8)),
                                            Expanded(
                                                child: FilledButton(
                                                    onPressed: () async {
                                                        await ref
                                                            .read(badgeControllerProvider.notifier)
                                                            .resetAllBadgesAndProgress();
                                                        if (!context.mounted) return;
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(
                                                                content: Text('All badges and progress reset.'),
                                                            ),
                                                        );
                                                    },
                                                    child: const Text('Reset all badges'),
                                                ),
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ],

                    SizedBox(height: Gap(context).gap(20))

                ]
            )
        );
    }

    String _reminderTimeLabel(BuildContext context) {
        final prefs = ref.read(sharedPrefsServiceProvider);
        final h = prefs.getInt(kDailyReminderHourKey) ?? 9;
        final m = prefs.getInt(kDailyReminderMinuteKey) ?? 0;
        return TimeOfDay(hour: h, minute: m).format(context);
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
