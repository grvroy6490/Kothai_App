import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/features/typing_session/domain/entities/content/text_content.dart';
import 'package:visai/features/typing_session/domain/enums/content_type_enum.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/typing_session/domain/repositories/content/text_content_repo.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/providers/content/text_content_repo_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_content_controller_provider.g.dart';

/// Determines content type based on current session mode
@riverpod
ContentTypeEnum currentContentType(Ref ref) {
    final sessionMode = ref.watch(sessionStatusControllerProvider).mode;
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
        // Keep content stable by default; roll explicitly when needed
        return null;
    }

    Future<void> rollNewContent() async {
        final sessionMode = ref.read(sessionStatusControllerProvider).mode;
        final difficulty = sessionMode == SessionMode.challenge
            ? ref.read(challengeDifficultyControllerProvider)
            : ref.read(practiceConfigurationProvider).difficulty;

        final list = await ref
            .read(currentContentRepositoryProvider)
            .randomizedTexts(difficulty);

        if (list.isNotEmpty) {
            // state = list.first;
           state = TextContent(difficulty: DifficultyEnum.easy, content: "ஹெ ஹே மி ஹை ஹொ ஹோ ஹௌ க்ஷ க்ஷா க்ஷி க்ஷீ க்ஷு க்ஷூ க்ஷெ க்ஷே க்ஷை க்ஷொ க்ஷோ க்ஷௌ ஸ்ரீ கௌரவமிக்கொழுக்கத்துடன் சௌகரியமற்றசூழலில் தௌரியமாய் செயல்படும் பௌராணிகவாக்கியங்கள் வௌவால்சுழற்சிபோல் மாறிக்கொண்டே இருந்தன கெகேகைகொகோகௌ செசேசைசொசோசௌ தெதேதைதொதோதௌ பெபேபைபொபோபௌ ஜெஜேஜைஜொஜோஜௌ ஷெஷேஷைஷொஷோஷௌ ஸெஸேஸைஸொஸோஸௌ ஹெஹேஹைஹொஹோஹௌ கேகைகொகோகௌசெசேசைசொசோசௌதெதேதைதொதோதௌபெபேபைபொபோபௌ ஜெஜேஜைஜொஜோஜௌஷெஷேஷைஷொஷோஷௌஸெஸேஸைஸொஸோஸௌஹெஹேஹைஹொஹோஹௌ ஜ், ஷ், ஸ், ஹ், க்ஷ் ்,  ா, ி, ீ, ு, ூ, ெ, ே, ை, ொ, ோ, ௌ, ஂ");
        } else {
            state = null;
        }
    }
    void setTextContent(TextContent content) => state = content;
}

// 👇 This is connected to 👆 That
@riverpod
Future<List<TextContent>> getRandomizedContent(Ref ref) async {
    final logger = Logger();
    logger.d('Fetching randomized text content...');
    await ref.read(getPreloadedTextsProvider.future); 
    final sessionMode = ref.read(sessionStatusControllerProvider).mode;
    final difficulty = sessionMode == SessionMode.challenge
        ? ref.read(challengeDifficultyControllerProvider)
        : ref.read(practiceConfigurationProvider.select((config) => config.difficulty));
    return ref.read(currentContentRepositoryProvider).randomizedTexts(difficulty);
}

// 👇 This is connected to 👆 That
@riverpod
Future<List<TextContent>> getPreloadedTexts(Ref ref) async =>
ref.watch(currentContentRepositoryProvider).getPreloadedTexts();
