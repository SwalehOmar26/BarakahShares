import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import 'api_config.dart';
import 'api_exception.dart';
import '../../shared/storage/secure_store.dart';

Dio createDio({required SecureStore store, String? baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await store.read(AppConstants.tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } on Object {
          // A missing token must not block the request. The API can reject it.
        }
        handler.next(options);
      },
    ),
  );

  return dio;
}

Future<T> guardDio<T>(Future<T> Function() run) async {
  try {
    return await run();
  } on DioException catch (error) {
    final data = error.response?.data;
    if (data is Map && data['message'] is String) {
      throw ApiException(data['message'] as String);
    }
    throw ApiException(error.message ?? 'The request could not be completed.');
  }
}

Map<String, dynamic> expectMap(Object? data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  throw const ApiException(
    'The server response was not in the expected format.',
  );
}

List<Map<String, dynamic>> expectMapList(Object? data, {String? key}) {
  Object? source = data;
  if (key != null && data is Map && data[key] is List) {
    source = data[key];
  }
  if (source is List) {
    return source.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }
  throw const ApiException(
    'The server response was not in the expected format.',
  );
}
