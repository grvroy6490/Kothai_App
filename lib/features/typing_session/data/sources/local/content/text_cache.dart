

import 'dart:convert';

import 'package:kothai_app/core/constants/typin_session_constants.dart';
import 'package:kothai_app/features/typing_session/data/dto/content/text_paragraph_dto.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_paragraph.dart';
import 'package:kothai_app/services/shared_prefs_service.dart';

class TextCache {
    TextCache(this.prefs);
    final SharedPrefsService prefs;
    static const key = kPreloadedTextsPrefsKey; // from core/constants

    Future<void> write(List<TextParagraph> items) async {
        final encoded = jsonEncode(items
                .map((e) => TextParagraphDto.fromEntity(e).toJson())
                .toList());
        await prefs.setString(key, encoded);
    }

    List<TextParagraph> read() {
        final data = prefs.getString(key);
        if (data == null) return [];
        final decoded = jsonDecode(data) as List;
        return decoded
            .map((e) => TextParagraphDto.fromJson(e as Map<String, dynamic>).toEntity())
            .toList();
    }

    Future<void> clear() => prefs.remove(key);
}
