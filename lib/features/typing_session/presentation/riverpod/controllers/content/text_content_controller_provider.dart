import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_content.dart';
import 'package:kothai_app/features/typing_session/domain/enums/content_type_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/content/text_content_repo.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/challenge/challenge_difficulty_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/practice/practice_config_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/controllers/session/session_status_provider.dart';
import 'package:kothai_app/features/typing_session/presentation/riverpod/providers/content/text_content_repo_provider.dart';
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
            state = list.first;
            // state = TextContent(difficulty: DifficultyEnum.easy, content: "அ ஆ இ ஈ உ ஊ எ ஏ ஐ ஒ ஓ ஔ\n\nக கா கி கீ கு கூ கெ கே கை கொ கோ கௌ\n\nங ஙா ஙி ஙீ ஙு ஙூ ஙெ ஙே ஙை ஙொ ஙோ ஙௌ\n\nச சா சி சீ சு சூ செ சே சை சொ சோ சௌ\n\nஞ ஞா ஞி ஞீ ஞு ஞூ ஞெ ஞே ஞை ஞொ ஞோ ஞௌ\n\nட டா டி டீ டு டூ டெ டே டை டொ டோ டௌ\n\nண ணா ணி ணீ ணு ணூ ணெ ணே ணை ணொ ணோ ணௌ\n\nத தா தி தீ து தூ தெ தே தை தொ தோ தௌ\n\nந நா நி நீ நு நூ நெ நே நை நொ நோ நௌ\n\nப பா பி பீ பு பூ பெ பே பை பொ போ பௌ\n\nம மா மி மீ முரூ மெ மே மை மொ மோ மௌ\n\nய யா யி யீ யு யூ யெ யே யை யொ யோ யௌ\n\nர ரா ரி ரீ ரு ரூ ரெ ரே ரை ரொ ரோ ரௌ\n\nல லா லி லீ லு லூ லெ லே லை லொ லோ லௌ\n\nவ வா வி வீ வு வூ வெ வே வை வொ வோ வௌ\n\nழ ழா ழி ழீ ழு ழூ ழெ ழே ழை ழொ ழோ ழௌ\n\nள ளா ளி ளீ ளு ளூ ளெ ளே ளை ளொ ளோ ளௌ\n\nற றா றி றீ று றூ றெ றே றை றொ றோ றௌ\n\nன னா னி னீ னு னூ னெ னே னை னொ னோ னௌ\n\nஜ ஜா ஜி ஜீ ஜு ஜூ ஜெ ஜே ஜை ஜொ ஜோ ஜௌ\n\nஷ ஷா ஷி ஷீ ஷு ஷூ ஷெ ஷே ஷை ஷொ ஷோ ஷௌ\n\nஸ ஸா ஸி ஸீ ஸு ஸூ ஸெ ஸே ஸை ஸொ ஸோ ஸௌ\n\nஹ ஹா ஹி ஹீ ஹு ஹூ ஹெ ஹே ஹை ஹொ ஹோ ஹௌ\n\nக்ஷ க்ஷா க்ஷி க்ஷீ க்ஷு க்ஷூ க்ஷெ க்ஷே க்ஷை க்ஷொ க்ஷோ க்ஷௌ");
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
