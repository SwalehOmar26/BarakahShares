import 'package:dio/dio.dart';

import '../../core/network/api_exception.dart';
import '../../core/network/dio_client.dart';
import '../data/demo_catalog.dart';
import '../models/business_opportunity.dart';
import 'demo_delay.dart';

abstract class BusinessRepository {
  Future<List<BusinessOpportunity>> fetchBusinesses();
  Future<BusinessOpportunity> fetchCampaign(String id);
}

class MockBusinessRepository implements BusinessRepository {
  @override
  Future<List<BusinessOpportunity>> fetchBusinesses() async {
    await demoDelay();
    return List<BusinessOpportunity>.unmodifiable(DemoCatalog.businesses);
  }

  @override
  Future<BusinessOpportunity> fetchCampaign(String id) async {
    await demoDelay();
    final business = DemoCatalog.businessById(id);
    if (business == null) {
      throw const ApiException(
        'That business is not in the demonstration catalogue.',
      );
    }
    return business;
  }
}

class RemoteBusinessRepository implements BusinessRepository {
  RemoteBusinessRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<BusinessOpportunity>> fetchBusinesses() {
    return guardDio(() async {
      final response = await _dio.get<Object>('/businesses');
      final rows = expectMapList(response.data, key: 'businesses');
      return rows.map(_fromJson).toList();
    });
  }

  @override
  Future<BusinessOpportunity> fetchCampaign(String id) {
    return guardDio(() async {
      final response = await _dio.get<Object>('/businesses/$id');
      return _fromJson(expectMap(response.data));
    });
  }

  BusinessOpportunity _fromJson(Map<String, dynamic> json) {
    return BusinessOpportunity(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Business',
      location: json['location'] as String? ?? '',
      category: _category(json['category'] as String?),
      campaignStatus: _status(json['campaignStatus'] as String?),
      description: json['description'] as String? ?? '',
      registrationNumber: json['registrationNumber'] as String? ?? '',
      kraStatus: json['kraStatus'] as String? ?? '',
      halalStatus: json['halalStatus'] as String? ?? '',
      historicalMonthlyProfit:
          (json['historicalMonthlyProfit'] as num?)?.toDouble() ?? 0,
      fundingTarget: (json['fundingTarget'] as num?)?.toDouble() ?? 0,
      amountRaised: (json['amountRaised'] as num?)?.toDouble() ?? 0,
      minInvestment: (json['minInvestment'] as num?)?.toDouble() ?? 0,
      pricePerShare: (json['pricePerShare'] as num?)?.toDouble() ?? 100,
      ownershipOfferedPercent:
          (json['ownershipOfferedPercent'] as num?)?.toDouble() ?? 0,
      zakatableAssetRatio:
          (json['zakatableAssetRatio'] as num?)?.toDouble() ?? 0,
      risks: (json['risks'] as List?)?.whereType<String>().toList() ?? const [],
      documents: const [],
      history: const [],
      verificationLabel: json['verificationLabel'] as String? ?? 'Unverified',
    );
  }

  BusinessCategory _category(String? value) {
    return BusinessCategory.values.firstWhere(
      (item) => item.name == value,
      orElse: () => BusinessCategory.retail,
    );
  }

  CampaignStatus _status(String? value) {
    return CampaignStatus.values.firstWhere(
      (item) => item.name == value,
      orElse: () => CampaignStatus.inReview,
    );
  }
}
