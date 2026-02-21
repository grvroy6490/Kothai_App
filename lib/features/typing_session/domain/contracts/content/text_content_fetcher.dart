
import 'package:visai/features/typing_session/data/dto/content/text_content.dto.dart';
import 'package:visai/features/typing_session/domain/entities/content/text_content.dart';

abstract interface class TextContentFetcher {
    Future<List<TextContent>> fetch({String? topic, int? wordCount, double? randomness});
}



