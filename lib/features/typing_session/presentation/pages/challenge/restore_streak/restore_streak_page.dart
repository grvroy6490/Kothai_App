import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/presentation/pages/challenge/streak_challenge.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/challenge/streak_mode_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/gamification/streak_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';

class RestoreStreakPage extends ConsumerStatefulWidget {
    const RestoreStreakPage({super.key});

    @override
    ConsumerState<RestoreStreakPage> createState() => _RestoreStreakPageState();
}

class _RestoreStreakPageState extends ConsumerState<RestoreStreakPage> {
    @override
    Widget build(BuildContext context) {
        final args = Get.arguments;

        // 🚀 METHODS --------------------------------
        void handleRestoreStreak() {
            if (args != null && args['day'] != null) {
                final dayDate = args['day'] as DateTime;
                // Set restore mode with the missing day date
                ref.read(streakModeProvider.notifier).setRestoreMode(dayDate);
                Get.back();
            }
        }

        void rejectRestoreStreak() {
            Get.back();
        }

        // ⭐ Widget ---------------------------------
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Background'),
            body: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                    children: [
                        Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                'assets/images/Pattern.png',
                                width: double.infinity,
                                height: double.infinity
                            )
                        ),

                        SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: Stack(
                                                children: [
                                                    Positioned(
                                                        left: 0,
                                                        bottom: 0,
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Container(
                                                                constraints: BoxConstraints(
                                                                    minWidth:
                                                                    MediaQuery.of(context).size.width - 32
                                                                ),
                                                                height: Gap(context).gap(270),
                                                                padding: EdgeInsets.all(Gap(context).gap(16)),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    color: getFigmaColor(
                                                                        context,
                                                                        'State Layers/Secondary/Opacity-16'
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    ),

                                                    Padding(
                                                        padding: EdgeInsets.all(Gap(context).gap(16)),
                                                        child: Column(
                                                            children: [
                                                                Container(
                                                                    padding: EdgeInsets.all(Gap(context).gap(25)),
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                            begin: Alignment.topCenter,
                                                                            end: Alignment.bottomCenter,
                                                                            colors: [
                                                                                getFigmaColor(
                                                                                    context,
                                                                                    'Palettes/Secondary 95'
                                                                                ),
                                                                                getFigmaColor(
                                                                                    context,
                                                                                    'Palettes/Secondary 80'
                                                                                )
                                                                            ]
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(100)
                                                                    ),
                                                                    child: Icon(
                                                                        Icons.local_fire_department_outlined,
                                                                        size: KxScale(context).sp(60),
                                                                        color: getFigmaColor(
                                                                            context,
                                                                            'Schemes/Secondary Container'
                                                                        )
                                                                    )
                                                                ),
                                                                SizedBox(height: Gap(context).gap(30)),
                                                                Text(
                                                                    "Oh no! You've lost your streak. Would you like to restore it?",
                                                                    style: Theme.of(context).textTheme.titleLarge
                                                                        ?.copyWith(
                                                                            color: getFigmaColor(
                                                                                context,
                                                                                'Schemes/Secondary'
                                                                            ),
                                                                            fontWeight: FontWeight.w600
                                                                        )
                                                                ),
                                                                SizedBox(height: Gap(context).gap(10)),
                                                                SizedBox(
                                                                    width:
                                                                    MediaQuery.of(context).size.width * 0.8,
                                                                    child: Center(
                                                                        child: Text(
                                                                            'To restore your streak, you need to complete the special challenge added to your updates.',
                                                                            style: Theme.of(context)
                                                                                .textTheme
                                                                                .bodyLarge
                                                                                ?.copyWith(
                                                                                    color: getFigmaColor(
                                                                                        context,
                                                                                        'Schemes/On Surface'
                                                                                    )
                                                                                ),
                                                                            textAlign: TextAlign.center
                                                                        )
                                                                    )
                                                                ),

                                                                SizedBox(height: Gap(context).gap(20)),
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    spacing: Gap(context).gap(16),
                                                                    children: [
                                                                        Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                    padding: WidgetStateProperty.all(
                                                                                        EdgeInsets.symmetric(
                                                                                            horizontal: 0,
                                                                                            vertical: Gap(context).gap(16)
                                                                                        )
                                                                                    ),
                                                                                    backgroundColor:
                                                                                    WidgetStateProperty.all(
                                                                                        getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/On Secondary'
                                                                                        )
                                                                                    ),
                                                                                    foregroundColor:
                                                                                    WidgetStateProperty.all(
                                                                                        getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/Secondary'
                                                                                        )
                                                                                    ),
                                                                                    elevation: WidgetStateProperty.all(0)
                                                                                ),

                                                                                onPressed: () => rejectRestoreStreak(),
                                                                                child: Text(
                                                                                    'No',
                                                                                    style: Theme.of(context)
                                                                                        .textTheme
                                                                                        .bodyLarge
                                                                                        ?.copyWith(
                                                                                            color: getFigmaColor(
                                                                                                context,
                                                                                                'Schemes/Secondary'
                                                                                            )
                                                                                        )
                                                                                )
                                                                            )
                                                                        ),

                                                                        Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(
                                                                                    backgroundColor:
                                                                                    WidgetStateProperty.all(
                                                                                        getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/Secondary'
                                                                                        )
                                                                                    ),
                                                                                    foregroundColor:
                                                                                    WidgetStateProperty.all(
                                                                                        getFigmaColor(
                                                                                            context,
                                                                                            'Schemes/On Secondary'
                                                                                        )
                                                                                    ),
                                                                                    padding: WidgetStateProperty.all(
                                                                                        EdgeInsets.symmetric(
                                                                                            horizontal: 0,
                                                                                            vertical: Gap(context).gap(16)
                                                                                        )
                                                                                    ),
                                                                                    elevation: WidgetStateProperty.all(0)
                                                                                ),
                                                                                onPressed: () => handleRestoreStreak(),
                                                                                child: Text(
                                                                                    'Yes, Restore it',
                                                                                    style: Theme.of(
                                                                                        context
                                                                                    ).textTheme.bodyLarge
                                                                                )
                                                                            )
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    ]
                )
            )
        );
    }
  }
