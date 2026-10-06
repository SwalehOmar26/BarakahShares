import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/investment.dart';
import '../../models/share_certificate.dart';
import '../../providers/providers.dart';

class HoldingScreen extends ConsumerWidget {
  const HoldingScreen({super.key, required this.investmentId});

  final String investmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certificate = ref.watch(certificateProvider(investmentId));
    final portfolio = ref.watch(portfolioProvider);
    return AppScaffold(
      title: 'Share Certificate',
      body: AsyncBody<ShareCertificate?>(
        value: certificate,
        onRetry: () => ref.invalidate(certificateProvider(investmentId)),
        data: (value) {
          if (value == null) {
            return const Text('Certificate not found.');
          }
          final investments = portfolio.asData?.value.investments ?? const [];
          Investment? investment;
          for (final item in investments) {
            if (item.id == investmentId) {
              investment = item;
              break;
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (investment != null) ...[
                Text(investment.businessName, style: brandStyle(size: 28)),
                const SizedBox(height: AppSpacing.xs),
                Text('Investment ${formatKes(investment.amountKes)}'),
                Text('Ownership ${formatPercent(investment.ownershipPercent)}'),
                Text('Status ${investment.status}'),
                const SizedBox(height: AppSpacing.md),
              ],
              _CertificateCard(certificate: value),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'View Profit',
                onPressed: () =>
                    context.push(AppRoutes.profit(value.businessId)),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'View Receipts',
                onPressed: () =>
                    context.push(AppRoutes.receipts(value.businessId)),
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: 'View Blockchain Record',
                onPressed: () =>
                    context.push(AppRoutes.chain(value.businessId)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.certificate});

  final ShareCertificate certificate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.jewelDepth,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.goldOnDark, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'BARAKAHSHARES',
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: AppColors.goldOnDark, letterSpacing: 1.6),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Equity certificate',
            style: brandStyle(size: 22, color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: QrImageView(
              data: certificate.qrPayload,
              size: 140,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.deepGreen,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.deepGreen,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            certificate.code,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _line('Owner', certificate.investorName),
          _line('Business', certificate.businessName),
          _line('Investment', formatKes(certificate.investmentKes)),
          _line('Ownership', formatPercent(certificate.ownershipPercent)),
          _line('Issued', formatDate(certificate.issuedAt)),
          const SizedBox(height: AppSpacing.sm),
          const StatusBadge(
            label: 'Verified',
            tone: BadgeTone.gold,
            icon: Icons.check,
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.goldOnDark),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
