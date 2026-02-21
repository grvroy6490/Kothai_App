

import 'package:dio/dio.dart';
import 'package:visai/features/typing_session/domain/contracts/content/text_content_fetcher.dart';
import 'package:visai/features/typing_session/domain/entities/content/text_content.dart';

class ContentApiSourceFetcher {
    final Dio dio;

    ContentApiSourceFetcher(this.dio);

    Future<List<TextContent>> fetchRaw({String? topic, int? wordCount, double? randomness}) async {
        final response = await dio.post(
            '/generate',
            data: {'topic': topic, 'words': wordCount, 'randomness': randomness}
        );

        // TODO: once we have the api format this data
        return response.data ?? '';
    }

}