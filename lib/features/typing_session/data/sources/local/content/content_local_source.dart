

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:visai/features/typing_session/domain/entities/content/text_content.dart';
import 'package:visai/features/typing_session/domain/enums/content_type_enum.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

class ContentLocalSourceFetcher {

    Future<Map<ContentTypeEnum, List<TextContent>>> fetchRaw({String? topic, int? wordCount, double? randomness}) async {
        final practiceData = await rootBundle.loadString('assets/practice_content.json');
        final challengeData = await rootBundle.loadString('assets/challenge_content.json');

        final Map<String, dynamic> practiceJson = jsonDecode(practiceData) as Map<String, dynamic>;
        final Map<String, dynamic> challengeJson = jsonDecode(challengeData) as Map<String, dynamic>;

        List<TextContent> practiceResults = [];
        List<TextContent> challengeResults = [];

        void addBy(Map<String, dynamic> json, List<TextContent> results) {
            void addDifficulty(String key, DifficultyEnum difficulty) {
                final items = json[key];
                if (items is List) {
                    for (final item in items) {
                        final content = (item['text'] ?? '').toString();
                        final topic = (item['topic'] ?? '').toString();
                        final wordCount = content.split(' ').where((word) => word.isNotEmpty).length;

                        if (content.isNotEmpty) {
                            results.add(TextContent(
                                    difficulty: difficulty,
                                    content: content,
                                    topic: topic,
                                    wordCount: wordCount
                                ));
                        }
                    }
                }
            }

            addDifficulty('easy', DifficultyEnum.easy);
            addDifficulty('medium', DifficultyEnum.medium);
            addDifficulty('hard', DifficultyEnum.hard);
        }

        addBy(practiceJson, practiceResults);
        addBy(challengeJson, challengeResults);

        return {
            ContentTypeEnum.practice: practiceResults,
            ContentTypeEnum.challenge: challengeResults
        };
    }

}