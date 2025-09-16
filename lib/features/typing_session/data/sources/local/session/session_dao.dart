

import 'package:kothai_app/features/typing_session/domain/entities/metrics/metrics.dart';
import 'package:kothai_app/features/typing_session/domain/entities/session/typing_session.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/enums/session_mode.dart';
import 'package:sqflite/sqflite.dart';

class SessionDao {
    final Database db;
    SessionDao(this.db);

    Future<void> insert(TypingSession s) async {
        await db.insert(
            'typing_sessions',
            {
                'id': s.id,
                'mode': s.mode.name,
                'difficulty': s.difficulty.name,
                'startedAt': s.startedAt.millisecondsSinceEpoch,
                'endedAt': s.endedAt.millisecondsSinceEpoch,
                'typed': s.metrics.typed,
                'correct': s.metrics.correct,
                'errors': s.metrics.errors,
                'elapsedMs': s.metrics.elapsedMs,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    Future<List<TypingSession>> list({int? limit}) async {
        final rows = await db.query(
            'typing_sessions',
            orderBy: 'endedAt DESC',
            limit: limit,
        );
        return rows.map((e) {
            return TypingSession(
                id: e['id'] as String,
                mode: SessionMode.values.byName(e['mode'] as String),
                difficulty: DifficultyEnum.values.byName(e['difficulty'] as String),
                startedAt: DateTime.fromMillisecondsSinceEpoch(e['startedAt'] as int),
                endedAt: DateTime.fromMillisecondsSinceEpoch(e['endedAt'] as int),
                metrics: Metrics(
                    typed: e['typed'] as int,
                    correct: e['correct'] as int,
                    errors: e['errors'] as int,
                    elapsedMs: e['elapsedMs'] as int,
                ),
            );
        }).toList();
    }

    Future<int> count() async {
        final x = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM typing_sessions'),
        );
        return x ?? 0;
    }

    Future<void> deleteOldest(int n) async {
        // delete N oldest rows
        await db.rawDelete('DELETE FROM typing_sessions WHERE id IN ('
            'SELECT id FROM typing_sessions ORDER BY endedAt ASC LIMIT ?)', [n]);
    }
}