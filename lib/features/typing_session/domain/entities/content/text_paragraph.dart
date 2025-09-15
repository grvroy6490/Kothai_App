

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

part 'text_paragraph.freezed.dart';

@freezed
abstract class TextParagraph with _$TextParagraph {
    const factory TextParagraph({
        required DifficultyEnum difficulty,
        required String content
    }) = _TextParagraph;


}
