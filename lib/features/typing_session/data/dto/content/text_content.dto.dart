

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_content.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

part 'text_content.dto.freezed.dart';
part 'text_content.dto.g.dart';

@freezed
abstract class TextContentDto with _$TextContentDto {
    const TextContentDto._();

    const factory TextContentDto({
        required DifficultyEnum difficulty,
        required String content,
        String? topic,
        int? wordCount
    }) = _TextContentDto;

    factory TextContentDto.fromJson(Map<String, dynamic> json) =>
        _$TextContentDtoFromJson(json);

    factory TextContentDto.fromEntity(TextContent entity) =>
        TextContentDto(difficulty: entity.difficulty, content: entity.content, topic: entity.topic, wordCount: entity.wordCount);

    TextContent toEntity() =>
        TextContent(difficulty: difficulty, content: content, topic: topic, wordCount: wordCount);
}