

import 'package:dio/dio.dart';
import 'package:visai/core/constants/endpoints.dart';
import 'package:riverpod/riverpod.dart';

final dioProvider = Provider<Dio>((ref) =>
    Dio(BaseOptions(baseUrl: dataAPIEndpoint)));