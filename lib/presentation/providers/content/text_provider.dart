import 'package:dio/dio.dart';
import 'package:visai/application/use_cases/preload_typing_texts.dart';
import 'package:visai/data/datasources/content/text_api_service.dart';
import 'package:visai/data/repositories_impl/content/text_repository_impl.dart';
import 'package:visai/domain/entities/content/text_paragraph.dart';
import 'package:visai/domain/repositories/content/text_repository.dart';
import 'package:visai/presentation/providers/shared_prefs_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_provider.g.dart';

@riverpod
TextApiService textApiService(TextApiServiceRef ref) {
    return TextApiService(Dio(BaseOptions(baseUrl: 'http://localhost:3000')));
}

@riverpod
TextRepository textRepository(TextRepositoryRef ref) {
    // final api = ref.watch(textApiServiceProvider);
    final prefs = ref.watch(sharedPrefsServiceProvider);
    // return TextRepositoryImpl(api, prefs, ref);
    return TextRepositoryImpl(prefs, ref);
}

@riverpod
PreloadTypingTexts preloadTypingTexts(PreloadTypingTextsRef ref) {
    return PreloadTypingTexts(ref.watch(textRepositoryProvider));
}

@riverpod
Future<List<TextParagraph>> preloadedText(PreloadedTextRef ref) async {
    return ref.watch(textRepositoryProvider).getPreloadedTexts();
}

//
// Future<TextParagraph?> preloadedText(PreloadedTextRef ref) async {
//
//     final paragraphContentData = ref.watch(assetTextsProvider);
//     final difficultyLevel = ref.watch(practiceSettingsProvider).difficulty;
//     final paragraphList = paragraphContentData.value?.where((para) => para.difficulty == difficultyLevel).toList() ?? [];
//     final randomize = ref.watch(practiceSettingsProvider).randomize;
//
//     if (paragraphList.isNotEmpty) {
//         if (randomize && paragraphList.isNotEmpty) {
//             final randomIndex = (paragraphList.length > 1) ? (DateTime.now().millisecondsSinceEpoch % paragraphList.length) : 0;
//             return paragraphList[randomIndex];
//         } else if (paragraphList.isNotEmpty) {
//             return paragraphList[0];
//         } else {
//             return null;
//         }
//     }
// }




@riverpod
class TextContent extends _$TextContent {

    @override
    TextParagraph? build() {
        return ref.watch(preloadedTextProvider).maybeWhen(
                data: (data) => data.isNotEmpty ? data[0] : null,
                orElse: () => null,
            );
    }

    void setTextContent(TextParagraph newContent) {
        state = newContent;
    }

    void clearTextContent() {
        state = null;
    }
}
