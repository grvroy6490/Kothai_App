


import 'package:kothai_app/features/typing_session/domain/entities/content/text_content.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

abstract class TextContentRepository {
  Future<void> preloadInitialTexts();

  Future<List<TextContent>> getPreloadedTexts();

  Future<List<TextContent>> randomizedTexts(DifficultyEnum difficulty);

}