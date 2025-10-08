

import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

class ChallengeUiEntity {
    final DifficultyEnum name;
    final String bgColor;
    final String icon;

    const ChallengeUiEntity({
        required this.name,
        required this.bgColor,
        required this.icon
    });
}