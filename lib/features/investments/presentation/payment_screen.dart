import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/models/records.dart';
import '../../../shared/providers/providers.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({
    required this.businessId,
    required this.amount,
    required this.phone,
    super.key,
  });

  final String businessId;
  final double amount;
  final String phone;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentOutcome _outcome = PaymentOutcome.pending;
  var _busy = false;
  String? _reference;

  Future<void> _finish(PaymentOutcome outcome) async {
    setState(() => _busy = true);
    final attempt = await ref
        .read(paymentRepositoryProvider)
        .complete(
          outcome: outcome,
          businessId: widget.businessId,
          amount: widget.amount,
          phone: widget.phone,
        );
    if (!mounted) return;
    if (attempt.outcome == PaymentOutcome.successful) {
      ref.invalidate(portfolioProvider);
      ref.invalidate(transactionsProvider);
      context.go(AppRoutes.success(attempt.reference));
      return;
    }
    setState(() {
      _busy = false;
      _outcome = attempt.outcome;
      _reference = attempt.reference;
    });
  }

  @override
  Widget build(BuildContext context) {
    final business = ref.watch(campaignProvider(widget.businessId));
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('M-Pesa checkout')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DemoNotice(
                    message: 'Simulated M-Pesa prompt. No STK push is sent and no money moves.',
                  ),
                  const SizedBox(height: 16),
                  SurfaceCard(
                    child: Column(
                      children: [
                        InfoRow(
                          label: 'Business',
                          value:
                              business.asData?.value.name ?? widget.businessId,
                        ),
                        InfoRow(
                          label: 'Amount',
                          value: formatKes(widget.amount),
                        ),
                        InfoRow(
                          label: 'Phone',
                          value: displayPhone(widget.phone),
                        ),
                        InfoRow(label: 'Status', value: _label(_outcome)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_outcome == PaymentOutcome.pending) ...[
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Payment pending',
                      key: const Key('payment-pending'),
                      style: text.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choose an explicit demonstration result. Success is not assumed.',
                      style: text.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      key: WidgetKeys.paySuccess,
                      label: 'Simulate successful payment',
                      busy: _busy,
                      onPressed: () => _finish(PaymentOutcome.successful),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      key: WidgetKeys.payFail,
                      label: 'Simulate failed payment',
                      variant: AppButtonVariant.secondary,
                      onPressed: _busy
                          ? null
                          : () => _finish(PaymentOutcome.failed),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      key: WidgetKeys.payCancel,
                      label: 'Cancel payment',
                      variant: AppButtonVariant.text,
                      onPressed: _busy
                          ? null
                          : () => _finish(PaymentOutcome.cancelled),
                    ),
                  ],
                  if (_outcome == PaymentOutcome.failed) ...[
                    Text(
                      'Payment failed',
                      style: text.headlineSmall?.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reference ${_reference ?? '—'} was not completed. No contribution was recorded.',
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      key: WidgetKeys.payBack,
                      label: 'Try again',
                      onPressed: () => setState(() {
                        _outcome = PaymentOutcome.pending;
                        _reference = null;
                      }),
                    ),
                  ],
                  if (_outcome == PaymentOutcome.cancelled) ...[
                    Text('Payment cancelled', style: text.headlineSmall),
                    const SizedBox(height: 8),
                    const Text(
                      'The demonstration checkout was cancelled. No contribution was recorded.',
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      key: WidgetKeys.payBack,
                      label: 'Back to investment',
                      onPressed: () => context.pop(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _label(PaymentOutcome outcome) => switch (outcome) {
    PaymentOutcome.pending => 'Pending',
    PaymentOutcome.successful => 'Successful',
    PaymentOutcome.failed => 'Failed',
    PaymentOutcome.cancelled => 'Cancelled',
  };
}
