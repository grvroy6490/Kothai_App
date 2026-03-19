import 'dart:convert';

import 'package:visai/core/constants/gamification.dart';
import 'package:visai/domain/entities/gamification/gamification_entity.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';
// import 'package:logger/logger.dart';

class GamificationCache {
  final SharedPrefsService prefs;
  // final _logger = Logger();

  GamificationCache(this.prefs);

  Future<void> write(GamificationEntity item) async {
    final encoded = jsonEncode(item.toJson());
    await prefs.setString(kGamificationPrefsKey, encoded);
  }

  Future<GamificationEntity?> read() async {
    final json = prefs.getString(kGamificationPrefsKey);
    if (json == null) {
      return null;
    }
    final decoded = jsonDecode(json);
    return GamificationEntity.fromJson(decoded);
  }

  // Store and read the original raw JSON so the app can choose criteria later.
  Future<void> writeRawJson(String rawJson) async {
    await prefs.setString(kGamificationRawPrefsKey, rawJson);
  }

  String? readRawJson() {
    return prefs.getString(kGamificationRawPrefsKey);
  }

  Future<void> clearRaw() => prefs.remove(kGamificationRawPrefsKey);

  Future<void> clear() => prefs.remove(kGamificationPrefsKey);
}
