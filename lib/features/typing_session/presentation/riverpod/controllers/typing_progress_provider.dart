
import 'package:characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

part 'typing_progress_provider.g.dart';

@riverpod
double typingProgress(Ref ref) {
    final text = ref.watch(textContentControllerProvider);   // paragraph to type
    final input = ref.watch(userInputProvider);   // what user has typed so far

    if (text == null || text.content.isEmpty) return 0.0;

    final normalizedPara = unorm.nfc(text.content);
    final normalizedInput = unorm.nfc(input);

    final paraClusters = normalizedPara.characters.toList();
    final inputClusters = normalizedInput.characters.toList();

    if (paraClusters.isEmpty) return 0.0;

    return (inputClusters.length / paraClusters.length).clamp(0.0, 1.0);
}
