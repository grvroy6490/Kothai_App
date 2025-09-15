

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_paragraph.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

class AssetTextsSource {
    Future<List<TextParagraph>> loadAllFromAssets() async {
        final raw = await rootBundle.loadString('assets/dummy_content.json');
        final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;

        List<TextParagraph> results = [];
        void addBy(String key, DifficultyEnum difficulty) {
            final items = json[key];
            if (items is List) {
                for (final item in items) {
                    final content = (item['text'] ?? '').toString();
                    if (content.isNotEmpty) {
                        results.add(TextParagraph(difficulty: difficulty, content: content));
                    }
                }
            }
        }

        addBy('easy', DifficultyEnum.easy);
        addBy('medium', DifficultyEnum.medium);
        addBy('hard', DifficultyEnum.hard);
        return results;
    }
}