

import 'package:kothai_app/features/typing_session/domain/entities/score/score_entity.dart';
import 'package:sqflite/sqflite.dart';

class ScoreDao {
    final Database db;
    ScoreDao(this.db);

    Future<void> insert(ScoreEntry e) async {
        await db.insert('score_entries', {
                'id': e.id,
                'at': e.at.millisecondsSinceEpoch,
                'mode': e.mode,
                'amount': e.amount,
                'synced': e.synced ? 1 : 0,
                'sessionId': e.sessionId
            }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    Future<List<ScoreEntry>> list({bool onlyPending = false, int? limit}) async {
        final rows = await db.query(
            'score_entries',
            where: onlyPending ? 'synced = 0' : null,
            orderBy: 'at DESC',
            limit: limit
        );
        return rows.map((r) => ScoreEntry(
                id: r['id'] as String,
                at: DateTime.fromMillisecondsSinceEpoch(r['at'] as int),
                mode: r['mode'] as String,
                amount: r['amount'] as int,
                synced: (r['synced'] as int) == 1,
                sessionId: r['sessionId'] as String?
            )).toList();
    }

    Future<void> markSynced(List<String> ids) async {
        if (ids.isEmpty) return;
        final batch = db.batch();
        for (final id in ids) {
            batch.update('score_entries', {'synced': 1}, where: 'id = ?', whereArgs: [id]);
        }
        await batch.commit(noResult: true);
    }
}