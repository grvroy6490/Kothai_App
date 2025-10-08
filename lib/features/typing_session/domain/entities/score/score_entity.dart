


import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_entity.freezed.dart';
part 'score_entity.g.dart';

@freezed
abstract class ScoreEntity with _$ScoreEntity {
    const factory ScoreEntity({
        @Default(0) int totalXp,
        @Default(1) int level,          // derived from totalXp; stored for convenience
        @Default(0) int xpIntoLevel,    // totalXp % xpPerLevel
        required int xpPerLevel   // constant threshold per level
    }) = _ScoreEntity;

    const ScoreEntity._();

    double get progress => xpPerLevel == 0 ? 0 : (xpIntoLevel / xpPerLevel).clamp(0, 1);

    factory ScoreEntity.fromJson(Map<String, dynamic> json) => _$ScoreEntityFromJson(json);
}



@freezed
abstract class ScoreEntry with _$ScoreEntry {
    const factory ScoreEntry({
        required String id,            // uuid
        required DateTime at,
        required String mode,          // "practice", "challenge", etc.
        required int amount,           // e.g., 50
        @Default(false) bool synced,   // uploaded to cloud?
        String? sessionId             // optional link
    }) = _ScoreEntry;

    factory ScoreEntry.fromJson(Map<String, dynamic> json) => _$ScoreEntryFromJson(json);
}