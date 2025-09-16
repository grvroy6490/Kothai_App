


import 'package:kothai_app/features/typing_session/data/sources/local/content/asset_texts_source.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/content/text_cache.dart';
import 'package:kothai_app/features/typing_session/data/sources/remote/content/text_api_service.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_paragraph.dart';
import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/content/text_repository.dart';

class TextRepositoryImpl  implements TextRepository {
    final TextApiService api;         // optional for fallback/generation
    final AssetTextsSource assets;    // local bundled JSON
    final TextCache cache;            // SharedPrefs cache

    TextRepositoryImpl({
        required this.api,
        required this.assets,
        required this.cache
    });

    @override
    Future<List<TextParagraph>> getPreloadedTexts() async {
        return cache.read();
    }

    @override
    Future<List<TextParagraph>> getRandomizedTexts() async {
        final texts = List<TextParagraph>.from(cache.read()); // clone it
        texts.shuffle();
        return texts;
    }

    @override
    Future<void> preloadInitialTexts({
        required DifficultyEnum difficulty,
        required bool randomize
    }) async {
        // 1) get all assets
        final all = await assets.loadAllFromAssets();

        // 2) filter by difficulty (moved here from UI/ref)
        var filtered = all.where((p) => p.difficulty == difficulty).toList();

        if (filtered.isEmpty) {
            // TODO: OPTIONAL: Generate via API and fallback
            // for (int i=0; i<5; i++) {...}
        }

        // 3) randomize if asked
        if (randomize) filtered.shuffle();

        // 4) cache
        await cache.write(filtered);
    }

}