


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/features/typing_session/data/repositories_impl/content/text_content_repo_impl.dart';
import 'package:visai/features/typing_session/data/sources/adaptor/content_local_source_adaptor.dart';
import 'package:visai/features/typing_session/data/sources/local/content/content_local_source.dart';
import 'package:visai/features/typing_session/domain/contracts/content/text_content_fetcher.dart';
import 'package:visai/features/typing_session/domain/enums/content_type_enum.dart';
import 'package:visai/features/typing_session/domain/repositories/content/text_content_repo.dart';
import 'package:visai/features/typing_session/usecases/content/text_content_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_content_repo_provider.g.dart';



@riverpod
TextContentCache textContentCache(
    Ref ref, {
    required String key,
}) {
    final prefs = ref.watch(sharedPrefsServiceProvider);
    return TextContentCache(prefs, key);
}

/// Fetcher for practice content
@riverpod
TextContentFetcher practiceContentFetcher(Ref ref) {
    return ContentLocalSourceAdaptor(ContentTypeEnum.practice); // TODO: update data source
}

/// Fetcher for challenge content
@riverpod
TextContentFetcher challengeContentFetcher(Ref ref) {
    return ContentLocalSourceAdaptor(ContentTypeEnum.challenge); // TODO: update data source
}

/// Repository for practice content
@riverpod
TextContentRepository practiceContentRepository(Ref ref) {
    return TextContentRepoImpl(
        fetcher: ref.watch(practiceContentFetcherProvider),
        cache: ref.watch(textContentCacheProvider(key: kPreloadedPracticeTextsPrefsKey))
    );
}

/// Repository for challenge content
@riverpod
TextContentRepository challengeContentRepository(Ref ref) {
    return TextContentRepoImpl(
        fetcher: ref.watch(challengeContentFetcherProvider),
        cache: ref.watch(textContentCacheProvider(key: kPreloadedChallengeTextsPrefsKey))
    );
}