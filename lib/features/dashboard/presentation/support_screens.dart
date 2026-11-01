import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_config.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/providers/providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(notificationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return SurfaceCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.title),
              subtitle: Text('${item.body}\n${formatDate(item.date)}'),
              isThreeLine: true,
              trailing: Icon(
                item.read
                    ? Icons.drafts_outlined
                    : Icons.mark_email_unread_outlined,
              ),
              onTap: () {
                ref.read(notificationProvider.notifier).markRead(item.id);
                final businessId = item.businessId;
                if (businessId != null) {
                  context.push(AppRoutes.business(businessId));
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class DocumentScreen extends ConsumerWidget {
  const DocumentScreen({required this.documentId, super.key});

  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(readableDocumentProvider(documentId));
    return Scaffold(
      appBar: AppBar(title: const Text('Document')),
      body: document.when(
        loading: () => const LoadingView(label: 'Opening document'),
        error: (error, _) => ErrorView(message: error.toString()),
        data: (item) {
          if (item == null) {
            return const EmptyView(
              title: 'Document unavailable',
              message: 'This sample file could not be found.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(item.status, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              SurfaceCard(child: Text(item.body)),
              const SizedBox(height: 12),
              const DemoNotice(
                message: 'This file is illustrative and is not a verified registry extract.',
              ),
              if (item.liveTransactionHash != null) ...[
                const SizedBox(height: 12),
                AppButton(
                  label: 'View on BaseScan',
                  onPressed: () => openExternalLink(
                    context,
                    Uri.parse(
                      '${ApiConfig.baseScanTxPrefix}${item.liveTransactionHash}',
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
