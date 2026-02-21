import 'package:visai/domain/entities/content/text_paragraph.dart';

abstract class TextRepository {
  Future<void> preloadInitialTexts();
  Future<List<TextParagraph>> getPreloadedTexts();

}
