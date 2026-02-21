
import 'package:dio/dio.dart';
import 'package:visai/features/typing_session/data/sources/remote/content/content_api_source.dart';
import 'package:visai/features/typing_session/domain/contracts/content/text_content_fetcher.dart';
import 'package:visai/features/typing_session/domain/entities/content/text_content.dart';

class ContentApiSourceAdaptor implements TextContentFetcher {

    final Dio dio;
    late final ContentApiSourceFetcher _fetcher = ContentApiSourceFetcher(dio);
    ContentApiSourceAdaptor(this.dio);

    @override
    Future<List<TextContent>> fetch({String? topic, int? wordCount, double? randomness}) async {
        return await _fetcher.fetchRaw(
            topic: topic,
            wordCount: wordCount,
            randomness: randomness
        );
    }
}