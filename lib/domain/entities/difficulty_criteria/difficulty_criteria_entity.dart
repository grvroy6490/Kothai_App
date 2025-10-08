
import 'package:freezed_annotation/freezed_annotation.dart';

part 'difficulty_criteria_entity.freezed.dart';
part 'difficulty_criteria_entity.g.dart';

@freezed
abstract class DifficultyCriteriaEntity with _$DifficultyCriteriaEntity{
    const factory DifficultyCriteriaEntity({
        required String type,
        required int accuracy,
        required int wpm,
        required String timelimit,
        required double xpMultiplier,
        required double difficultyMultiplier,
    }) = _DifficultyCriteriaEntity;

    factory DifficultyCriteriaEntity.fromJson(Map<String, dynamic> json) =>
    _$DifficultyCriteriaEntityFromJson(json);

}