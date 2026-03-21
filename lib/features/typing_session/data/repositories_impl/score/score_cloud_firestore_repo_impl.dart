import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visai/features/typing_session/domain/entities/score/score_entity.dart';
import 'package:visai/features/typing_session/domain/repositories/score/score_cloud_db_repository.dart';

/// Firestore implementation of [XpCloudRepository] for syncing XP totals and entries.
class ScoreCloudFirestoreRepositoryImpl implements XpCloudRepository {
  final FirebaseFirestore _db;

  ScoreCloudFirestoreRepositoryImpl(this._db);

  static const String _v1TotalsDocId = 'v1';

  static Map<String, dynamic> _scoreEntryToFirestore(ScoreEntry entry,
      {required bool synced}) {
    // Firestore rules expect `at` to be a timestamp, not a string.
    return <String, dynamic>{
      'id': entry.id,
      'at': Timestamp.fromDate(entry.at),
      'mode': entry.mode,
      'amount': entry.amount,
      'synced': synced,
      'sessionId': entry.sessionId,
    };
  }

  @override
  Future<void> uploadTotals(String uid, ScoreEntity totals) async {
    // Matches existing firestore.rules:
    // match /users/{userId}/score/{scoreId}
    final ref = _db.collection('users').doc(uid).collection('score').doc(_v1TotalsDocId);

    await ref.set(totals.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> uploadEntries(String uid, List<ScoreEntry> entries) async {
    if (entries.isEmpty) return;

    // Matches existing firestore.rules:
    // match /users/{userId}/xpEntries/{entryId}
    // Doc id must match entry.id.
    final entriesCollection =
        _db.collection('users').doc(uid).collection('xpEntries');

    const int batchSize = 400; // keep safely below Firestore batch limits
    for (var i = 0; i < entries.length; i += batchSize) {
      final batch = _db.batch();
      final chunk = entries.skip(i).take(batchSize).toList();

      for (final entry in chunk) {
        final docRef = entriesCollection.doc(entry.id);
        final payload = _scoreEntryToFirestore(entry, synced: true);
        batch.set(docRef, payload, SetOptions(merge: true));
      }

      await batch.commit();
    }
  }

  @override
  Future<ScoreEntity?> fetchTotals(String uid) async {
    // Matches existing firestore.rules:
    // match /users/{userId}/score/{scoreId}
    final ref = _db.collection('users').doc(uid).collection('score').doc(_v1TotalsDocId);
    final snap = await ref.get();
    if (!snap.exists) return null;
    final data = snap.data();
    if (data == null) return null;
    return ScoreEntity.fromJson(data);
  }

  @override
  Future<List<ScoreEntry>> fetchEntries(String uid) async {
    // Matches existing firestore.rules:
    // match /users/{userId}/xpEntries/{entryId}
    final entriesCollection =
        _db.collection('users').doc(uid).collection('xpEntries');

    final snapshot = await entriesCollection.get();
    return snapshot.docs
        .map((d) {
          // rules expect Firestore `at` to be a Timestamp. Our model expects an ISO string.
          final raw = d.data();
          final json = Map<String, dynamic>.from(raw);
          final atVal = json['at'];
          if (atVal is Timestamp) {
            json['at'] = atVal.toDate().toIso8601String();
          }
          return ScoreEntry.fromJson(json);
        })
        .toList();
  }
}

