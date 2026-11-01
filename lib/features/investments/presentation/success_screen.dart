import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_config.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/external_link.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/geometric_background.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/providers/providers.dart';

class InvestmentSuccessScreen extends ConsumerWidget {
  const InvestmentSuccessScreen({required this.reference, super.key});

  final String reference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attempt = ref.watch(paymentRepositoryProvider).find(reference);
    final user = ref.watch(authControllerProvider).user;
    final businessName = attempt == null
        ? null
        : ref.watch(campaignProvider(attempt.businessId)).asData?.value.name;
    if (attempt == null || attempt.outcome.name != 'successful') {
      return Scaffold(
        appBar: AppBar(title: const Text('Contribution')),
        body: const EmptyView(
          title: 'No successful payment',
          message: 'This reference is not a completed demonstration payment. A failed or cancelled checkout is not confirmed here.',
        ),
      );
    }
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.forest, AppColors.emerald],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    const SuccessMark(),
                    const SizedBox(height: 18),
                    Text(
                      'Contribution Successful',
                      key: WidgetKeys.successHeading,
                      style: text.headlineMedium?.copyWith(
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The mock M-Pesa result was marked successful. No live payment was taken.',
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.88),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SurfaceCard(
                      child: Column(
                        children: [
                          InfoRow(
                            label: 'Business',
                            value: businessName ?? attempt.businessId,
                          ),
                          InfoRow(
                            label: 'Amount',
                            value: formatKes(attempt.amount),
                          ),
                          InfoRow(label: 'Units', value: '${attempt.shares}'),
                          InfoRow(label: 'Reference', value: attempt.reference),
                          InfoRow(
                            label: 'Holder',
                            value: user?.fullName ?? 'Demonstration holder',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SurfaceCard(
                      child: Column(
                        children: [
                          Text('Certificate preview', style: text.titleMedium),
                          const SizedBox(height: 6),
                          Text(
                            attempt.certificateId ?? '—',
                            style: text.titleLarge?.copyWith(
                              color: AppColors.emerald,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (attempt.certificateId != null)
                            QrImageView(
                              data:
                                  'barakahshares://certificate/${attempt.certificateId}',
                              size: 120,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: AppColors.forest,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: AppColors.emerald,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            AppConstants.disclaimerCertificate,
                            textAlign: TextAlign.center,
                            style: text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppButton(
                      label: 'View My Shares',
                      onPressed: () => context.go(AppRoutes.portfolio),
                    ),
                    if (ApiConfig.hasContract) ...[
                      const SizedBox(height: 10),
                      AppButton(
                        label: 'View contract',
                        variant: AppButtonVariant.secondary,
                        onPressed: () => openExternalLink(
                          context,
                          Uri.parse(
                            '${ApiConfig.baseScanAddressPrefix}${ApiConfig.contractAddress}',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
