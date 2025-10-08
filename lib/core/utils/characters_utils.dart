import 'package:characters/characters.dart';
import 'package:kothai_app/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';

int graphemeCount(String s) => s.characters.length;

double computeProgress(String typed, String target) {
  final typedCount = typed.characters.length;
  final totalCount = target.characters.length;

  if (totalCount == 0) return 0.0;

  // Clamp: if user typed more than target, keep max at 1.0
  return (typedCount / totalCount).clamp(0.0, 1.0);
}

String getWordAndCharacter(String text) {
  // Count words: split by whitespace, filter out empty
  final words = text.trim().isEmpty
      ? 0
      : text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  // Count characters (grapheme clusters)
  final characters = text.characters.length;
  return '$words (~$characters Character)';
}

String getAverageTime(String text, DifficultyCriteriaEntity difficulty) {
  // Count words in the text (split by whitespace, filter out empty)
  final words = text.trim().isEmpty
      ? 0
      : text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

  // Calculate time in minutes based on WPM
  final timeInMinutes = words / difficulty.wpm;

  // Convert to minutes and seconds
  final minutes = timeInMinutes.floor();
  final seconds = ((timeInMinutes - minutes) * 60).round();

  return '~$minutes mins $seconds secs';
}
