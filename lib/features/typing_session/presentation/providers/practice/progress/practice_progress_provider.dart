


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/content/text_providers.dart';
import 'package:kothai_app/features/typing_session/presentation/providers/practice/user_input/user_input_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'practice_progress_provider.g.dart';

@riverpod
double practiceProgress(Ref ref) {
  final text = ref.watch(textContentProvider);   // paragraph to type
  final input = ref.watch(userInputProvider);   // what user has typed so far

  if (text == null || text.content.isEmpty) return 0.0;
  return (input.length / text.content.length).clamp(0.0, 1.0);
}