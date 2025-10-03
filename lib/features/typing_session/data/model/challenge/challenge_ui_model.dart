import 'package:flutter/material.dart';
import 'package:kothai_app/features/typing_session/domain/entities/challenge/challenge_ui_entity.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

const challengesUiData = [
    ChallengeUiEntity(
        name: DifficultyEnum.easy,
        bgColor: 'State Layers/Success/Opacity-16',
        icon: "assets/icons/easy.png"
    ),
    ChallengeUiEntity(
        name: DifficultyEnum.medium,
        bgColor: 'State Layers/Blue/Opacity-16',
        icon: "assets/icons/medium.png"
    ),
    ChallengeUiEntity(
        name: DifficultyEnum.hard,
        bgColor: 'State Layers/Tertiary/Opacity-10',
        icon: "assets/icons/hard.png"
    )
];
