
lib/
|   |-- app/
|   |   |-- layouts/
|   |   |   |-- mobile_layout.dart
|   |   |   `-- tablet_layout.dart
|   |   |-- app.dart
|   |   |-- layout_builder.dart
|   |   `-- README.md
|   |-- core/
|   |   |-- config/
|   |   |   `-- ui/
|   |   |       `-- scale.dart
|   |   |-- constants/
|   |   |   |-- endpoints.dart
|   |   |   `-- typin_session_constants.dart
|   |   |-- enums/
|   |   |-- errors/
|   |   |   `-- default_404.dart
|   |   |-- routing/
|   |   |   `-- routes.dart
|   |   |-- theme/
|   |   |   |-- app_typography.dart
|   |   |   |-- app_typography_scaled.dart
|   |   |   |-- color_flatten.dart
|   |   |   |-- color_scheme_data.dart
|   |   |   |-- custom_colors.dart
|   |   |   |-- figma_color.dart
|   |   |   `-- theme_manager.dart
|   |   |-- utils/
|   |   |   |-- breakpoint_helper.dart
|   |   |   |-- characters_utils.dart
|   |   |   `-- device_utils.dart
|   |   |-- widgets/
|   |   |   `-- switch_theme_mode.dart
|   |   `-- README.md
|   |-- data/
|   |   |-- mappers/
|   |   |-- repositories/
|   |   |-- sources/
|   |   |   |-- local/
|   |   |   `-- remote/
|   |   `-- README.md
|   |-- di/
|   |   |-- poviders/
|   |   |   |-- difficulty_criteia_provider.dart
|   |   |   |-- dio_provider.dart
|   |   |   |-- navigation_provider.dart
|   |   |   |-- shared_prefs_provider.dart
|   |   |   `-- theme_provider.dart
|   |   `-- README.md
|   |-- domain/
|   |   |-- entities/
|   |   |-- repositories/
|   |   |-- usecases/
|   |   `-- README.md
|   |-- features/
|   |   |-- authentication/
|   |   |   |-- data/
|   |   |   |-- domain/
|   |   |   |   |-- contracts/
|   |   |   |   `-- enums/
|   |   |   `-- presentation/
|   |   |       |-- pages/
|   |   |       |-- providers/
|   |   |       `-- widgets/
|   |   |-- navigation/
|   |   |   `-- usecase/
|   |   |       `-- select_nav.dart
|   |   |-- splash/
|   |   |   `-- splash_page.dart
|   |   |-- typing_session/
|   |   |   |-- data/
|   |   |   |   |-- dto/
|   |   |   |   |   `-- content/
|   |   |   |   |       |-- text_paragraph_dto.dart
|   |   |   |   |       |-- text_paragraph_dto.freezed.dart
|   |   |   |   |       `-- text_paragraph_dto.g.dart
|   |   |   |   |-- repositories_impl/
|   |   |   |   |   |-- content/
|   |   |   |   |   |   `-- text_repository_impl.dart
|   |   |   |   |   `-- difficulty_criteria/
|   |   |   |   |       `-- difficulty_criteria_repository_impl.dart
|   |   |   |   `-- sources/
|   |   |   |       |-- local/
|   |   |   |       |   |-- content/
|   |   |   |       |   |   |-- asset_texts_source.dart
|   |   |   |       |   |   `-- text_cache.dart
|   |   |   |       |   `-- difficulty_criteria/
|   |   |   |       |       `-- difficulty_criteria_cache.dart
|   |   |   |       `-- remote/
|   |   |   |           `-- content/
|   |   |   |               `-- text_api_service.dart
|   |   |   |-- domain/
|   |   |   |   |-- contracts/
|   |   |   |   |   |-- keyboard_controller.dart
|   |   |   |   |   `-- keyboard_renderer.dart
|   |   |   |   |-- entities/
|   |   |   |   |   |-- content/
|   |   |   |   |   |   |-- text_paragraph.dart
|   |   |   |   |   |   `-- text_paragraph.freezed.dart
|   |   |   |   |   |-- difficulty/
|   |   |   |   |   |   |-- difficulty_criteria.dart
|   |   |   |   |   |   |-- difficulty_criteria.freezed.dart
|   |   |   |   |   |   `-- difficulty_criteria.g.dart
|   |   |   |   |   `-- practice/
|   |   |   |   |       |-- config_switch_option.dart
|   |   |   |   |       |-- practice_config.dart
|   |   |   |   |       |-- practice_config.freezed.dart
|   |   |   |   |       `-- practice_config.g.dart
|   |   |   |   |-- enums/
|   |   |   |   |   |-- difficulty/
|   |   |   |   |   |   |-- accuracy_threshold_enum.dart
|   |   |   |   |   |   |-- difficulty_enum.dart
|   |   |   |   |   |   |-- difficulty_time_limit_enum.dart
|   |   |   |   |   |   `-- difficulty_wpm_enum.dart
|   |   |   |   |   |-- expertise_mode_enums.dart
|   |   |   |   |   |-- keyboard_layout_type_enum.dart
|   |   |   |   |   |-- keyboard_type_enum.dart
|   |   |   |   |   |-- multipliers_enums.dart
|   |   |   |   |   |-- practice_status_enum.dart
|   |   |   |   |   |-- session_mode.dart
|   |   |   |   |   |-- text_length_enum.dart
|   |   |   |   |   `-- text_size_enum.dart
|   |   |   |   `-- repositories/
|   |   |   |       |-- content/
|   |   |   |       |   `-- text_repository.dart
|   |   |   |       `-- difficulty_criteria/
|   |   |   |           `-- difficulty_criteria_repository.dart
|   |   |   |-- presentation/
|   |   |   |   |-- pages/
|   |   |   |   |   |-- challenge/
|   |   |   |   |   `-- practice/
|   |   |   |   |       |-- complete/
|   |   |   |   |       |   `-- practice_complete_page.dart
|   |   |   |   |       |-- pause/
|   |   |   |   |       |   |-- practice_pause_page.dart
|   |   |   |   |       |   |-- star_burst_badge.dart
|   |   |   |   |       |   `-- stats_badge.dart
|   |   |   |   |       |-- randomize/
|   |   |   |   |       |   `-- practice_randomize.dart
|   |   |   |   |       |-- reset/
|   |   |   |   |       |   `-- practice_reset_page.dart
|   |   |   |   |       |-- settings/
|   |   |   |   |       |   `-- practise_settings_page.dart
|   |   |   |   |       |-- stop/
|   |   |   |   |       |   `-- practice_stop_page.dart
|   |   |   |   |       |-- practice_editor_page.dart
|   |   |   |   |       `-- practice_page.dart
|   |   |   |   |-- providers/
|   |   |   |   |   |-- content/
|   |   |   |   |   |   |-- text_providers.dart
|   |   |   |   |   |   `-- text_providers.g.dart
|   |   |   |   |   |-- difficulty/
|   |   |   |   |   |   |-- difficulty_criteria_provider.dart
|   |   |   |   |   |   `-- difficulty_criteria_provider.g.dart
|   |   |   |   |   |-- keyboard/
|   |   |   |   |   |   `-- keyboard_provider.dart
|   |   |   |   |   |-- practice/
|   |   |   |   |   |   |-- practice_status_provider.dart
|   |   |   |   |   |   `-- practise_config_provider.dart
|   |   |   |   |   |-- text_preloader_provider.dart
|   |   |   |   |   `-- text_preloader_provider.g.dart
|   |   |   |   `-- widgets/
|   |   |   |       |-- challenge/
|   |   |   |       |-- keyboard/
|   |   |   |       |   |-- tamil_keyboard/
|   |   |   |       |   |   |-- letters.dart
|   |   |   |       |   |   |-- tamil_keyboard.dart
|   |   |   |       |   |   |-- tamil_keyboard_renderer.dart
|   |   |   |       |   |   |-- tamil_numeric_layout.dart
|   |   |   |       |   |   |-- tamil_regualr_layout.dart
|   |   |   |       |   |   `-- tamil_symbolic_layout.dart
|   |   |   |       |   |-- key_button.dart
|   |   |   |       |   |-- key_model.dart
|   |   |   |       |   |-- keyboard.dart
|   |   |   |       |   `-- keyboard_layout.dart
|   |   |   |       `-- practice/
|   |   |   |           |-- settings/
|   |   |   |           |   |-- blind_modee.dart
|   |   |   |           |   |-- segmented_buttons.dart
|   |   |   |           |   |-- setting_title_bar.dart
|   |   |   |           |   |-- switch_button.dart
|   |   |   |           |   `-- switch_setting_card.dart
|   |   |   |           |-- animated_content_board.dart
|   |   |   |           |-- app_bar.dart
|   |   |   |           |-- appbar_actions.dart
|   |   |   |           |-- difficulty_segment_buttons.dart
|   |   |   |           |-- level_xp_indicator.dart
|   |   |   |           |-- metrics_info_badge.dart
|   |   |   |           |-- metrics_stats_badge.dart
|   |   |   |           |-- practice_metrics_bar.dart
|   |   |   |           |-- practice_reset_pause.dart
|   |   |   |           |-- practice_setting_buttons.dart
|   |   |   |           |-- practice_start_button.dart
|   |   |   |           |-- practice_stop_filled_button.dart
|   |   |   |           |-- toast.dart
|   |   |   |           `-- typing_progress.dart
|   |   |   `-- usecases/
|   |   |       |-- content/
|   |   |       |   |-- get_preloaded_texts.dart
|   |   |       |   `-- preload_typing_texts.dart
|   |   |       `-- difficulty_criteria/
|   |   |           `-- load_save_difficulty_criteria.dart
|   |   |-- user_profile/
|   |   |   |-- data/
|   |   |   |-- domain/
|   |   |   |   |-- contracts/
|   |   |   |   `-- enums/
|   |   |   `-- presentation/
|   |   |       |-- pages/
|   |   |       |   `-- profile_page.dart
|   |   |       |-- providers/
|   |   |       `-- widgets/
|   |   `-- README.md
|   |-- services/
|   |   |-- README.md
|   |   `-- shared_prefs_service.dart
|   `-- main.dart