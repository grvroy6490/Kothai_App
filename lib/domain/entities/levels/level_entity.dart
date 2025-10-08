

import 'package:freezed_annotation/freezed_annotation.dart';

part 'level_entity.freezed.dart';
part 'level_entity.g.dart';

@freezed
abstract class LevelEntity with _$LevelEntity {
    const factory LevelEntity({
        required String level,      // e.g., 1, 2, 3, ...
        required int totalXp    // total XP required to reach this level
    }) = _LevelEntity;

    factory LevelEntity.fromJson(Map<String, dynamic> json) =>
    _$LevelEntityFromJson(json);
}