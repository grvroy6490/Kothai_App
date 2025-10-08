


import 'package:kothai_app/domain/entities/gamification/gamification_entity.dart';

abstract interface class GamificationDataFetcher{
    Future<GamificationEntity?> fetch();
}