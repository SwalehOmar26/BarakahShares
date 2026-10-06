import 'package:flutter/material.dart';

import '../../core/constants/app_env.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/status_badge.dart';

class IntegrationsScreen extends StatelessWidget {
  const IntegrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      (
        'Supabase',
        AppEnv.hasSupabase,
        'Accounts, campaigns, and fingerprint rows. Off until USE_SUPABASE plus the URL and anon key.',
      ),
      (
        'Smile ID',
        AppEnv.smileReady,
        'KYC stays on the demo path. This build does not upload an ID or selfie.',
      ),
      (
        'Daraja',
        AppEnv.darajaReady,
        'M-PESA STK is simulated. A sandbox call is used only when every Daraja value and DARAJA_ENABLED are set.',
      ),
      (
        'Base',
        AppEnv.baseReady,
        'Read-only RPC. The app has no signing key, so it cannot broadcast a transaction.',
      ),
    ];

    return AppScaffold(
      title: 'Integrations',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live providers are off in this demo. Decisions in the review console and payments on this phone stay local.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final row in rows) ...[
            AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          row.$1,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      StatusBadge(
                        label: row.$2 ? 'Configured' : 'Not configured',
                        tone: row.$2 ? BadgeTone.success : BadgeTone.neutral,
                        icon: row.$2 ? Icons.check : Icons.remove,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(row.$3),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
