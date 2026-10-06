import 'package:dio/dio.dart';

import '../constants/app_env.dart';

/// HTTP client reserved for Phase 2 APIs. The UI does not call it yet.
class ApiClient {
  ApiClient()
    : dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          headers: {'Accept': 'application/json'},
        ),
      );

  final Dio dio;

  bool get hasSupabaseHost => AppEnv.hasSupabase;
}
