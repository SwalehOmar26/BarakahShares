import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_copy.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/risk_notice.dart';
import '../../providers/providers.dart';

class ZakatScreen extends ConsumerStatefulWidget {
  const ZakatScreen({super.key});

  @override
  ConsumerState<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends ConsumerState<ZakatScreen> {
  int? _eligible;
  int? _result;

  @override
  Widget build(BuildContext context) {
    final estimate = ref.watch(zakatEstimateProvider);
    final eligible = _eligible ?? estimate.eligibleAssetsKes;
    final zakat = _result ?? estimate.zakatKes;
    return AppScaffold(
      title: 'Zakat Calculator',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Zakat Calculator', style: brandStyle(size: 32)),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _row(
                  context,
                  'Portfolio value',
                  formatKes(estimate.portfolioValueKes),
                ),
                _row(context, 'Eligible assets', formatKes(eligible)),
                _row(context, 'Zakat rate', '2.5%'),
                _row(context, 'Estimated Zakat', formatKes(zakat)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(AppCopy.zakatDisclaimer),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Calculate',
            onPressed: () {
              final next = ref
                  .read(zakatServiceProvider)
                  .estimate(
                    portfolioValueKes: estimate.portfolioValueKes,
                    eligibleAssetsKes: eligible,
                  );
              setState(() => _result = next.zakatKes);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: 'Donate to Waqf',
            onPressed: () => _donate(context, zakat),
          ),
          const SizedBox(height: AppSpacing.md),
          const RiskNotice(
            text: 'This calculator is informational. It is not a zakat ruling, and donating here does not transfer funds.',
          ),
        ],
      ),
    );
  }

  Future<void> _donate(BuildContext context, int zakat) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Donate to Waqf'),
        content: Text(
          'A waqf contribution of ${formatKes(zakat)} is not sent in this demo. No payment provider is contacted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
