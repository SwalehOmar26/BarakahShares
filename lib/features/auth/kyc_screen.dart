import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/enums.dart';
import '../../models/kyc_status.dart';
import '../../providers/providers.dart';

class KycScreen extends ConsumerWidget {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(kycControllerProvider);
    return AppScaffold(
      title: 'Verify Your Identity',
      body: AsyncBody<KycRecord>(
        value: record,
        onRetry: () => ref.invalidate(kycControllerProvider),
        data: (data) => _KycBody(record: data),
      ),
    );
  }
}

class _KycBody extends ConsumerWidget {
  const _KycBody({required this.record});

  final KycRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(kycControllerProvider).isLoading;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your identity must be verified before investing.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        const AppCard(
          color: AppColors.goldMuted,
          child: Row(
            children: [
              Icon(Icons.science_outlined, color: AppColors.deepGreen),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(AppCopy.demoKyc)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        StatusBadge.kyc(record.status),
        const SizedBox(height: AppSpacing.lg),
        _StepTile(
          index: '1',
          title: 'ID Document',
          done: record.idUploaded,
          detail: record.idUploaded
              ? 'ID marked as uploaded'
              : 'Upload a national ID or passport',
        ),
        _StepTile(
          index: '2',
          title: 'Selfie / Liveness',
          done: record.selfieCaptured,
          detail: record.selfieCaptured
              ? 'Selfie marked as captured'
              : 'Take a selfie on this device',
        ),
        _StepTile(
          index: '3',
          title: 'Verification',
          done: record.status == KycStatus.verified,
          detail: record.status == KycStatus.verified
              ? 'Demo status: Verified'
              : 'Status stays pending until both steps are marked',
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: 'Upload ID',
          busy: busy,
          onPressed: record.status == KycStatus.verified
              ? null
              : () => ref.read(kycControllerProvider.notifier).uploadId(),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Take Selfie',
          onPressed: record.status == KycStatus.verified
              ? null
              : () => ref.read(kycControllerProvider.notifier).captureSelfie(),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Start Verification',
          onPressed: record.status == KycStatus.verified
              ? null
              : () => ref
                    .read(kycControllerProvider.notifier)
                    .startVerification(),
        ),
        const SizedBox(height: AppSpacing.md),
        if (record.status == KycStatus.verified)
          PrimaryButton(
            label: 'Continue',
            onPressed: () => context.go(AppRoutes.home),
          )
        else
          Text(
            'Provider label: ${record.providerLabel}. Future implementation: Smile ID.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.title,
    required this.detail,
    required this.done,
  });

  final String index;
  final String title;
  final String detail;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: done ? AppColors.greenSoft : AppColors.ivory,
              foregroundColor: AppColors.deepGreen,
              child: Text(done ? '✓' : index),
            ),
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
                  Text(detail, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
