
import 'package:visai/features/typing_session/domain/contracts/content/text_content_fetcher.dart';
import 'package:visai/features/typing_session/domain/entities/content/text_content.dart';
import 'package:visai/features/typing_session/domain/enums/content_type_enum.dart';
import 'package:visai/features/typing_session/data/sources/local/content/content_local_source.dart';

class ContentLocalSourceAdaptor implements TextContentFetcher {
    final ContentTypeEnum type;
    final ContentLocalSourceFetcher _fetcher = ContentLocalSourceFetcher();

    ContentLocalSourceAdaptor(this.type);

    @override
    Future<List<TextContent>> fetch({String? topic, int? wordCount, double? randomness}) async {
        final raw = await _fetcher.fetchRaw(
            topic: topic,
            wordCount: wordCount,
            randomness: randomness
        );
        return raw[type] ?? [];
    }
}