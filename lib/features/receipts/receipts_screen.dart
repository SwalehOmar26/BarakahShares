import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/document_card.dart';
import '../../core/widgets/states.dart';
import '../../models/receipt.dart';
import '../../providers/providers.dart';

class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipts = ref.watch(receiptsProvider(businessId));
    return AppScaffold(
      title: 'Business Evidence',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review approved business expenses and supporting evidence.',
            style: brandStyle(size: 22),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Receipt images stay private. Verification compares the fingerprint with the demo ledger only.',
          ),
          const SizedBox(height: AppSpacing.md),
          AsyncBody<List<Receipt>>(
            value: receipts,
            onRetry: () => ref.invalidate(receiptsProvider(businessId)),
            data: (items) {
              if (items.isEmpty) {
                return const EmptyState(
                  title: 'No evidence filed',
                  message: 'Approved expenses will appear here once the business submits them.',
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final receipt in items) ...[
                    ProofCard(
                      title: receipt.title,
                      amountKes: receipt.amountKes,
                      date: receipt.date,
                      category: receipt.category,
                      status: receipt.status,
                      ipfsCid: receipt.ipfsCid,
                      sha256: receipt.sha256,
                      onVerify: () => _verify(context, ref, receipt),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _verify(
    BuildContext context,
    WidgetRef ref,
    Receipt receipt,
  ) async {
    final result = await ref
        .read(documentVerificationProvider)
        .verifyReceipt(receiptId: receipt.id, sha256: receipt.sha256);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Evidence'),
        content: Text(
          '${result.message}\n\nStatus: ${result.status.name == 'verified' ? 'Verified' : 'Failed'}\n\nMock verification only.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
