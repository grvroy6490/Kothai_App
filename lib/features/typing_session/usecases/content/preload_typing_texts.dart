

import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/content/text_repository.dart';

class PreloadTypingTexts {
    final TextRepository repo;
    PreloadTypingTexts(this.repo);

    Future<void> call({
        required DifficultyEnum difficulty,
        required bool randomize
    }) => repo.preloadInitialTexts(difficulty: difficulty, randomize: randomize);
}