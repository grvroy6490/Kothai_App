

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/features/typing_session/data/model/challenge/challenge_slide_card_data.dart';
import 'package:kothai_app/features/typing_session/domain/entities/challenge/challenge_ui_entity.dart';

final challengeIndexProvider = StateProvider<int>((ref) => 0);


final selectedChallengeUIControllerProvider = Provider<ChallengeUiEntity>((ref) {
        final index = ref.watch(challengeIndexProvider);
        return challengesSlideCardData[index];
    });
