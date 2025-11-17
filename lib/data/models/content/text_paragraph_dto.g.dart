// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_paragraph_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextParagraphDto _$TextParagraphDtoFromJson(Map<String, dynamic> json) =>
    _TextParagraphDto(
      difficulty: $enumDecode(_$DifficultyEnumEnumMap, json['difficulty']),
      content: json['content'] as String,
    );

Map<String, dynamic> _$TextParagraphDtoToJson(_TextParagraphDto instance) =>
    <String, dynamic>{
      'difficulty': _$DifficultyEnumEnumMap[instance.difficulty]!,
      'content': instance.content,
    };

const _$DifficultyEnumEnumMap = {
  DifficultyEnum.easy: 'easy',
  DifficultyEnum.medium: 'medium',
  DifficultyEnum.hard: 'hard',
  DifficultyEnum.special: 'special',
};
