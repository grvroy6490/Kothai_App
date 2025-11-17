import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/slide_card_widgets/challenge_detail_card.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/slide_card_widgets/slide_card_difficulty_xp_badges.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/slide_card_widgets/slide_stats_badges.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/streak_challenge_button.dart';

class StreakChallenge extends ConsumerStatefulWidget {
    const StreakChallenge({super.key});

    @override
    ConsumerState<StreakChallenge> createState() => _StreakChallengeState();
}

class _StreakChallengeState extends ConsumerState<StreakChallenge> {
    @override
    Widget build(BuildContext context) {
        // 🌐 PROVIDERS ------------------------------
        final sessionStatusController = ref.read(
            sessionStatusControllerProvider.notifier
        );
        final sessionEngineController = ref.read(
            sessionControllerProvider.notifier
        );
        final challengeDifficultyController = ref.read(
            challengeDifficultyControllerProvider.notifier
        );

        // 🚀 METHODS --------------------------------
        Future<void> startChallenge() async {
            challengeDifficultyController.setDifficulty(DifficultyEnum.hard);
            sessionStatusController.updateMode(SessionMode.challenge);
            // Roll a new paragraph explicitly and wait for it to complete
            await ref.read(textContentControllerProvider.notifier).rollNewContent();
            sessionStatusController.updateStatus(SessionStatusEnum.start);
            await sessionEngineController.start();
        }

        return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
                clipBehavior: Clip.none, // allow overflow
                children: [
                    Positioned(
                        top: 0,
                        left:
                        -MediaQuery.of(context).size.width *
                            0.25, // shift left so it stays centered
                        child: Container(
                            width:
                            MediaQuery.of(context).size.width *
                                1.5, // much wider than screen
                            height: MediaQuery.of(context).size.height * 0.35,
                            decoration: BoxDecoration(
                                color: getFigmaColor(
                                    context,
                                    'State Layers/On Secondary Fixed Variant/Opacity-16'
                                ),
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(230),
                                    bottomLeft: Radius.circular(230)
                                )
                            )
                        )
                    ),

                    Positioned(
                        top: 7,
                        left: 0,
                        right: 0,
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                                width: double.infinity,
                                child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                            Colors.black45,
                                            getFigmaColor(
                                                context,
                                                'State Layers/On Background/Opacity-00'
                                            )
                                        ],
                                        stops: const [0.5, 1]
                                    ).createShader(bounds),
                                    child: Text(
                                        "Don't lose hope, Get back on streak!",
                                        textScaleFactor: 1.0,
                                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                            color: getFigmaColor(
                                                context,
                                                'State Layers/On Background/Opacity-16'
                                            ),
                                            fontFamily: 'NotoSansTamil',
                                            fontSize: 38,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.9
                                        ),
                                        textAlign: TextAlign.center
                                    )
                                )
                            )
                        )
                    ),

                    Positioned.fill(
                        child: GestureDetector(
                            onHorizontalDragEnd: (details) =>
                            () => {},
                            child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                    ChallengeDetailCard(
                                        opacity: 1,
                                        slideAngle: 0,
                                        image: 'assets/images/start_challenge_orange.png',
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                // TOP BADGES
                                                SlideCardDifficultyXpBadges(
                                                    difficulty:
                                                    DifficultyEnum.hard.name[0].toUpperCase() +
                                                        DifficultyEnum.hard.name.substring(1),
                                                    xp: '+150'
                                                ),
                                                SizedBox(height: Gap(context).gap(20)),
                                                Text(
                                                    'Type 50 words with 90% + Accuracy',
                                                    style: Theme.of(context).textTheme.headlineSmall
                                                        ?.copyWith(
                                                            color: getFigmaColor(
                                                                context,
                                                                'Fixed/White Fixed'
                                                            ),
                                                            fontWeight: FontWeight.bold
                                                        )
                                                ),
                                                SizedBox(height: Gap(context).gap(20)),
                                                // STATS BADGE
                                                SlideStatsBadge(
                                                    icon: Icons.text_fields,
                                                    data: '40',
                                                    label: 'Words'
                                                ),
                                                SizedBox(height: Gap(context).gap(8)),
                                                SlideStatsBadge(
                                                    icon: Icons.my_location,
                                                    data: '98%',
                                                    label: 'Min. Accuracy'
                                                ),
                                                SizedBox(height: Gap(context).gap(8)),
                                                SlideStatsBadge(
                                                    icon: Icons.schedule,
                                                    data: '5:00',
                                                    label: 'Max. Time'
                                                )
                                            ]
                                        )
                                    )
                                ]
                            )
                        )
                    ),

                    // START RADIAL BUTTON
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [StreakChallengeButton(handleStart: startChallenge)]
                    )
                ]
            )
        );
    }
}
