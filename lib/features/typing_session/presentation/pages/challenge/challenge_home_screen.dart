import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/core/config/ui/scale.dart';
import 'package:kothai_app/core/theme/figma_color.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/challenge/challenge_ui_controller.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_controller_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/challenge/challenge_tracking_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/challenge_start_button.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/slide_card_widgets/challenge_detail_card.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/slide_card_widgets/slide_card_difficulty_xp_badges.dart';
import 'package:kothai_app/features/typing_session/presentation/widgets/challenge/slide_card_widgets/slide_stats_badges.dart';
import 'package:logger/logger.dart';

class ChallengeHomeScreen extends ConsumerStatefulWidget {
    const ChallengeHomeScreen({super.key});

    @override
    ConsumerState<ChallengeHomeScreen> createState() => _State();
}

class _State extends ConsumerState<ChallengeHomeScreen> {
    // 📃 DECLARATION ----------------------------
    final _logger = Logger();
    late double slideAngle;
    late double slideHeightMultiplier;
    late int slideIndex;

    // 🔁 INIT STATE METHOD ---------------------
    @override
    void initState() {
        super.initState();
        slideAngle = 0;
        slideHeightMultiplier = 0.65;
        slideIndex = 0;
    }

    // 👇 HANDLE SLIDE ON SWIPE
    void _handleSlide(details) {
        if ((details.primaryVelocity ?? 0) < 0) {
            // Swipe Left → increase angle
            if (slideAngle > -2.0) {
                setState(() {
                        slideAngle -= 1; // try radians (about 11.5°)
                        slideIndex += 1;
                    });
            }
        }

        if ((details.primaryVelocity ?? 0) > 0) {
            // Swipe Right → decrease angle
            if (slideAngle < 0) {
                setState(() {
                        slideAngle += 1;
                        slideIndex -= 1;
                    });
            }
        }

        // 🌐 PROVIDERS ------------------------------
        // 👇 Challenge Index Provider
        ref.read(challengeIndexProvider.notifier).state = slideIndex;
    }

    // 👇 GET CHALLENGE TEXT BASED ON SLIDE INDEX AND BLOCKED STATUS
    String _getChallengeText(
        int slideIndex,
        Set<DifficultyEnum> hiddenChallenges
    ) {
        DifficultyEnum currentDifficulty;
        switch (slideIndex) {
            case 0:
                currentDifficulty = DifficultyEnum.easy;
                break;
            case 1:
                currentDifficulty = DifficultyEnum.medium;
                break;
            case 2:
                currentDifficulty = DifficultyEnum.hard;
                break;
            default:
            currentDifficulty = DifficultyEnum.easy;
        }

        final isBlocked = hiddenChallenges.contains(currentDifficulty);
        return isBlocked
            ? 'Challenge is \n met & Mastered'
            : 'Brand new \n challenge is ready';
    }

