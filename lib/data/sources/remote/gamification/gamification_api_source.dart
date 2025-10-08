

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kothai_app/core/constants/endpoints.dart';
import 'package:kothai_app/domain/contracts/gamification/gamification_data_fetcher.dart';
import 'package:kothai_app/domain/entities/gamification/gamification_entity.dart';

class GamificationApiSourceFetcher implements GamificationDataFetcher{
    final Dio dio;

    GamificationApiSourceFetcher(this.dio);

    @override
    Future<GamificationEntity> fetch() async {
        final response = await dio.get(getGamificationData);

        // Decode string to Map
        final Map<String, dynamic> jsonMap = jsonDecode(response.data) as Map<String, dynamic>;

        // Deserialize into GamificationEntity
        final gamificationEntity = GamificationEntity.fromJson(jsonMap);

        return gamificationEntity;
    }

}