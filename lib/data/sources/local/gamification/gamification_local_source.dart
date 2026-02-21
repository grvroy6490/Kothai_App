import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/domain/contracts/gamification/gamification_data_fetcher.dart';
import 'package:visai/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';
import 'package:visai/domain/entities/gamification/gamification_entity.dart';
import 'package:visai/domain/entities/levels/level_entity.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:logger/logger.dart';

class GamificationLocalSourceFetcher implements GamificationDataFetcher {
    final _logger = Logger();

    @override
    Future<GamificationEntity?> fetch() async {
        final data = await rootBundle.loadString('assets/gamification.json');
        final Map<String, dynamic> json = jsonDecode(data) as Map<String, dynamic>;

        final List<DifficultyCriteriaEntity> criterias = [];
        final List<LevelEntity> levels = [];

        final difficultyCriteriaJson = json['difficultyCriteria'];
        for(final item in difficultyCriteriaJson.entries){

            if(item.value != null) {
                criterias.add(DifficultyCriteriaEntity(
                    type: item.key.toString(),
                    accuracy: (item.value['accuracy'] as num).toInt(),
                    wpm: (item.value['wpm'] as num).toInt(),
                    timelimit: item.value['timeLimit'].toString(),
                    xpMultiplier: (item.value['xpMultiplier'] as num).toDouble(),
                    difficultyMultiplier: (item.value['difficultyMultiplier'] as num).toDouble()
                ));

            }
        }


        final levelsJson = json['levels'];
        for(final item in levelsJson.entries){
            if(item.value != null){
                levels.add(
                  LevelEntity(level: item.key.toString(), totalXp: (item.value as num).toInt())
                );
            }
        }

        final gamification = GamificationEntity(
            levels: levels,
            difficultyCriteria: criterias
        );

        return gamification;
    }


}
