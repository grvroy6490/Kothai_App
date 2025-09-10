import 'dart:convert';
import 'package:kothai_app/core/constants/constants.dart';
import 'package:kothai_app/domain/repositories/session/session_history_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kothai_app/data/models/session/typing_session.dart';



class SessionHistoryRepository implements ISessionHistoryRepository {
    static const _key = kTypingSessionsPrefsKey; // change if schema changes

    const SessionHistoryRepository();

    Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

    @override
    Future<List<TypingSession>> getAll() async {
        final sp = await _prefs();
        final raw = sp.getString(_key);
        if (raw == null || raw.isEmpty) return <TypingSession>[];
        final list = (jsonDecode(raw) as List)
            .map((e) => TypingSession.fromJson(e as Map<String, dynamic>))
            .toList();
        return list;
    }

    @override
    Future<void> add(TypingSession session, {int maxKeep = 500}) async {
        final sp = await _prefs();
        final all = await getAll();

        // Prepend newest first
        all.insert(0, session);

        // Optional: cap history
        if (all.length > maxKeep) {
            all.removeRange(maxKeep, all.length);
        }

        final raw = jsonEncode(all.map((e) => e.toJson()).toList());
        await sp.setString(_key, raw);
    }

    @override
    Future<void> replaceAll(List<TypingSession> sessions) async {
        final sp = await _prefs();
        final raw = jsonEncode(sessions.map((e) => e.toJson()).toList());
        await sp.setString(_key, raw);
    }

    @override
    Future<void> clear() async {
        final sp = await _prefs();
        await sp.remove(_key);
    }
}
