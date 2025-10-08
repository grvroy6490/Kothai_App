

import 'package:kothai_app/domain/entities/gamification/gamification_entity.dart';

abstract class GamificationRepository {
    Future<void> preloadGamificationData();

    Future<GamificationEntity?> getGamificationData();
}