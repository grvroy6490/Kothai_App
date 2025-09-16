


import 'dart:convert';

import 'package:kothai_app/core/constants/typin_session_constants.dart';
import 'package:kothai_app/features/typing_session/domain/entities/difficulty/difficulty_criteria.dart';
import 'package:kothai_app/services/shared_prefs_service.dart';

class DifficultyCriteriaCache {
    final SharedPrefsService prefs;

    DifficultyCriteriaCache(this.prefs);

    Future<void> write(DifficultyCriteria c) async {
        await prefs.setString(kDifficultyCriteriaKey, jsonEncode(c.toJson()));
    }

    DifficultyCriteria? read() {
        final raw = prefs.getString(kDifficultyCriteriaKey);
        if (raw == null) return null;
        try {
            return DifficultyCriteria.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        } catch (_) {
            return null;
        }
    }

    Future<void> clear() => prefs.remove(kDifficultyCriteriaKey);
}