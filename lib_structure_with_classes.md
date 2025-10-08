# lib/ Folder Structure with Class Names

Note: Generated files (`*.g.dart`, `*.freezed.dart`) are omitted. Files without classes are marked as “(no class)”.

## app/
- app/app.dart
  - App
- app/layouts/mobile_layout.dart
  - MobileLayout
  - _MobileLayoutState

## core/
- core/constants/endpoints.dart (no class)
- core/constants/gamification.dart (no class)
- core/utils/characters_utils.dart (no class)
- core/widgets/switch_theme_mode.dart
  - SwitchThemeMode

## data/
- data/repositories/gamification/gamification_repo_impl.dart
  - GamificationRepoImpl
- data/sources/local/gamification/gamification_local_source.dart
  - GamificationLocalSourceFetcher
- data/sources/remote/gamification/gamification_api_source.dart
  - GamificationApiSourceFetcher
- data/sources/db_helper.dart
  - AppDatabase

## di/
- di/providers/app_initialilizer/app_initializer.dart
  - AppInitializer
- di/providers/dio/dio_provider.dart (no class)
- di/providers/navigation/navigation_provider.dart (no class)
- di/providers/shared_preferences/shared_prefs_provider.dart (no class)
- di/providers/theme/theme_provider.dart
  - ThemeNotifier
- di/providers/auth/auth_provider.dart (no class)

## domain/
- domain/contracts/gamification/gamification_data_fetcher.dart
  - GamificationDataFetcher (abstract interface)
- domain/entities/difficulty_criteria/difficulty_criteria_entity.dart
  - DifficultyCriteriaEntity (freezed abstract)
- domain/entities/gamification/gamification_entity.dart
  - GamificationEntity (freezed abstract)
- domain/entities/levels/level_entity.dart
  - LevelEntity (freezed abstract)
- domain/repositories/gamification/gamification_repository.dart
  - GamificationRepository (abstract)
- domain/usecases/gamification/gamification_cache.dart
  - GamificationCache

## features/authentication/
- features/authentication/presentation/pages/login.dart
  - LoginPage
  - _LoginPageState
- features/authentication/presentation/pages/signup.dart
  - SignupPage
  - _SignupPageState
- features/authentication/presentation/providers/auth_service_provider.dart (no class)
- features/authentication/presentation/widgets/form-text-field.dart
  - FormTextField
  - _FormTextFieldState
- services/authentication/authentication_service.dart
  - AuthService

## features/typing_session/
- features/typing_session/domain/contracts/content/text_content_fetcher.dart
  - TextContentFetcher (abstract interface)
- features/typing_session/domain/entities/content/text_content.dart
  - TextContent (freezed abstract)
- features/typing_session/domain/entities/practice/practice_config.dart
  - PracticeConfig (freezed)
- features/typing_session/domain/enums/multipliers_enums.dart (no class)
- features/typing_session/domain/enums/practice_status_enum.dart (no class)
- features/typing_session/domain/enums/session_mode.dart (no class)
- features/typing_session/domain/repositories/content/text_content_repo.dart
  - TextContentRepository (abstract)

- features/typing_session/data/dto/content/text_content.dto.dart
  - TextContentDto (freezed abstract)
- features/typing_session/data/repositories_impl/content/text_content_repo_impl.dart
  - TextContentRepoImpl
- features/typing_session/data/sources/local/content/content_local_source.dart
  - ContentLocalSourceFetcher
- features/typing_session/data/sources/remote/content/content_api_source.dart
  - ContentApiSourceFetcher

- features/typing_session/presentation/pages/challenge/challenge_page.dart
  - ChallengePage
  - _ChallengePageState
- features/typing_session/presentation/pages/challenge/challenge_home_screen.dart
  - ChallengeHomeScreen
  - _State
- features/typing_session/presentation/pages/practice/practice_page.dart
  - PracticePage
  - _PracticePageState
- features/typing_session/presentation/pages/practice/practice_editor_page.dart
  - PracticeEditorPage
  - _PracticeEditorPage
