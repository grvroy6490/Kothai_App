

import 'dart:convert';

import 'package:visai/features/typing_session/domain/contracts/challenge/store_challenge_to_prefs.dart';
import 'package:visai/features/typing_session/domain/entities/challenge/challenge_tracking_entity.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';

class ChallengeSessionToPrefs implements StoreChallengeToPrefs {
    final SharedPrefsService prefs;
    ChallengeSessionToPrefs(this.prefs);

    @override
    Future<void> save(ChallengeTrackingEntity s, String key) async {
        await prefs.setString(key, jsonEncode(s.toJson()));
    }

    @override
    Future<ChallengeTrackingEntity?> load(String key) async {
        final raw = prefs.getString(key);
        if (raw == null) return null;
        return ChallengeTrackingEntity.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    @override
    Future<void> clear(String key) => prefs.remove(key);
}