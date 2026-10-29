import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/verification_badge.dart';
import '../../../shared/providers/providers.dart';

class BlockchainScreen extends ConsumerWidget {
  const BlockchainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(chainEventsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Blockchain records')),
      body: events.when(
        loading: () => const LoadingView(label: 'Loading records'),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(chainEventsProvider),
        ),
        data: (items) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            SurfaceCard(
              child: Column(
                children: [
                  const InfoRow(label: 'Network', value: ApiConfig.chainName),
                  InfoRow(
                    label: 'Contract',
                    value: ApiConfig.hasContract
                        ? ApiConfig.contractAddress
                        : 'Not configured',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const DemoNotice(
              message: 'Mock records are not on-chain. A BaseScan link appears only when a real transaction hash exists.',
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const EmptyView(
                title: 'No records',
                message: 'Contribution, ownership, and document events will appear here.',
              )
            else
              for (final event in items) ...[
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          VerificationBadge(
                            label: event.isLive ? 'Live' : 'Mock record',
                            tone: event.isLive
                                ? BadgeTone.verified
                                : BadgeTone.pending,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      InfoRow(label: 'Type', value: event.typeLabel),
                      InfoRow(label: 'Date', value: formatDate(event.date)),
                      InfoRow(label: 'Status', value: event.status),
                      const SizedBox(height: 8),
                      Text(event.detail),
                      if (event.canOpenExplorer) ...[
                        const SizedBox(height: 12),
                        Text(
                          event.transactionHash!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        AppButton(
                          label: 'View on BaseScan',
                          variant: AppButtonVariant.secondary,
                          onPressed: () => openExternalLink(
                            context,
                            Uri.parse(
                              '${ApiConfig.baseScanTxPrefix}${event.transactionHash}',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            if (ApiConfig.hasContract)
              AppButton(
                label: 'View contract on BaseScan',
                onPressed: () => openExternalLink(
                  context,
                  Uri.parse(
                    '${ApiConfig.baseScanAddressPrefix}${ApiConfig.contractAddress}',
                  ),
                ),
              )
            else
              Text(
                'No contract address is configured, so this screen does not open BaseScan.',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.muted),
              ),
          ],
        ),
      ),
    );
  }
}
