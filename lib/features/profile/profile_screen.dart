import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/phone_utils.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/enums.dart';
import '../../providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final settings = ref.watch(settingsProvider);
    return AppScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.deepGreen,
                child: Icon(Icons.person, color: AppColors.gold, size: 32),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? 'Investor', style: brandStyle(size: 26)),
                    Text(user == null ? '' : formatKenyaPhone(user.phone)),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(user?.role.label ?? ''),
                    const SizedBox(height: AppSpacing.xxs),
                    StatusBadge.kyc(user?.kycStatus ?? KycStatus.notStarted),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _tile(
            context,
            'My Account',
            'Name, phone, and role',
            () => context.push(AppRoutes.kyc),
          ),
          _tile(
            context,
            'My Share Certificates',
            'Open your portfolio',
            () => context.go(AppRoutes.portfolio),
          ),
          _tile(
            context,
            'Security',
            'MFA, biometrics, password',
            () => _security(context, ref),
          ),
          _tile(
            context,
            'Notifications',
            settings.notificationsEnabled ? 'On' : 'Off',
            () => ref
                .read(settingsProvider.notifier)
                .setNotifications(!settings.notificationsEnabled),
          ),
          _tile(
            context,
            'Help & Support',
            'Demo support notes',
            () => context.push(AppRoutes.info('help')),
          ),
          _tile(
            context,
            'Terms',
            null,
            () => context.push(AppRoutes.info('terms')),
          ),
          _tile(
            context,
            'Privacy',
            null,
            () => context.push(AppRoutes.info('privacy')),
          ),
          _tile(
            context,
            'Shariah Compliance',
            null,
            () => context.push(AppRoutes.info('shariah')),
          ),
          _tile(
            context,
            'About BarakahShares',
            null,
            () => context.push(AppRoutes.info('about')),
          ),
          _tile(
            context,
            'Zakat Calculator',
            null,
            () => context.push(AppRoutes.zakat),
          ),
          _tile(
            context,
            'Integrations',
            'Supabase, Smile ID, Daraja, Base',
            () => context.push(AppRoutes.integrations),
          ),
          _tile(
            context,
            'Scan certificate',
            'QR or code',
            () => context.push(AppRoutes.scan),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            onTap: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
            child: const Row(
              children: [
                Icon(Icons.logout, color: AppColors.error),
                SizedBox(width: AppSpacing.sm),
                Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    String title,
    String? subtitle,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Future<void> _security(BuildContext host, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: host,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Consumer(
            builder: (context, ref, _) {
              final current = ref.watch(settingsProvider);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('MFA'),
                    subtitle: const Text('Demo preference only'),
                    value: current.mfaEnabled,
                    onChanged: ref.read(settingsProvider.notifier).setMfa,
                  ),
                  SwitchListTile(
                    title: const Text('Biometric Login'),
                    subtitle: const Text('Not connected to device biometrics'),
                    value: current.biometricEnabled,
                    onChanged: ref.read(settingsProvider.notifier).setBiometric,
                  ),
                  ListTile(
                    title: const Text('Change Password'),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      if (!host.mounted) return;
                      await showDialog<void>(
                        context: host,
                        builder: (context) => AlertDialog(
                          title: const Text('Change Password'),
                          content: const Text(
                            'Password updated for this demo session only. It is not stored as a real credential.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                      ),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                    ],
                    selected: {
                      current.themeMode == ThemeMode.dark
                          ? ThemeMode.dark
                          : ThemeMode.light,
                    },
                    onSelectionChanged: (value) {
                      ref.read(settingsProvider.notifier).setTheme(value.first);
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