    @override
    Widget build(BuildContext context) {
        // 🌐 PROVIDERS ------------------------------
        final selectedChallengeSlide = ref.watch(
            selectedChallengeUIControllerProvider
        );
        final sessionStatusController = ref.read(
            sessionStatusControllerProvider.notifier
        );
        final sessionEngineController = ref.read(
            sessionControllerProvider.notifier
        );
        final challengeDifficultyController = ref.read(
            challengeDifficultyControllerProvider.notifier
        );
        final hiddenChallenges = ref.watch(hiddenChallengesSyncProvider);

        // Debug logging to see what's happening
        // _logger.i(
        //   'Hidden challenges: ${hiddenChallenges.map((e) => e.name).join(', ')}',
        // );

        // 🚀 METHODS --------------------------------
        Future<void> startChallenge(slideIndex) async {
            DifficultyEnum selectedDifficulty;
            switch (slideIndex) {
                case 0:
                    selectedDifficulty = DifficultyEnum.easy;
                    break;
                case 1:
                    selectedDifficulty = DifficultyEnum.medium;
                    break;
                case 2:
                    selectedDifficulty = DifficultyEnum.hard;
                    break;
                default:
                selectedDifficulty = DifficultyEnum.easy;
            }

            // Don't start if challenge is blocked
            if (hiddenChallenges.contains(selectedDifficulty)) {
                return;
            }

            challengeDifficultyController.setDifficulty(selectedDifficulty);
            sessionStatusController.updateMode(SessionMode.challenge);
            // Roll a new paragraph explicitly and wait for it to complete
            await ref.read(textContentControllerProvider.notifier).rollNewContent();
            sessionStatusController.updateStatus(SessionStatusEnum.start);
            await sessionEngineController.start();
        }

        // ⭐ Widget ---------------------------------
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
                                color: getFigmaColor(context, selectedChallengeSlide.bgColor),
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
                                        _getChallengeText(slideIndex, hiddenChallenges),
                                        textScaleFactor: 1.0,
                                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                            color: getFigmaColor(
                                                context,
                                                'State Layers/On Background/Opacity-16'
                                            ),
                                            fontFamily: 'NotoSansTamil',
                                            fontSize: 38,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.9,
                                        ),
                                        textAlign: TextAlign.center
                                    )
                                )
                            )
                        )
                    ),

                    Positioned.fill(
                        child: GestureDetector(
                            onHorizontalDragEnd: (details) => _handleSlide(details),
                            child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                    ChallengeDetailCard(
                                        opacity: slideAngle == 0 ? 1 : 0,
                                        slideAngle: 0 + slideAngle,
                                        slideHeightMultiplier: slideHeightMultiplier,
                                        image: hiddenChallenges.contains(DifficultyEnum.easy)
                                            ? 'assets/images/complete_challenge_green.png'
                                            : 'assets/images/start_challenge_green.png',
                                        isBlocked: hiddenChallenges.contains(DifficultyEnum.easy),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                // TOP BADGES
                                                SlideCardDifficultyXpBadges(
                                                    difficulty:
                                                    DifficultyEnum.values[0].name[0].toUpperCase() +
                                                        DifficultyEnum.values[0].name.substring(1),
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
                                                    data: '50',
                                                    label: 'Words'
                                                ),
                                                SizedBox(height: Gap(context).gap(8)),
                                                SlideStatsBadge(
                                                    icon: Icons.my_location,
                                                    data: '90%',
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
                                    ),

                                    ChallengeDetailCard(
                                        opacity: slideAngle == -1 ? 1 : 0,
                                        slideAngle: 1 + slideAngle,
                                        slideHeightMultiplier: slideHeightMultiplier,
                                        image: hiddenChallenges.contains(DifficultyEnum.medium)
                                            ? 'assets/images/complete_challenge_blue.png'
                                            : 'assets/images/start_challenge_blue.png',
                                        isBlocked: hiddenChallenges.contains(DifficultyEnum.medium),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                // TOP BADGES
                                                SlideCardDifficultyXpBadges(
                                                    difficulty:
                                                    DifficultyEnum.values[1].name[0].toUpperCase() +
                                                        DifficultyEnum.values[1].name.substring(1),
                                                    xp: '+250'
                                                ),
                                                SizedBox(height: Gap(context).gap(20)),
                                                Text(
                                                    'Type 30 WPM with 95% + Accuracy',
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
                                                    data: '45',
                                                    label: 'Words'
                                                ),
                                                SizedBox(height: Gap(context).gap(8)),
                                                SlideStatsBadge(
                                                    icon: Icons.my_location,
                                                    data: '90%',
                                                    label: 'Min. Accuracy'
                                                ),
                                                SizedBox(height: Gap(context).gap(8)),
                                                SlideStatsBadge(
                                                    icon: Icons.schedule,
                                                    data: '4:00',
                                                    label: 'Max. Time'
                                                )
                                            ]
                                        )
                                    ),

                                    ChallengeDetailCard(
                                        opacity: slideAngle == -2 ? 1 : 0,
                                        slideAngle: 2 + slideAngle,
                                        slideHeightMultiplier: slideHeightMultiplier,
                                        image: hiddenChallenges.contains(DifficultyEnum.hard)
                                            ? 'assets/images/complete_challenge_orange.png'
                                            : 'assets/images/start_challenge_pink.png',
                                        isBlocked: hiddenChallenges.contains(DifficultyEnum.hard),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                // TOP BADGES
                                                SlideCardDifficultyXpBadges(
                                                    difficulty:
                                                    DifficultyEnum.values[2].name[0].toUpperCase() +
                                                        DifficultyEnum.values[2].name.substring(1),
                                                    xp: '+450'
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
                                                    data: '90%',
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
                        children: [
                            ChallengeStartButton(
                                handleStart: () => startChallenge(slideIndex),
                                currentIndex: slideIndex
                            )
                        ]
                    )
                ]
            )
        );
    }
}
