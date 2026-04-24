import 'package:characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/content/text_content_controller_provider.dart';
import 'package:visai/features/typing_session/presentation/riverpod/controllers/user_input/user_input_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'typing_progress_provider.g.dart';

@riverpod
double typingProgress(Ref ref) {
    final text = ref.watch(textContentControllerProvider);
    final input = ref.watch(userInputProvider);

    if (text == null || text.content.isEmpty) return 0.0;

    // Use grapheme clusters — same unit the AnimatedContentBoard uses to
    // determine visual coverage. One Tamil "character" as the user sees it
    // (e.g. மா, ம்) is one grapheme cluster regardless of how many UTF-16
    // code units it occupies. This keeps the progress bar in sync with the
    // visual overlay at all times.
    final paraLen = text.content.characters.length;
    if (paraLen == 0) return 0.0;

    return (input.characters.length / paraLen).clamp(0.0, 1.0);
}
