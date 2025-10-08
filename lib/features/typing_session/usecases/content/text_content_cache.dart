

import 'dart:convert';

import 'package:kothai_app/core/constants/typing_session_constants.dart';
import 'package:kothai_app/features/typing_session/data/dto/content/text_content.dto.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_content.dart';
import 'package:kothai_app/services/shared_preferences/shared_prefs_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextContentCache{
    final SharedPrefsService prefs;
    final String key;

    TextContentCache(this.prefs, this.key);

    Future<void> write(List<TextContent> items) async {
        final encoded = jsonEncode(items
            .map((e) => TextContentDto.fromEntity(e).toJson())
            .toList());
        await prefs.setString(key, encoded);
    }


    List<TextContent> read() {
        final data = prefs.getString(key);
        if (data == null) return [];
        final decoded = jsonDecode(data) as List;
        return decoded
            .map((e) => TextContentDto.fromJson(e as Map<String, dynamic>).toEntity())
            .toList();
    }


    Future<void> clear() => prefs.remove(key);
}