import 'package:kothai_app/domain/contracts/gamification/gamification_data_fetcher.dart';
import 'package:kothai_app/domain/entities/gamification/gamification_entity.dart';
import 'package:kothai_app/domain/repositories/gamification/gamification_repository.dart';
import 'package:kothai_app/domain/usecases/gamification/gamification_cache.dart';
import 'package:logger/logger.dart';

class GamificationRepoImpl extends GamificationRepository {
    final GamificationDataFetcher fetcher;
    final GamificationCache cache;
    final _logger = Logger();

    GamificationRepoImpl(this.cache, this.fetcher);

    @override
    Future<GamificationEntity?> getGamificationData() async {
        return await cache.read();
    }

    @override
    Future<void> preloadGamificationData() async {
        final existingData = await fetcher.fetch();

        if (existingData == null) {
            return;
        }

        try {
            await cache.write(existingData!);
        } catch (e, s) {
            _logger.e(
                'Failed to fetch and cache gamification data',
                error: e,
                stackTrace: s
            );
        }
    }
}
