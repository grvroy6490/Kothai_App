// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextContent _$TextContentFromJson(Map<String, dynamic> json) => _TextContent(
  difficulty: $enumDecode(_$DifficultyEnumEnumMap, json['difficulty']),
  content: json['content'] as String,
  topic: json['topic'] as String?,
  wordCount: (json['wordCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$TextContentToJson(_TextContent instance) =>
    <String, dynamic>{
      'difficulty': _$DifficultyEnumEnumMap[instance.difficulty]!,
      'content': instance.content,
      'topic': instance.topic,
      'wordCount': instance.wordCount,
    };

const _$DifficultyEnumEnumMap = {
  DifficultyEnum.easy: 'easy',
  DifficultyEnum.medium: 'medium',
  DifficultyEnum.hard: 'hard',
};
