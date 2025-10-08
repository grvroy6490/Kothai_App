import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_content.dart';
import 'package:kothai_app/features/typing_session/domain/enums/content_type_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/content/text_content_repo.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_handler_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/content/text_content_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_content_controller_provider.g.dart';

/// Determines content type based on current session mode
@riverpod
ContentTypeEnum currentContentType(Ref ref) {
    final sessionMode = ref.watch(sessionHandlerControllerProvider).mode;
    switch (sessionMode) {
        case SessionMode.practice:
            return ContentTypeEnum.practice;
        case SessionMode.challenge:
            return ContentTypeEnum.challenge;
        case SessionMode.none:
            return ContentTypeEnum.practice; // Default to practice
    }
}

/// Gets the appropriate repository based on current content type
@riverpod
TextContentRepository currentContentRepository(Ref ref) {
    final contentType = ref.watch(currentContentTypeProvider);
    switch (contentType) {
        case ContentTypeEnum.practice:
            return ref.watch(practiceContentRepositoryProvider);
        case ContentTypeEnum.challenge:
            return ref.watch(challengeContentRepositoryProvider);
    }
}

@riverpod
class TextContentController extends _$TextContentController {
    @override
    TextContent? build() {
        return ref
            .watch(getRandomizedContentProvider)
            .maybeWhen(
                data: (list) => list.isNotEmpty ? list.first : null,
                orElse: () => null
            );
    }

    void setTextContent(TextContent content) => state = content;
}

// 👇 This is connected to 👆 That
@riverpod
Future<List<TextContent>> getRandomizedContent(Ref ref) async {
    ref.watch(getPreloadedTextsProvider);
    final sessionMode = ref.watch(sessionHandlerControllerProvider).mode;
    final difficulty = sessionMode == SessionMode.challenge
        ? ref.watch(challengeDifficultyControllerProvider)
        : ref.watch(practiceConfigurationProvider.select((config) => config.difficulty));
    return ref.read(currentContentRepositoryProvider).randomizedTexts(difficulty);
}

// 👇 This is connected to 👆 That
@riverpod
Future<List<TextContent>> getPreloadedTexts(Ref ref) async =>
ref.watch(currentContentRepositoryProvider).getPreloadedTexts();
