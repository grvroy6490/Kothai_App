

import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'challenge_difficulty_provider.g.dart';

@riverpod
class ChallengeDifficultyController extends _$ChallengeDifficultyController{
    @override
    DifficultyEnum build() => DifficultyEnum.easy;

    void setDifficulty(DifficultyEnum difficulty) =>
    state = difficulty;

    void resetDifficulty() => state = DifficultyEnum.easy;
} 