

import 'package:dio/dio.dart';
import 'package:kothai_app/core/constants/endpoints.dart';
import 'package:riverpod/riverpod.dart';

final dioProvider = Provider<Dio>((ref) =>
    Dio(BaseOptions(baseUrl: dataAPIEndpoint)));