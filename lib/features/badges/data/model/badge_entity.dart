

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kothai_app/features/badges/domain/enums/badge_type_enum.dart';

part 'badge_entity.freezed.dart';
part 'badge_entity.g.dart';

@freezed
abstract class BadgeEntity with _$BadgeEntity {
    const factory BadgeEntity({
        required String id,
        required String name,
        required String tier,
        required BadgeType type,
        required String condition,
        required String toastMessage,
        required String imagePath
    }) = _BadgeEntity;

    factory BadgeEntity.fromJson(Map<String, dynamic> json) =>
    _$BadgeEntityFromJson(json);
}
