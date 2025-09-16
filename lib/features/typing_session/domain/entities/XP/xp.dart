import 'package:freezed_annotation/freezed_annotation.dart';
part 'xp.freezed.dart';
part 'xp.g.dart';

@freezed
abstract class XpTotals with _$XpTotals {
    const factory XpTotals({
        @Default(0) int totalXp,
        @Default(1) int level,          // derived from totalXp; stored for convenience
        @Default(0) int xpIntoLevel,    // totalXp % xpPerLevel
        @Default(200) int xpPerLevel   // constant threshold per level
    }) = _XpTotals;

    const XpTotals._();

    double get progress => xpPerLevel == 0 ? 0 : (xpIntoLevel / xpPerLevel).clamp(0, 1);

    factory XpTotals.fromJson(Map<String, dynamic> json) => _$XpTotalsFromJson(json);
}

@freezed
abstract class XpEntry with _$XpEntry {
    const factory XpEntry({
        required String id,            // uuid
        required DateTime at,
        required String mode,          // "practice", "challenge", etc.
        required int amount,           // e.g., 50
        @Default(false) bool synced,   // uploaded to cloud?
        String? sessionId             // optional link
    }) = _XpEntry;

    factory XpEntry.fromJson(Map<String, dynamic> json) => _$XpEntryFromJson(json);
}
