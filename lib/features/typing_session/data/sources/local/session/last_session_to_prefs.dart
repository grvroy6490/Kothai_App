


import 'dart:convert';

import 'package:kothai_app/core/constants/typing_session_constants.dart';
import 'package:kothai_app/features/typing_session/domain/contracts/session/last_session_store.dart';
import 'package:kothai_app/features/typing_session/domain/entities/session/session_entity.dart';
import 'package:kothai_app/services/shared_preferences/shared_prefs_service.dart';

class LastSessionToPrefs implements LastSessionStore {
    final SharedPrefsService prefs;
    LastSessionToPrefs(this.prefs);

    @override
    Future<void> save(SessionEntity s) async {
        await prefs.setString(kLastPracticeSessionKey, jsonEncode(s.toJson()));
    }

    @override
    Future<SessionEntity?> load() async {
        final raw = prefs.getString(kLastPracticeSessionKey);
        if (raw == null) return null;
        return SessionEntity.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    @override
    Future<void> clear() => prefs.remove(kLastPracticeSessionKey);
}