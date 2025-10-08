

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

part 'text_content.freezed.dart';
part 'text_content.g.dart';

@freezed
abstract class TextContent with _$TextContent {
    const factory TextContent({
        required DifficultyEnum difficulty,
        required String content,
        String? topic,
        int? wordCount,
    }) = _TextContent;

    factory TextContent.fromJson(Map<String, dynamic> json) =>
        _$TextContentFromJson(json);
}
