import 'package:kothai_app/domain/entities/content/text_paragraph.dart';

abstract class TextRepository {
  Future<void> preloadInitialTexts();
  Future<List<TextParagraph>> getPreloadedTexts();

}
