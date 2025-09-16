

import 'dart:convert';

import 'package:kothai_app/core/constants/typin_session_constants.dart';
import 'package:kothai_app/features/typing_session/domain/entities/session/typing_session.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/session/last_session_store.dart';
import 'package:kothai_app/services/shared_prefs_service.dart';

class LastSessionPrefs implements LastSessionStore {
    final SharedPrefsService prefs;
    LastSessionPrefs(this.prefs);

    @override
    Future<void> save(TypingSession s) async {
        await prefs.setString(kLastPracticeSessionKey, jsonEncode(s.toJson()));
    }

    @override
    Future<TypingSession?> load() async {
        final raw = prefs.getString(kLastPracticeSessionKey);
        if (raw == null) return null;
        return TypingSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }

    @override
    Future<void> clear() => prefs.remove(kLastPracticeSessionKey);
}