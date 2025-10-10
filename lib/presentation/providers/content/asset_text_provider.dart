import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/domain/entities/content/text_paragraph.dart';
import 'package:kothai_app/enums/difficulty/DifficultyEnum.dart';


// NOTE: TEMPORARY SOLUTION OF PROVIDER
/// Loads typing texts from bundled assets (assets/dummy_content.json)
/// and exposes them as a list of TextParagraph via Riverpod.
final assetTextsProvider = FutureProvider<List<TextParagraph>>((ref) async {
  final raw = await rootBundle.loadString('assets/dummy_content.json');
  final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;

  final List<TextParagraph> results = [];

  void addByDifficulty(String key, DifficultyEnum difficulty) {
    if (!json.containsKey(key)) return;
    final items = json[key];
    if (items is List) {
      for (final item in items) {
        if (item is Map<String, dynamic>) {
          final content = (item['text'] ?? '').toString();
          if (content.isNotEmpty) {
            results.add(TextParagraph(difficulty: difficulty, content: content));
          }
        }
      }
    }
  }

  addByDifficulty('easy', DifficultyEnum.easy);
  addByDifficulty('medium', DifficultyEnum.medium);
  addByDifficulty('hard', DifficultyEnum.hard);

  return results;
});

