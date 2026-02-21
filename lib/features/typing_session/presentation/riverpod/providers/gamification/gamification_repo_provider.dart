

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visai/data/repositories/gamification/gamification_repo_impl.dart';
import 'package:visai/data/sources/local/gamification/gamification_local_source.dart';
import 'package:visai/di/providers/shared_preferences/shared_prefs_provider.dart';
import 'package:visai/domain/contracts/gamification/gamification_data_fetcher.dart';
import 'package:visai/domain/repositories/gamification/gamification_repository.dart';
import 'package:visai/domain/usecases/gamification/gamification_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gamification_repo_provider.g.dart';


@riverpod
GamificationCache gamificationCache(Ref ref){
    final prefs = ref.watch(sharedPrefsServiceProvider);
    return GamificationCache(prefs);
}

@riverpod
GamificationDataFetcher gamificationDataFetcher(Ref ref){
    return GamificationLocalSourceFetcher(); // TODO: update for gamification source
}


@riverpod
GamificationRepository gamificationRepository(Ref ref){
    return GamificationRepoImpl(
        ref.watch(gamificationCacheProvider),
        ref.watch(gamificationDataFetcherProvider)
    );
}