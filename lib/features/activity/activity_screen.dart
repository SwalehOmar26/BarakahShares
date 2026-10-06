import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/async_body.dart';
import '../../core/widgets/investment_card.dart';
import '../../core/widgets/states.dart';
import '../../models/records.dart';
import '../../providers/providers.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activitiesProvider);
    return AppScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text('Activity', style: brandStyle(size: 32)),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Investments, distributions, and certificates recorded in this demo.',
          ),
          const SizedBox(height: AppSpacing.md),
          AsyncBody<List<ActivityItem>>(
            value: activity,
            onRetry: () => ref.invalidate(activitiesProvider),
            data: (items) {
              if (items.isEmpty) {
                return const EmptyState(
                  title: 'No activity yet',
                  message: 'A completed investment will show up here.',
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final item in items) ...[
                    TransactionCard(
                      title: item.title,
                      subtitle: '${item.subtitle}\n${formatDate(item.date)}',
                      trailing: '',
                      onTap: () =>
                          context.push(AppRoutes.business(item.businessId)),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
