import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/enums.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.title,
    required this.status,
    required this.onView,
    this.subtitle,
  });

  final String title;
  final VerificationStatus status;
  final VoidCallback onView;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: AppColors.deepGreen),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (subtitle != null)
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.xxs),
                const Text('Private document'),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge.verification(status),
              TextButton(onPressed: onView, child: const Text('View Document')),
            ],
          ),
        ],
      ),
    );
  }
}

class ProofCard extends StatelessWidget {
  const ProofCard({
    super.key,
    required this.title,
    required this.amountKes,
    required this.date,
    required this.category,
    required this.status,
    required this.ipfsCid,
    required this.sha256,
    required this.onVerify,
  });

  final String title;
  final int amountKes;
  final DateTime date;
  final String category;
  final VerificationStatus status;
  final String ipfsCid;
  final String sha256;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkMuted
        : AppColors.darkMuted;
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              StatusBadge.verification(status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            formatKes(amountKes),
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            '$category · ${formatDate(date)}',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: muted),
          ),
          const SizedBox(height: AppSpacing.sm),
          _line(context, 'IPFS CID', truncateMiddle(ipfsCid, head: 8, tail: 6)),
          _line(context, 'SHA-256', truncateMiddle(sha256, head: 8, tail: 6)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppCopy.privateDocument,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: muted),
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(label: 'Verify Evidence', onPressed: onVerify),
        ],
      ),
    );
  }

  Widget _line(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

void showPrivateDocument(
  BuildContext context, {
  required String title,
  required String sha256,
}) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            const StatusBadge(
              label: 'Private document',
              tone: BadgeTone.info,
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppCopy.privateDocument,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Preview withheld.\nNational ID, KRA PIN, and statement lines are not shown in this demo and are never written to a public chain.',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Fingerprint ${truncateMiddle(sha256, head: 10, tail: 8)}'),
          ],
        ),
      );
    },
  );
}
