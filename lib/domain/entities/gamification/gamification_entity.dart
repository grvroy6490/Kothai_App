

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/domain/entities/difficulty_criteria/difficulty_criteria_entity.dart';
import 'package:kothai_app/domain/entities/levels/level_entity.dart';

part 'gamification_entity.freezed.dart';
part 'gamification_entity.g.dart';

@freezed
abstract class GamificationEntity with _$GamificationEntity{
    const factory GamificationEntity({
        required List<DifficultyCriteriaEntity> difficultyCriteria,
        required List<LevelEntity> levels
    }) = _GamificationEntity;

    factory GamificationEntity.fromJson(Map<String, dynamic> json) =>
    _$GamificationEntityFromJson(json);
}