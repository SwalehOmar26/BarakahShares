enum UserRole { youthInvestor, businessOwner }

enum KycStatus { notStarted, pending, verified, failed }

enum CampaignStatus { funding, fundingSoon, funded }

enum VerificationStatus { verified, pending, failed }

enum DistributionStatus { pending, disbursed }

enum ChainTxType { investment, dividend, receiptHash }

enum ActivityKind { investment, dividend, certificate }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.youthInvestor => 'Youth Investor',
    UserRole.businessOwner => 'Business Owner',
  };
}

extension KycStatusX on KycStatus {
  String get label => switch (this) {
    KycStatus.notStarted => 'Not started',
    KycStatus.pending => 'Pending',
    KycStatus.verified => 'Verified',
    KycStatus.failed => 'Failed',
  };
}

extension VerificationStatusX on VerificationStatus {
  String get label => switch (this) {
    VerificationStatus.verified => 'Verified',
    VerificationStatus.pending => 'Pending',
    VerificationStatus.failed => 'Failed',
  };
}

extension CampaignStatusX on CampaignStatus {
  String get label => switch (this) {
    CampaignStatus.funding => 'Funding',
    CampaignStatus.fundingSoon => 'Funding soon',
    CampaignStatus.funded => 'Funded',
  };
}

extension DistributionStatusX on DistributionStatus {
  String get label => switch (this) {
    DistributionStatus.pending => 'Pending',
    DistributionStatus.disbursed => 'Disbursed',
  };
}
