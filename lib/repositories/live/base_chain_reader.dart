import 'package:dio/dio.dart';

import '../../core/constants/app_env.dart';
import '../../core/errors/app_exception.dart';

/// Read-only Base JSON-RPC. The phone never holds a signing key.
class BaseChainReader {
  BaseChainReader({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<String> chainId() async {
    final value = await _call('eth_chainId', const []);
    return value?.toString() ?? '';
  }

  Future<bool> contractDeployed() async {
    final code = await _call('eth_getCode', [AppEnv.chainContract, 'latest']);
    final hex = code?.toString() ?? '0x';
    return hex != '0x' && hex != '0x0';
  }

  Future<Object?> _call(String method, List<Object?> params) async {
    if (!AppEnv.baseReady) {
      throw const AppException('BASE_RPC_URL is not set. No chain call was sent.');
    }
    final response = await _dio.post<Map<String, dynamic>>(
      AppEnv.baseRpcUrl,
      data: {'jsonrpc': '2.0', 'id': 1, 'method': method, 'params': params},
    );
    final error = response.data?['error'];
    if (error != null) {
      throw AppException('Base RPC returned an error.');
    }
    return response.data?['result'];
  }
}
