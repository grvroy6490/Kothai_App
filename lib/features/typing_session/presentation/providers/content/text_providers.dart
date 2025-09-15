// features/typing/presentation/providers/text_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kothai_app/di/poviders/dio_provider.dart';
import 'package:kothai_app/di/poviders/shared_prefs_provider.dart';
import 'package:kothai_app/features/typing_session/data/repositories_impl/content/text_repository_impl.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/content/asset_texts_source.dart';
import 'package:kothai_app/features/typing_session/data/sources/local/content/text_cache.dart';
import 'package:kothai_app/features/typing_session/data/sources/remote/content/text_api_service.dart';
import 'package:kothai_app/features/typing_session/domain/entities/content/text_paragraph.dart';
import 'package:kothai_app/features/typing_session/domain/repositories/content/text_repository.dart';
import 'package:kothai_app/features/typing_session/usecases/content/preload_typing_texts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_providers.g.dart';

@riverpod
class TextContent extends _$TextContent {
    @override
    TextParagraph? build() {
        return ref.watch(preloadedTextsProvider).maybeWhen(
            data: (list) => list.isNotEmpty ? list.first : null,
            orElse: () => null
        );
    }
    void setTextContent(TextParagraph t) => state = t;
    void clearTextContent() => state = null;
}


@riverpod
TextApiService textApiService(Ref ref) =>
TextApiService(ref.watch(dioProvider));

@riverpod
AssetTextsSource assetTextsSource(Ref ref) => AssetTextsSource();

@riverpod
TextCache textCache(Ref ref) =>
TextCache(ref.watch(sharedPrefsServiceProvider));

@riverpod
TextRepository textRepository(Ref ref) => TextRepositoryImpl(
    api: ref.watch(textApiServiceProvider),
    assets: ref.watch(assetTextsSourceProvider),
    cache: ref.watch(textCacheProvider)
);

@riverpod
PreloadTypingTexts preloadTypingTexts(Ref ref) =>
PreloadTypingTexts(ref.watch(textRepositoryProvider));

@riverpod
Future<List<TextParagraph>> preloadedTexts(Ref ref) async =>
ref.watch(textRepositoryProvider).getPreloadedTexts();

