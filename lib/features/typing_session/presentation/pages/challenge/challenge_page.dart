import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:visai/core/config/ui/scale.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/core/theme/figma_color.dart';
import 'package:visai/domain/entities/gamification/gamification_entity.dart';
import 'package:visai/enums/StreakModeEnum.dart';
import 'package:visai/features/keyboard/presentation/keyboard.dart';
import 'package:visai/features/keyboard/presentation/providers/keyboard_provider.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/enums/session_status_enum.dart';
import 'package:visai/features/typing_session/presentation/pages/challenge/challenge_editor.dart';
import 'package:visai/features/typing_session/presentation/pages/challenge/challenge_home_screen.dart';
import 'package:visai/features/typing_session/presentation/pages/challenge/streak_challenge.dart';
import 'package:visai/features/typing_session/presentation/pages/session/reset/session_reset_page.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_ui_controller.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/streak_mode_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
// import 'package:visai/features/typing_session/presentation/riverpod/providers/challenge/challenge_tracking_provider.dart';
import 'package:visai/features/typing_session/presentation/widgets/bottom_navigation_bar.dart';
// import 'package:visai/features/typing_session/presentation/widgets/level_xp_indicator.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/appbar_actions.dart';
import 'package:visai/features/typing_session/presentation/widgets/practice/practice_reset_pause.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ChallengePage extends ConsumerStatefulWidget {
    const ChallengePage({super.key});

    @override
    ConsumerState<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends ConsumerState<ChallengePage> {
    final TextEditingController _controller = TextEditingController();
    final FocusNode _focusNode = FocusNode();
    late GamificationEntity? gamificationData;

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        // Reset to normal mode when challenge page becomes visible
        WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                    ref.read(streakModeProvider.notifier).setNormalMode();
                }
            });
    }

    @override
    void dispose() {
        _controller.dispose();
        _focusNode.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        // 🌐 PROVIDERS ------------------------------
        final challengeDifficulty = ref.watch(
            challengeDifficultyControllerProvider
        ); // 👈 CHALLENGE DIFFICULTY)
        final selectedChallengeSlide = ref.watch(
            selectedChallengeUIControllerProvider
        );
        final sessionState = ref.watch(sessionStatusControllerProvider);
        final keyboardRenderer = ref.watch(
            keyboardRendererProvider
        ); // 👈 KEYBOARD RENDERER
        final isKeyboardVisible = ref.watch(
            keyboardStatusProvider
        ); // 👈 KEYBOARD STATUS PROVIDER
        final keyboardController = ref.watch(
            keyboardControllerProvider(_controller)
        );
        gamificationData = ref.watch(gamificationDataControllerProvider);
        final streakmode = ref.watch(streakModeProvider).mode;
        // final challengeProvider = ref.read(challengeSessionToPrefsProvider);

        // challengeProvider.clear(kEasyChallenge);
        // challengeProvider.clear(kMediumChallenge);
        // challengeProvider.clear(kHardChallenge);

        // 📃 DECLARATION ----------------------------
        final sessionStatus = sessionState.mode == SessionMode.challenge
            ? sessionState.status
            : null;

        // 🚀 METHODS --------------------------------

        void handleChallengePause(TextEditingController controller) {
        }

        void handleChallengeReset(TextEditingController controller) {
            Get.to(
                () => SessionResetPage(controller: controller),
                arguments: kReset,
                transition: Transition.fadeIn,
                curve: Curves.easeInOutQuad
            );
        }

        // ⭐ Widget ---------------------------------
        return Scaffold(
            backgroundColor: getFigmaColor(context, 'Schemes/Surface Container'),
            appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: sessionStatus == SessionStatusEnum.start
                    ? getFigmaColor(context, 'Schemes/Surface Container')
                    : getFigmaColor(context, selectedChallengeSlide.bgColor),
                automaticallyImplyLeading: false,
                title: Text(
                    sessionStatus == SessionStatusEnum.start
                        ? challengeDifficulty.name[0].toUpperCase() +
                            challengeDifficulty.name.substring(1)
                        : 'Challenge',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: getFigmaColor(context, 'Schemes/On Surface Variant')
                    )
                ),
                actions: appBarActions(
                    context,
                    sessionStatus != SessionStatusEnum.start,
                    _controller
                )
            ), // 👈 PRACTICE APP BAR ACTIONS
            bottomNavigationBar: BottomNavigationBarWidget(controller: _controller),

            body: LayoutBuilder(
                builder: (context, constraints) {
                    return Stack(
                        children: [
                            AnimatedCrossFade(
                                firstChild: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: constraints.maxHeight,
                                        maxWidth: constraints.maxWidth
                                    ),
                                    child: streakmode == StreakModeEnum.restore
                                        ? StreakChallenge()
                                        : ChallengeHomeScreen()
                                ),
                                secondChild: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: constraints.maxWidth,
                                        maxHeight: constraints.maxHeight
                                    ),
                                    child: ChallengeEditor(
                                        gamificationData: gamificationData,
                                        controller: _controller,
                                        focusNode: _focusNode
                                    )
                                ),
                                crossFadeState: sessionStatus == SessionStatusEnum.start
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 600)
                            ),

                            AnimatedSlide(
                                // 👈 KEYBOARD DRAWER
                                offset: isKeyboardVisible ? Offset.zero : const Offset(0, 1),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOutQuad,
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                            PracticeResetPause(
                                                handlePause: handleChallengePause,
                                                handleReset: handleChallengeReset,
                                                controller: _controller
                                            ),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Gap(context).gap(8),
                                                    vertical: Gap(context).gap(10)
                                                ),
                                                width: double.infinity,
                                                color: getFigmaColor(
                                                    context,
                                                    'Schemes/Surface Container'
                                                ),
                                                child: Keyboard(
                                                    controller: keyboardController,
                                                    renderer: keyboardRenderer
                                                )
                                            )
                                        ]
                                    )
                                )
                            )
                        ]
                    );
                }
            )
        );
    }
}