- features/typing_session/presentation/pages/practice/randomize/practice_randomize_page.dart
  - PracticeRandomizePage
  - _PracticeRandomizePageState
- features/typing_session/presentation/pages/practice/complete/practice_complete_page.dart (UI page; classes likely present if implemented) (not scanned)
- features/typing_session/presentation/pages/practice/stop/practice_stop_page.dart (UI page; not scanned)
- features/typing_session/presentation/pages/practice/settings/practice_settings_page.dart
  - PracticeSettingsPage
  - _PracticeSettingsPageState

- features/typing_session/presentation/riverpod/controllers/content/preload_initial_content_controller_provider.dart (no class)
- features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart
  - TextContentController
- features/typing_session/presentation/riverpod/controllers/gamification/gamification_controller_provider.dart
  - GamificationDataController
- features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart
  - PracticeConfigController
- features/typing_session/presentation/riverpod/controllers/challenge/challenge_ui_controller.dart (no class definitions)
- features/typing_session/presentation/riverpod/providers/content/text_content_repo_provider.dart (no class)
- features/typing_session/presentation/riverpod/providers/gamification/gamification_repo_provider.dart (no class)

- features/typing_session/presentation/widgets/animated_context_board.dart
  - AnimatedContentBoard
  - _AnimatedContentBoardState
  - TypingArea
  - _TypingAreaState
- features/typing_session/presentation/widgets/bottom_navigation_bar.dart
  - BottomNavigationBarWidget
- features/typing_session/presentation/widgets/level_xp_indicator.dart
  - LevelXPIndicatior
- features/typing_session/presentation/widgets/main_metrics_bar.dart
  - MainMetricsBar
  - _MainMetricsBarState
- features/typing_session/presentation/widgets/metrics_info_badge.dart (not scanned)
- features/typing_session/presentation/widgets/metrics_stat_badge.dart (not scanned)
- features/typing_session/presentation/widgets/practice/appbar_actions.dart (not scanned)
- features/typing_session/presentation/widgets/practice/difficulty_segment_buttons.dart
  - DifficultySegmentButtons
- features/typing_session/presentation/widgets/practice/practise_settings_button.dart
  - PracticeSettingButtons
- features/typing_session/presentation/widgets/practice/settings/blind_mode.dart (not scanned)
- features/typing_session/presentation/widgets/practice/settings/segmented_buttons.dart (not scanned)
- features/typing_session/presentation/widgets/practice/settings/switch_button.dart (not scanned)
- features/typing_session/presentation/widgets/practice/settings/switch_settings_card.dart (not scanned)
- features/typing_session/presentation/widgets/challenge/challenge_start_button.dart
  - ChallengeStartButton
  - _State
- features/typing_session/presentation/widgets/challenge/weekly_streak_display.dart
  - WeekilyStreakDisplay
  - _WeekilyStreakDisplayState
- features/typing_session/presentation/widgets/challenge/streak_badge.dart
  - StreakBadge
- features/typing_session/presentation/widgets/challenge/bend_line_painter.dart
  - BendLinePainter
- features/typing_session/presentation/widgets/challenge/slide_card_widgets/slide_card_difficulty_xp_badges.dart
  - SlideCardDifficultyXpBadges
- features/typing_session/presentation/widgets/challenge/slide_card_widgets/slide_stats_badges.dart
  - SlideStatsBadge
  - _SlideStatsBadgeState
- features/typing_session/presentation/widgets/challenge/slide_card_widgets/challenge_detail_card.dart
  - ChallengeDetailCard
  - _ChallengeDetailCardState

- features/typing_session/usecases/gamification/calculate_xp.dart (no class)
- features/typing_session/usecases/content/text_content_cache.dart
  - TextContentCache

- features/debug/print_all_content.dart (no active class)

## services/
- services/shared_preferences/shared_prefs_service.dart
  - SharedPrefsService (abstract)
  - SharedPrefsServiceImpl

## features/user_profile/
- features/user_profile/presentation/pages/profile_page.dart
  - ProfilePage
  - _ProfilePageState

## main.dart (entrypoint) (no class)
