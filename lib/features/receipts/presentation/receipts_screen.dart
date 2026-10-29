import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_config.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/verification_badge.dart';
import '../../../shared/models/records.dart';
import '../../../shared/providers/providers.dart';

class ReceiptsScreen extends ConsumerStatefulWidget {
  const ReceiptsScreen({required this.businessId, super.key});

  final String businessId;

  @override
  ConsumerState<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends ConsumerState<ReceiptsScreen> {
  RecordKind _kind = RecordKind.expense;

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(recordsProvider(widget.businessId));
    final business = ref
        .watch(campaignProvider(widget.businessId))
        .asData
        ?.value;
    return Scaffold(
      appBar: AppBar(title: Text(business?.name ?? 'Receipts')),
      body: records.when(
        loading: () => const LoadingView(label: 'Loading records'),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(recordsProvider(widget.businessId)),
        ),
        data: (items) {
          final visible = items.where((item) => item.kind == _kind).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              const DemoNotice(
                message: 'These receipts are sample evidence. They are not audited accounts.',
              ),
              const SizedBox(height: 12),
              SegmentedButton<RecordKind>(
                segments: const [
                  ButtonSegment(
                    value: RecordKind.expense,
                    label: Text('Expenses'),
                  ),
                  ButtonSegment(
                    value: RecordKind.income,
                    label: Text('Income'),
                  ),
                ],
                selected: {_kind},
                onSelectionChanged: (value) =>
                    setState(() => _kind = value.first),
              ),
              const SizedBox(height: 12),
              if (visible.isEmpty)
                const EmptyView(
                  title: 'Nothing in this tab',
                  message: 'Try the other record type.',
                )
              else
                for (final record in visible) ...[
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                record.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            VerificationBadge(
                              label: record.verificationStatus,
                              tone: BadgeTone.pending,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        InfoRow(label: 'Date', value: formatDate(record.date)),
                        InfoRow(
                          label: 'Amount',
                          value: formatKes(record.amount),
                        ),
                        InfoRow(
                          label: 'Document type',
                          value: record.documentType,
                        ),
                        const SizedBox(height: 8),
                        AppButton(
                          label: 'View document',
                          onPressed: () =>
                              context.push(AppRoutes.document(record.id)),
                        ),
                        if (record.hasLiveChainReference) ...[
                          const SizedBox(height: 8),
                          AppButton(
                            label: 'View on BaseScan',
                            variant: AppButtonVariant.secondary,
                            onPressed: () => openExternalLink(
                              context,
                              Uri.parse(
                                '${ApiConfig.baseScanTxPrefix}${record.liveTransactionHash}',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          );
        },
      ),
    );
  }
}
