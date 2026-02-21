import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:visai/enums/difficulty/DifficultyEnum.dart';

part 'text_paragraph.freezed.dart';

@freezed
abstract class TextParagraph with _$TextParagraph {
    const factory TextParagraph({
        required DifficultyEnum difficulty,
        required String content
    }) = _TextParagraph;


}
