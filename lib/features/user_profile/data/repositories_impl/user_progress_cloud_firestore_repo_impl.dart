import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visai/features/typing_session/domain/entities/metrics/metrics_entity.dart';
import 'package:visai/features/typing_session/domain/entities/session/session_entity.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/domain/enums/session_mode.dart';
import 'package:visai/features/user_profile/domain/repositories/user_progress_cloud_repository.dart';

class UserProgressCloudFirestoreRepositoryImpl
    implements UserProgressCloudRepository {
  UserProgressCloudFirestoreRepositoryImpl(this._db);

  final FirebaseFirestore _db;

  static const String _badgesDocId = 'badges';

  Map<String, dynamic> _sessionToFirestore(SessionEntity s) {
    return <String, dynamic>{
      'id': s.id,
      'mode': s.mode.name,
      'difficulty': s.difficulty.name,
      'startedAt': Timestamp.fromDate(s.startedAt),
      'endedAt': Timestamp.fromDate(s.endedAt),
      'metrics': <String, dynamic>{
        'typed': s.metrics.typed,
        'correct': s.metrics.correct,
        'errors': s.metrics.errors,
        'elapsedMs': s.metrics.elapsedMs,
        'totalChars': s.metrics.totalChars,
      },
    };
  }

  SessionEntity _sessionFromFirestore(Map<String, dynamic> data) {
    final started = data['startedAt'];
    final ended = data['endedAt'];
    DateTime startedAt;
    DateTime endedAt;
    if (started is Timestamp) {
      startedAt = started.toDate();
    } else if (started is String) {
      startedAt = DateTime.parse(started);
    } else {
      startedAt = DateTime.fromMillisecondsSinceEpoch(0);
    }
    if (ended is Timestamp) {
      endedAt = ended.toDate();
    } else if (ended is String) {
      endedAt = DateTime.parse(ended);
    } else {
      endedAt = DateTime.fromMillisecondsSinceEpoch(0);
    }

    final rawM = data['metrics'];
    final Map<String, dynamic> m = rawM is Map
        ? Map<String, dynamic>.from(rawM)
        : <String, dynamic>{};

    final metrics = MetricsEntity(
      typed: (m['typed'] as num?)?.toInt() ?? 0,
      correct: (m['correct'] as num?)?.toInt() ?? 0,
      errors: (m['errors'] as num?)?.toInt() ?? 0,
      elapsedMs: (m['elapsedMs'] as num?)?.toInt() ?? 0,
      totalChars: (m['totalChars'] as num?)?.toInt() ?? 0,
    );

    return SessionEntity(
      id: data['id'] as String,
      mode: SessionMode.values.byName(data['mode'] as String),
      difficulty: DifficultyEnum.values.byName(data['difficulty'] as String),
      startedAt: startedAt,
      endedAt: endedAt,
      metrics: metrics,
    );
  }

  @override
  Future<void> uploadBadges(String uid, Set<String> badgeIds) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('stats')
        .doc(_badgesDocId)
        .set(
          <String, dynamic>{
            'badgeIds': badgeIds.toList()..sort(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
  }

  @override
  Future<Set<String>?> fetchBadges(String uid) async {
    final snap = await _db
        .collection('users')
        .doc(uid)
        .collection('stats')
        .doc(_badgesDocId)
        .get();
    if (!snap.exists) return null;
    final raw = snap.data()?['badgeIds'];
    if (raw is! List) return null;
    return raw.map((e) => e.toString()).toSet();
  }

  @override
  Future<void> uploadSessions(String uid, List<SessionEntity> sessions) async {
    if (sessions.isEmpty) return;

    final col = _db.collection('users').doc(uid).collection('sessions');

    const chunk = 400;
    for (var i = 0; i < sessions.length; i += chunk) {
      final batch = _db.batch();
      for (final s in sessions.skip(i).take(chunk)) {
        final ref = col.doc(s.id);
        batch.set(ref, _sessionToFirestore(s), SetOptions(merge: true));
      }
      await batch.commit();
    }
  }

  @override
  Future<List<SessionEntity>> fetchSessions(String uid) async {
    final snap =
        await _db.collection('users').doc(uid).collection('sessions').get();
    return snap.docs
        .map((d) => _sessionFromFirestore(Map<String, dynamic>.from(d.data())))
        .toList();
  }
}
