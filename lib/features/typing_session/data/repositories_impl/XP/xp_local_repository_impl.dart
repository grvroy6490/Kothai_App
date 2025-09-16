
import 'package:kothai_app/core/constants/typin_session_constants.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/XP/xp_dao.dart';
import 'package:kothai_app/features/typing_session/domain/entities/XP/xp.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/XP/xp_local_repository.dart';
import 'package:kothai_app/services/shared_prefs_service.dart';
import 'dart:convert';



class XpLocalRepositoryImpl implements XpLocalRepository {
    final XpDao dao;
    final SharedPrefsService prefs;
    XpLocalRepositoryImpl(this.dao, this.prefs);

    @override
    Future<XpTotals> loadTotals() async {
        final raw = prefs.getString(kXpTotalsKey);
        if (raw == null) return const XpTotals();
        try {
            return XpTotals.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        } catch (_) {
            return const XpTotals();
        }
    }

    @override
    Future<void> saveTotals(XpTotals totals) async {
        await prefs.setString(kXpTotalsKey, jsonEncode(totals.toJson()));
    }

    @override
    Future<void> addEntry(XpEntry entry) => dao.insert(entry);

    @override
    Future<List<XpEntry>> listEntries({bool onlyPending = false, int? limit}) =>
    dao.list(onlyPending: onlyPending, limit: limit);

    @override
    Future<void> markSynced(List<String> ids) => dao.markSynced(ids);
}
