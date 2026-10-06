import 'enums.dart';

class BlockchainTransaction {
  const BlockchainTransaction({
    required this.id,
    required this.businessId,
    required this.type,
    required this.title,
    required this.date,
    required this.status,
    required this.txHash,
    this.amountKes,
    this.anchoredHash,
  });

  final String id;
  final String businessId;
  final ChainTxType type;
  final String title;
  final DateTime date;
  final String status;
  final String txHash;
  final int? amountKes;
  final String? anchoredHash;
}

class ChainOverview {
  const ChainOverview({
    required this.network,
    required this.contractAddress,
    required this.contractShort,
    required this.statusLabel,
    required this.transactions,
  });

  final String network;
  final String contractAddress;
  final String contractShort;
  final String statusLabel;
  final List<BlockchainTransaction> transactions;
}
