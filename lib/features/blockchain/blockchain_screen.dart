import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/investment_card.dart';
import '../../core/widgets/states.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/blockchain_transaction.dart';
import '../../models/enums.dart';
import '../../providers/providers.dart';

class BlockchainScreen extends ConsumerWidget {
  const BlockchainScreen({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(blockchainServiceProvider);
    final txs = ref.watch(chainProvider(businessId));
    return AppScaffold(
      title: 'Blockchain Verification',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Network', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  service.networkName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Contract', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  service.contractShort,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.sm),
                const StatusBadge(
                  label: 'Demo Contract',
                  tone: BadgeTone.warning,
                  icon: Icons.science_outlined,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(AppCopy.demoChain),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AsyncBody<List<BlockchainTransaction>>(
            value: txs,
            onRetry: () => ref.invalidate(chainProvider(businessId)),
            data: (items) {
              if (items.isEmpty) {
                return const EmptyState(
                  title: 'No demo transactions',
                  message:
                      'An investment will add a sample record to this list.',
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final tx in items) ...[
                    TransactionCard(
                      title: tx.title,
                      subtitle:
                          '${formatDate(tx.date)} · ${tx.status} · ${truncateMiddle(tx.txHash)}',
                      trailing: _trailing(tx),
                      onTap: () => _explorer(context, service.networkName, tx),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'View on BaseScan',
            onPressed: () => _explorer(context, service.networkName, null),
          ),
        ],
      ),
    );
  }

  String _trailing(BlockchainTransaction tx) {
    if (tx.amountKes == null) return 'Hash';
    final prefix = tx.type == ChainTxType.investment ? '+' : '';
    return '$prefix${formatKes(tx.amountKes!)}';
  }

  Future<void> _explorer(
    BuildContext context,
    String network,
    BlockchainTransaction? tx,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo explorer',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'BaseScan is not opened. This sheet stands in for a $network transaction page.',
            ),
            const SizedBox(height: AppSpacing.sm),
            if (tx != null) ...[
              Text('Type: ${tx.title}'),
              Text('Status: ${tx.status}'),
              Text('Tx: ${tx.txHash}'),
              if (tx.anchoredHash != null)
                Text(
                  'Anchored hash: ${truncateMiddle(tx.anchoredHash!, head: 10, tail: 8)}',
                ),
              if (tx.amountKes != null)
                Text('Amount: ${formatKes(tx.amountKes!)}'),
            ],
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
