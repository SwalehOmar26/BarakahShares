import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/state_views.dart';
import '../../../shared/providers/providers.dart';
import '../domain/zakat_calculator.dart';

class ZakatScreen extends ConsumerStatefulWidget {
  const ZakatScreen({super.key});

  @override
  ConsumerState<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends ConsumerState<ZakatScreen> {
  final _cash = TextEditingController(text: '20000');
  final _gold = TextEditingController(text: '0');
  final _trade = TextEditingController(text: '0');
  final _receivables = TextEditingController(text: '8000');
  final _equity = TextEditingController();
  final _deductions = TextEditingController(text: '6000');
  var _hawl = false;
  var _seededEquity = false;

  @override
  void dispose() {
    _cash.dispose();
    _gold.dispose();
    _trade.dispose();
    _receivables.dispose();
    _equity.dispose();
    _deductions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totals = ref.watch(portfolioTotalsProvider);
    if (!_seededEquity && totals.businesses.isNotEmpty) {
      final seeded = totals.zakatableEquity.round().toString();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _seededEquity) return;
        setState(() {
          _equity.text = seeded;
          _seededEquity = true;
        });
      });
    }
    final input = ZakatInput(
      cashAndBank: _number(_cash),
      goldAndSilver: _number(_gold),
      tradeGoods: _number(_trade),
      receivables: _number(_receivables),
      zakatableEquity: _number(_equity),
      deductions: _number(_deductions),
      hawlCompleted: _hawl,
      nisab: AppConstants.illustrativeNisabKes,
      grossShareValue: totals.invested,
    );
    final result = calculateZakat(input);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Zakat calculator')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const DemoNotice(
            message: 'Educational estimate only. Long-term shares are not automatically charged at 2.5% of their full value, and this is not a fatwa.',
          ),
          const SizedBox(height: 16),
          Text('Zakatable assets', style: text.titleLarge),
          const SizedBox(height: 8),
          _field(_cash, 'Cash and bank balances'),
          _field(_gold, 'Gold and silver (KSh value)'),
          _field(_trade, 'Trade goods you hold personally'),
          _field(_receivables, 'Receivables you expect to collect'),
          _field(_equity, 'Zakatable portion of long-term shares'),
          Text(
            'Full demonstration share value is ${formatKes(totals.invested)}. The field above starts from each business’s illustrative current-asset ratio, not from that full amount.',
            style: text.bodySmall,
          ),
          const SizedBox(height: 12),
          Text('Deductions', style: text.titleLarge),
          _field(_deductions, 'Short-term debts and necessary expenses'),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('A lunar year has passed'),
            subtitle: const Text(
              'Hawl is required before zakat becomes due. Leave this off unless you know the year is complete.',
            ),
            value: _hawl,
            onChanged: (value) => setState(() => _hawl = value),
          ),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoRow(
                  label: 'Zakatable assets',
                  value: formatKes(input.zakatableAssets),
                ),
                InfoRow(
                  label: 'Net after deductions',
                  value: formatKes(input.netZakatable),
                ),
                InfoRow(
                  label: 'Illustrative nisab',
                  value: formatKes(input.nisab),
                ),
                InfoRow(
                  label: 'Nisab status',
                  value: result.meetsNisab ? 'Reached' : 'Not reached',
                ),
                InfoRow(
                  label: 'Hawl',
                  value: _hawl ? 'Marked complete' : 'Not confirmed',
                ),
                const Divider(),
                Text('Estimated zakat', style: text.bodySmall),
                Text(
                  formatKes(result.zakatDue, decimals: true),
                  style: text.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(result.explanation, style: text.bodyMedium),
          const SizedBox(height: 12),
          AppButton(
            label: 'Load an example above nisab',
            variant: AppButtonVariant.secondary,
            onPressed: () {
              setState(() {
                _cash.text = '100000';
                _hawl = true;
              });
            },
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Donate to Waqf',
            variant: AppButtonVariant.text,
            onPressed: () => showInfoDialog(
              context,
              title: 'Waqf donation',
              message: 'Waqf donations are not processed in this build. No payment will be taken.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  double _number(TextEditingController controller) =>
      double.tryParse(controller.text.trim()) ?? 0;
}
