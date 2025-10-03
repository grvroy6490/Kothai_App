

import 'package:kothai_app/features/typing_session/data/model/challenge/challenge_ui_model.dart';
import 'package:kothai_app/features/typing_session/domain/entities/challenge/challenge_ui_entity.dart';
import 'package:riverpod/riverpod.dart';

final challengeIndexProvider = StateProvider<int>((ref) => 0);


final selectedChallengeUIProvider = Provider<ChallengeUiEntity>((ref) {
        final index = ref.watch(challengeIndexProvider);
        return challengesUiData[index];
    });
