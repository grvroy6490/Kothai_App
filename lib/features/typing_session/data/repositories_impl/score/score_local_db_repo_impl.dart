

import 'dart:convert';

import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/features/typing_session/data/sources/local/score/score_dao.dart';
import 'package:visai/features/typing_session/domain/entities/score/score_entity.dart';
import 'package:visai/features/typing_session/domain/repositories/score/score_local_db_repository.dart';
import 'package:visai/services/shared_preferences/shared_prefs_service.dart';

class ScoreLocalDBRepositoryImpl implements ScoreLocalDBRepository {
    final ScoreDao dao;
    final SharedPrefsService prefs;
    ScoreLocalDBRepositoryImpl(this.dao, this.prefs);

    @override
    Future<ScoreEntity> loadScores() async {
        final raw = prefs.getString(kXpTotalsKey);
        if (raw == null) return const ScoreEntity();
        try {
            return ScoreEntity.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        } catch (_) {
            return const ScoreEntity();
        }
    }

    @override
    Future<void> saveScore(ScoreEntity totals) async {
        await prefs.setString(kXpTotalsKey, jsonEncode(totals.toJson()));
    }

    @override
    Future<void> addEntryToDB(ScoreEntry entry) => dao.insert(entry);

    @override
    Future<List<ScoreEntry>> listEntriesFromDB({bool onlyPending = false, int? limit}) =>
    dao.list(onlyPending: onlyPending, limit: limit);

    @override
    Future<void> markSynced(List<String> ids) => dao.markSynced(ids);
}