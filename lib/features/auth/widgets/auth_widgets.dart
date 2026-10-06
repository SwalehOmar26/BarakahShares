import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../models/enums.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({super.key, required this.value, required this.onChanged});

  final UserRole value;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Account role',
      child: SegmentedButton<UserRole>(
        segments: const [
          ButtonSegment(
            value: UserRole.youthInvestor,
            label: Text('Youth Investor'),
          ),
          ButtonSegment(
            value: UserRole.businessOwner,
            label: Text('Business Owner'),
          ),
        ],
        selected: {value},
        onSelectionChanged: (selection) => onChanged(selection.first),
      ),
    );
  }
}

class TrustRow extends StatelessWidget {
  const TrustRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _TrustItem(icon: Icons.lock_outline, label: 'Secure account'),
        ),
        Expanded(
          child: _TrustItem(icon: Icons.badge_outlined, label: 'KYC verified'),
        ),
        Expanded(
          child: _TrustItem(
            icon: Icons.verified_outlined,
            label: 'Shariah compliant businesses',
          ),
        ),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
