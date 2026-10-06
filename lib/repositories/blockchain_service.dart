import '../models/blockchain_transaction.dart';

abstract class BlockchainService {
  /// Demo adapter. A later release can back this with Viem on Base.
  String get networkName;

  String get contractAddress;

  String get contractShort;

  String get statusLabel;

  bool get isDemoContract;

  Future<List<BlockchainTransaction>> fetchTransactions(String businessId);
}
