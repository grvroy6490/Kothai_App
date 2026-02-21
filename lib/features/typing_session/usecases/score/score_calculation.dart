

import 'package:visai/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';

double calculateXP(
    {required int totalChars, required DifficultyCriteriaEntity? difficultyMultiplier, required double accuracyPercent, required double wpm}) {
    // Base XP calculation
    double xp = totalChars * difficultyMultiplier!.difficultyMultiplier;

    if((accuracyPercent*100) >= 95) {
        xp *= 1.5; // 20% bonus for high accuracy
    }

    if(wpm >= 40){
        xp *= 1.2;
    }

    return xp;
}