import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/verification_badge.dart';
import '../../../shared/models/kyc_state.dart';
import '../../../shared/providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final kyc = ref.watch(kycControllerProvider);
    if (user == null) {
      return const Scaffold(body: LoadingView(label: 'Loading profile'));
    }
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          SurfaceCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.emerald,
                  child: Text(
                    user.initials,
                    style: text.titleLarge?.copyWith(color: AppColors.gold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName, style: text.titleLarge),
                      Text(displayPhone(user.phone), style: text.bodySmall),
                      const SizedBox(height: 6),
                      VerificationBadge(
                        label: kyc.overallLabel,
                        tone: switch (kyc.overall) {
                          KycStepStatus.pending => BadgeTone.pending,
                          KycStepStatus.verified => BadgeTone.verified,
                          KycStepStatus.rejected => BadgeTone.rejected,
                          KycStepStatus.notStarted => BadgeTone.neutral,
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Current identity status: ${kyc.overallLabel}. ${kyc.note}',
            style: text.bodySmall,
          ),
          const SizedBox(height: 8),
          _tile(
            context,
            Icons.verified_user_outlined,
            'Identity verification',
            AppRoutes.kyc,
          ),
          _tile(
            context,
            Icons.workspace_premium_outlined,
            'My share certificates',
            AppRoutes.certificates,
          ),
          _tile(
            context,
            Icons.receipt_long_outlined,
            'Investment history',
            AppRoutes.history,
          ),
          _tile(
            context,
            Icons.calculate_outlined,
            'Zakat calculator',
            AppRoutes.zakat,
          ),
          _tile(
            context,
            Icons.hub_outlined,
            'Blockchain records',
            AppRoutes.blockchain,
          ),
          _tile(
            context,
            Icons.qr_code_scanner,
            'Scan a certificate',
            AppRoutes.scan,
          ),
          _tile(
            context,
            Icons.settings_outlined,
            'Settings',
            AppRoutes.settings,
          ),
          _tile(
            context,
            Icons.help_outline,
            'Help and support',
            AppRoutes.help,
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: const Text(
              'Log out',
              style: TextStyle(color: AppColors.danger),
            ),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Log out'),
                  content: const Text(
                    'You will leave the demonstration session on this device.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Stay'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await ref.read(authControllerProvider.notifier).logout();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.emerald),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(route),
    );
  }
}
