
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';

part 'challenge_tracking_entity.freezed.dart';
part 'challenge_tracking_entity.g.dart';

@freezed
abstract class ChallengeTrackingEntity with _$ChallengeTrackingEntity {
    const factory ChallengeTrackingEntity({
        required DifficultyEnum difficulty,
        required String timestamp,
    }) = _ChallengeTrackingEntity;

    factory ChallengeTrackingEntity.fromJson(Map<String, dynamic> json) =>
        _$ChallengeTrackingEntityFromJson(json);
}