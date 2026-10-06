import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/async_body.dart';
import '../../../core/widgets/document_card.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../models/receipt.dart';
import '../../../providers/providers.dart';

class BusinessDocuments extends ConsumerWidget {
  const BusinessDocuments({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentsProvider(businessId));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Verification & Evidence'),
        Text(
          'These files stay private. A public chain stores only a fingerprint, not the document.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        AsyncBody<List<BusinessDocument>>(
          value: documents,
          onRetry: () => ref.invalidate(documentsProvider(businessId)),
          data: (items) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final document in items) ...[
                DocumentCard(
                  title: document.title,
                  status: document.status,
                  subtitle: 'Issued ${document.issuedOn.year}',
                  onView: () => showPrivateDocument(
                    context,
                    title: document.title,
                    sha256: document.sha256,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
