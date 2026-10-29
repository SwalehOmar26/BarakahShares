class PortfolioHolding {
  const PortfolioHolding({
    required this.businessId,
    required this.amountInvested,
    required this.shares,
    required this.investedOn,
    required this.certificateId,
    required this.illustrativeValueChange,
  });

  final String businessId;
  final double amountInvested;
  final int shares;
  final DateTime investedOn;
  final String certificateId;
  final double illustrativeValueChange;

  PortfolioHolding copyWith({
    double? amountInvested,
    int? shares,
    double? illustrativeValueChange,
  }) {
    return PortfolioHolding(
      businessId: businessId,
      amountInvested: amountInvested ?? this.amountInvested,
      shares: shares ?? this.shares,
      investedOn: investedOn,
      certificateId: certificateId,
      illustrativeValueChange:
          illustrativeValueChange ?? this.illustrativeValueChange,
    );
  }
}

class InvestmentTransaction {
  const InvestmentTransaction({
    required this.reference,
    required this.businessId,
    required this.amount,
    required this.shares,
    required this.date,
    required this.certificateId,
    required this.phone,
    required this.statusLabel,
  });

  final String reference;
  final String businessId;
  final double amount;
  final int shares;
  final DateTime date;
  final String certificateId;
  final String phone;
  final String statusLabel;
}

class OwnershipRecord {
  const OwnershipRecord({
    required this.certificateId,
    required this.businessId,
    required this.businessName,
    required this.shares,
    required this.ownershipPercent,
    required this.recordedOn,
    required this.isLiveChainRecord,
  });

  final String certificateId;
  final String businessId;
  final String businessName;
  final int shares;
  final double ownershipPercent;
  final DateTime recordedOn;
  final bool isLiveChainRecord;
}

enum RecordKind { expense, income }

class FinancialRecord {
  const FinancialRecord({
    required this.id,
    required this.businessId,
    required this.kind,
    required this.title,
    required this.date,
    required this.amount,
    required this.documentType,
    required this.verificationStatus,
    required this.detail,
    this.liveTransactionHash,
  });

  final String id;
  final String businessId;
  final RecordKind kind;
  final String title;
  final DateTime date;
  final double amount;
  final String documentType;
  final String verificationStatus;
  final String detail;
  final String? liveTransactionHash;

  bool get hasLiveChainReference =>
      liveTransactionHash != null && liveTransactionHash!.isNotEmpty;
}

class ProfitSnapshot {
  const ProfitSnapshot({
    required this.businessId,
    required this.periodLabel,
    required this.grossSales,
    required this.expenses,
    required this.investorAllocation,
    required this.distributionStatus,
  });

  final String businessId;
  final String periodLabel;
  final double grossSales;
  final double expenses;
  final double investorAllocation;
  final String distributionStatus;

  double get netProfit => grossSales - expenses;
}

enum PaymentOutcome { pending, successful, failed, cancelled }

class PaymentAttempt {
  const PaymentAttempt({
    required this.reference,
    required this.outcome,
    required this.businessId,
    required this.amount,
    required this.phone,
    required this.shares,
    required this.certificateId,
    required this.createdAt,
  });

  final String reference;
  final PaymentOutcome outcome;
  final String businessId;
  final double amount;
  final String phone;
  final int shares;
  final String? certificateId;
  final DateTime createdAt;
}

class ChainEvent {
  const ChainEvent({
    required this.id,
    required this.title,
    required this.typeLabel,
    required this.date,
    required this.status,
    required this.detail,
    required this.isLive,
    this.transactionHash,
  });

  final String id;
  final String title;
  final String typeLabel;
  final DateTime date;
  final String status;
  final String detail;
  final bool isLive;
  final String? transactionHash;

  bool get canOpenExplorer =>
      isLive && transactionHash != null && transactionHash!.isNotEmpty;
}

class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.read,
    this.businessId,
  });

  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool read;
  final String? businessId;

  AppNotificationItem copyWith({bool? read}) {
    return AppNotificationItem(
      id: id,
      title: title,
      body: body,
      date: date,
      read: read ?? this.read,
      businessId: businessId,
    );
  }
}
