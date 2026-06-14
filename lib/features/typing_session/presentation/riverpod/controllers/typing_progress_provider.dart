import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/features/typing_session/domain/typing_cluster_progress.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'typing_progress_provider.g.dart';

@riverpod
double typingProgress(Ref ref) {
  final text = ref.watch(textContentControllerProvider);
  final input = ref.watch(userInputProvider);

  if (text == null || text.content.isEmpty) return 0.0;

  return TypingClusterProgress.assess(input, text.content).progress;
}
