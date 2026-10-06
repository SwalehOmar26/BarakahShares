import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_env.dart';
import '../../core/errors/app_exception.dart';
import '../../models/records.dart';
import '../payment_service.dart';

/// Safaricom Daraja sandbox STK push. Selected only when [AppEnv.darajaReady]
/// is true. The investor UI keeps the mock service otherwise.
class DarajaPaymentService implements PaymentService {
  DarajaPaymentService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const _sandbox = 'https://sandbox.safaricom.co.ke';

  @override
  Future<PaymentResult> requestStkPush({
    required String phone,
    required int amountKes,
    required String businessId,
  }) async {
    if (!AppEnv.darajaReady) {
      throw const AppException('Daraja is not enabled.');
    }
    final token = await _accessToken();
    final timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    final password = base64Encode(
      utf8.encode('${AppEnv.darajaShortCode}${AppEnv.darajaPasskey}$timestamp'),
    );
    final msisdn = phone.replaceAll('+', '');
    final response = await _dio.post<Map<String, dynamic>>(
      '$_sandbox/mpesa/stkpush/v1/processrequest',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {
        'BusinessShortCode': AppEnv.darajaShortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amountKes,
        'PartyA': msisdn,
        'PartyB': AppEnv.darajaShortCode,
        'PhoneNumber': msisdn,
        'CallBackURL': AppEnv.darajaCallbackUrl,
        'AccountReference': businessId,
        'TransactionDesc': 'BarakahShares equity',
      },
    );
    final body = response.data ?? {};
    final checkout = body['CheckoutRequestID']?.toString();
    if (checkout == null || checkout.isEmpty) {
      throw const AppException('Daraja did not return a checkout request.');
    }
    return PaymentResult(
      success: true,
      reference: checkout,
      txHash: 'pending-callback',
      network: 'Base Sepolia Testnet',
      contractShort: '0x7a3F...9eB2',
      note: 'Daraja sandbox STK requested. Funds are not recorded until the callback.',
    );
  }

  Future<String> _accessToken() async {
    final basic = base64Encode(
      utf8.encode('${AppEnv.darajaConsumerKey}:${AppEnv.darajaConsumerSecret}'),
    );
    final response = await _dio.get<Map<String, dynamic>>(
      '$_sandbox/oauth/v1/generate',
      queryParameters: {'grant_type': 'client_credentials'},
      options: Options(headers: {'Authorization': 'Basic $basic'}),
    );
    final token = response.data?['access_token']?.toString();
    if (token == null || token.isEmpty) {
      throw const AppException('Daraja did not return an access token.');
    }
    return token;
  }
}
