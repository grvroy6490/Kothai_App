import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/constants/constants.dart';
import 'package:visai/core/shared_prefs/shared_prefs_service.dart';
import 'package:visai/data/models/content/text_paragraph_dto.dart';
import 'package:visai/domain/entities/content/text_paragraph.dart';
import 'package:visai/domain/repositories/content/text_repository.dart';
import 'package:visai/presentation/providers/content/asset_text_provider.dart';
import 'package:visai/presentation/providers/practice/practice_configuration_provider.dart';

class TextRepositoryImpl implements TextRepository {
    // final TextApiService api;
    final SharedPrefsService prefs;
    final Ref ref;

    // TextRepositoryImpl(this.api, this.prefs, this.ref);
    TextRepositoryImpl(this.prefs, this.ref);

    @override
    Future<void> preloadInitialTexts() async {
        final paragraphContentData = ref.watch(assetTextsProvider);
        final difficultyLevel = ref
            .watch(practiceConfigurationProvider)
            .difficulty;
        final paragraphList = paragraphContentData.value
            ?.where((para) => para.difficulty == difficultyLevel)
            .toList() ?? [];

        // If paragraphList is empty, fetch from API and store
        if (paragraphList.isNotEmpty) {
            final List<TextParagraph> allTexts = [];

            for (final entry in paragraphList) {
                allTexts.add(TextParagraph(
                        difficulty: entry.difficulty,
                        content: entry.content,
                    ));
            }

            final encoded = jsonEncode(
                allTexts.map((e) => TextParagraphDto.fromEntity(e).toJson()).toList(),
            );

            await prefs.setString(kPreloadedTextsPrefsKey, encoded);
        }
    }

    // TODO: ORIGINAL CODE TO FETCH FROM API
    // final List<TextParagraph> allTexts = [];
    //
    // const difficulties = DifficultyWPM.values;
    //
    // for (final entry in difficulties.toList()) {
    //     for (int i = 0; i < 5; i++) {
    //         final content = await api.generateParagraph(wordCount: entry.wpm);
    //         allTexts.add(TextParagraph(difficulty: DifficultyEnum.values[i], content: content));
    //     }
    // }
    //
    // final encoded = jsonEncode(
    //     allTexts.map((e) => TextParagraphDto.fromEntity(e).toJson()).toList(),
    // );
    //
    // await prefs.setString(_key, encoded);

    @override
    Future<List<TextParagraph>> getPreloadedTexts() async {
        final data = prefs.getString(kPreloadedTextsPrefsKey);
        if (data == null) return [];

        final decoded = jsonDecode(data) as List;
        final texts = decoded.map((e) => TextParagraphDto.fromJson(e).toEntity()).toList();

        final shouldRandomize = ref.read(practiceConfigurationProvider).randomize;
        if (shouldRandomize) {
            texts.shuffle();
        }
        return texts;
    }
}
