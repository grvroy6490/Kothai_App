import 'package:dio/dio.dart';

class TextApiService {
    final Dio dio;

    TextApiService(this.dio);

    Future<String> generateParagraph({
        required int wordCount,
        double randomness = 0.85
    }) async {
        final response = await dio.post(
            '/generate',
            data: {'topic': 'typing', 'words': wordCount, 'randomness': randomness}
        );

        return response.data['text'] ?? '';
    }
}
