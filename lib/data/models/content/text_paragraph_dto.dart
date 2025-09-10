import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/domain/entities/content/text_paragraph.dart';
import 'package:kothai_app/enums/difficulty/DifficultyEnum.dart';

part 'text_paragraph_dto.freezed.dart';
part 'text_paragraph_dto.g.dart';

@freezed
abstract class TextParagraphDto with _$TextParagraphDto {
    const TextParagraphDto._();

    const factory TextParagraphDto({
        required DifficultyEnum difficulty,
        required String content,
    }) = _TextParagraphDto;

    factory TextParagraphDto.fromJson(Map<String, dynamic> json) =>
    _$TextParagraphDtoFromJson(json);

    factory TextParagraphDto.fromEntity(TextParagraph entity) =>
    TextParagraphDto(difficulty: entity.difficulty, content: entity.content);

    TextParagraph toEntity() =>
    TextParagraph(difficulty: difficulty, content: content);
}
