import 'package:kothai_app/features/typing_session/domain/entities/content/text_paragraph.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

abstract class TextRepository {
    Future<void> preloadInitialTexts({required DifficultyEnum difficulty, required bool randomize});
    Future<List<TextParagraph>> getPreloadedTexts();
    Future<List<TextParagraph>> getRandomizedTexts();

}
