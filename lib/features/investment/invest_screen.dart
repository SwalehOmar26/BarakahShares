import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/errors/app_exception.dart';
import '../../core/routing/routes.dart';
import '../../core/utils/finance_calculator.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/phone_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/progress_bar.dart';
import '../../core/widgets/risk_notice.dart';
import '../../core/widgets/states.dart';
import '../../models/business.dart';
import '../../models/enums.dart';
import '../../models/records.dart';
import '../../providers/providers.dart';
import '../../repositories/mock/mock_seed.dart';

enum _PayStage { form, waiting, done }

class InvestScreen extends ConsumerStatefulWidget {
  const InvestScreen({super.key, required this.businessId});

  final String businessId;

  @override
  ConsumerState<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends ConsumerState<InvestScreen> {
  int? _amount;
  _PayStage _stage = _PayStage.form;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final business = ref.watch(businessProvider(widget.businessId));
    return AppScaffold(
      title: 'Invest',
      body: AsyncBody<Business?>(
        value: business,
        onRetry: () => ref.invalidate(businessProvider(widget.businessId)),
        data: (value) {
          if (value == null) {
            return const EmptyState(
              title: 'Campaign unavailable',
              message: 'Return to Discover and choose a business.',
            );
          }
          final amount = _amount ?? value.campaign.sharePriceKes;
          return _InvestForm(
            business: value,
            amount: amount,
            stage: _stage,
            error: _error,
            onAmount: (next) => setState(() => _amount = next),
            onProceed: () => _proceed(value, amount),
          );
        },
      ),
    );
  }

  Future<void> _proceed(Business business, int amount) async {
    final campaign = business.campaign;
    final shares = FinanceCalculator.shareCount(
      investmentKes: amount,
      sharePriceKes: campaign.sharePriceKes,
    );
    if (campaign.status != CampaignStatus.funding) {
      setState(() => _error = 'This campaign is not open.');
      return;
    }
    if (shares < 1 || amount != shares * campaign.sharePriceKes) {
      setState(
        () => _error =
            'Use a whole number of shares at ${formatKes(campaign.sharePriceKes)} each.',
      );
      return;
    }
    if (shares > campaign.availableShares) {
      setState(
        () => _error = 'Only ${campaign.availableShares} shares remain.',
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm investment'),
        content: Text(
          'Confirm ${formatKes(amount)} in ${business.name}? This demonstration uses a simulated M-PESA STK push. No money moves.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _stage = _PayStage.waiting;
      _error = null;
    });
    try {
      final user = ref.read(authControllerProvider).user;
      final payment = await ref
          .read(paymentServiceProvider)
          .requestStkPush(
            phone: user?.phone ?? '',
            amountKes: amount,
            businessId: business.id,
          );
      if (!payment.success) {
        throw const AppException('The demo payment did not complete.');
      }
      final investment = await ref
          .read(portfolioProvider.notifier)
          .invest(
            businessId: business.id,
            amountKes: amount,
            txHash: payment.txHash,
          );
      ref.read(lastContributionProvider.notifier).state = ContributionRecord(
        investmentId: investment.id,
        businessId: business.id,
        businessName: business.name,
        amountKes: amount,
        ownershipPercent: investment.ownershipPercent,
        certificateCode: investment.certificateCode,
        txHash: payment.txHash,
        status: 'Confirmed',
      );
      if (!mounted) return;
      setState(() => _stage = _PayStage.done);
      context.go(AppRoutes.success);
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _stage = _PayStage.form;
        _error = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _stage = _PayStage.form;
        _error = 'The demo payment could not be recorded.';
      });
    }
  }
}

class _InvestForm extends StatelessWidget {
  const _InvestForm({
    required this.business,
    required this.amount,
    required this.stage,
    required this.error,
    required this.onAmount,
    required this.onProceed,
  });

  final Business business;
  final int amount;
  final _PayStage stage;
  final String? error;
  final ValueChanged<int> onAmount;
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    final campaign = business.campaign;
    final shares = FinanceCalculator.shareCount(
      investmentKes: amount,
      sharePriceKes: campaign.sharePriceKes,
    );
    final ownership = FinanceCalculator.ownershipPercent(
      investmentKes: amount,
      fundingTargetKes: campaign.targetKes,
    );
    final maxAmount = campaign.availableShares * campaign.sharePriceKes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invest in ${business.name}',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),
        AmountInput(
          amount: amount,
          step: campaign.sharePriceKes,
          min: campaign.sharePriceKes,
          max: maxAmount,
          onChanged: onAmount,
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _line(context, 'Share price', formatKes(campaign.sharePriceKes)),
              _line(context, 'Number of shares', '$shares'),
              _line(context, 'Estimated ownership', formatPercent(ownership)),
              const SizedBox(height: AppSpacing.sm),
              AppProgressBar(value: campaign.progress),
              const SizedBox(height: AppSpacing.xs),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${campaign.filledShares} / ${campaign.totalShares} shares filled',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your payment is processed through the platform\'s regulated investment/payment flow.',
              ),
              SizedBox(height: AppSpacing.xs),
              Text(AppCopy.demoPayment),
              SizedBox(height: AppSpacing.xs),
              Text('Network: ${ChainDemo.network}'),
              Text('Contract: ${ChainDemo.contractShort}'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const _PaymentMethod(),
        if (stage == _PayStage.waiting) ...[
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: Text('Waiting for STK Push...')),
              ],
            ),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(error!, style: const TextStyle(color: AppColors.error)),
        ],
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          key: const Key('proceed-mpesa'),
          label: 'Proceed to M-PESA',
          busy: stage == _PayStage.waiting,
          onPressed: stage == _PayStage.waiting ? null : onProceed,
        ),
        const SizedBox(height: AppSpacing.md),
        const RiskNotice(),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppCopy.equityNotLoan,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _line(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethod extends ConsumerWidget {
  const _PaymentMethod();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPhone = ref.watch(authControllerProvider).user?.phone;
    final shown = userPhone == null
        ? '+254 7XX XXX XXX'
        : formatKenyaPhone(userPhone);
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment method', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xxs),
          const Text('M-PESA', style: TextStyle(fontWeight: FontWeight.w700)),
          Text('Phone: $shown'),
        ],
      ),
    );
  }
}
