

import 'package:visai/features/typing_session/domain/entities/metrics/metrics_entity.dart';
import 'package:visai/features/typing_session/domain/entities/session/session_entity.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:sqflite/sqflite.dart';

class SessionDao {
    final Database db;
    SessionDao(this.db);

    Future<void> insert(SessionEntity s) async {
        await db.insert(
            'sessions',
            {
                'id': s.id,
                'mode': s.mode.name,
                'difficulty': s.difficulty.name,
                'startedAt': s.startedAt.millisecondsSinceEpoch,
                'endedAt': s.endedAt.millisecondsSinceEpoch,
                'typed': s.metrics.typed,
                'correct': s.metrics.correct,
                'errors': s.metrics.errors,
                'elapsedMs': s.metrics.elapsedMs
            },
            conflictAlgorithm: ConflictAlgorithm.replace
        );
    }

    Future<List<SessionEntity>> list({int? limit}) async {
        final rows = await db.query(
            'sessions',
            orderBy: 'endedAt DESC',
            limit: limit
        );
        return rows.map((e) {
                return SessionEntity(
                    id: e['id'] as String,
                    mode: SessionMode.values.byName(e['mode'] as String),
                    difficulty: DifficultyEnum.values.byName(e['difficulty'] as String),
                    startedAt: DateTime.fromMillisecondsSinceEpoch(e['startedAt'] as int),
                    endedAt: DateTime.fromMillisecondsSinceEpoch(e['endedAt'] as int),
                    metrics: MetricsEntity(
                        typed: e['typed'] as int,
                        correct: e['correct'] as int,
                        errors: e['errors'] as int,
                        elapsedMs: e['elapsedMs'] as int
                    )
                );
            }).toList();
    }

    Future<int> count() async {
        final x = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM sessions')
        );
        return x ?? 0;
    }

    Future<void> deleteOldest(int n) async {
        // delete N oldest rows
        await db.rawDelete('DELETE FROM sessions WHERE id IN ('
            'SELECT id FROM sessions ORDER BY endedAt ASC LIMIT ?)', [n]);
    }

    Future<void> deleteAll() async {
        await db.delete('sessions');
    }
}