import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/providers/providers.dart';

class InvestScreen extends ConsumerStatefulWidget {
  const InvestScreen({required this.businessId, super.key});

  final String businessId;

  @override
  ConsumerState<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends ConsumerState<InvestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _phone = TextEditingController();
  var _accepted = false;
  var _submitted = false;

  @override
  void initState() {
    super.initState();
    final phone = ref.read(authControllerProvider).user?.phone ?? '';
    _phone.text = phone;
  }

  @override
  void dispose() {
    _amount.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaign = ref.watch(campaignProvider(widget.businessId));
    return Scaffold(
      appBar: AppBar(title: const Text('Invest')),
      body: campaign.when(
        loading: () => const LoadingView(label: 'Loading investment terms'),
        error: (error, _) => ErrorView(message: error.toString()),
        data: (business) {
          final units = _units(business.pricePerShare);
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          business.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          business.location,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        const DemoNotice(
                          message: 'This form prepares a demonstration contribution. It does not send an M-Pesa request.',
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _amount,
                          label: 'Investment amount',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) => Validators.investmentAmount(
                            value,
                            minimum: business.minInvestment,
                            remaining: business.remainingFunding,
                            unitPrice: business.pricePerShare,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final preset in const [
                              5000,
                              10000,
                              20000,
                              50000,
                            ])
                              ChoiceChip(
                                key: preset == 5000
                                    ? WidgetKeys.amount5000
                                    : ValueKey('amount-$preset'),
                                label: Text(formatKes(preset)),
                                selected: _amount.text == '$preset',
                                onSelected: (_) =>
                                    setState(() => _amount.text = '$preset'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _phone,
                          label: 'M-Pesa phone number',
                          keyboardType: TextInputType.phone,
                          validator: Validators.phone,
                        ),
                        const SizedBox(height: 12),
                        SurfaceCard(
                          child: InfoRow(
                            label: 'Estimated ownership units',
                            value: units == null
                                ? '—'
                                : '$units illustrative units',
                          ),
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          key: WidgetKeys.investTerms,
                          contentPadding: EdgeInsets.zero,
                          value: _accepted,
                          onChanged: (value) =>
                              setState(() => _accepted = value ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text(
                            'I understand returns are variable and not guaranteed, and that this demonstration does not take a live M-Pesa payment.',
                          ),
                        ),
                        if (_submitted && !_accepted)
                          const Text(
                            'Acknowledge the investment terms to continue.',
                            style: TextStyle(color: AppColors.danger),
                          ),
                        const SizedBox(height: 12),
                        AppButton(
                          key: WidgetKeys.investSubmit,
                          label: 'Proceed to Pay via M-Pesa',
                          onPressed: business.canInvest
                              ? () {
                                  setState(() => _submitted = true);
                                  final valid = _formKey.currentState!
                                      .validate();
                                  if (!valid || !_accepted) return;
                                  final amount = double.parse(_amount.text);
                                  context.push(
                                    AppRoutes.pay(
                                      business.id,
                                      amount: amount,
                                      phone: normalizePhone(_phone.text),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int? _units(double price) {
    final amount = double.tryParse(_amount.text);
    if (amount == null || price == 0) return null;
    return (amount / price).round();
  }
}
