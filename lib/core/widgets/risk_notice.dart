import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_copy.dart';
import '../constants/app_spacing.dart';

class RiskNotice extends StatelessWidget {
  const RiskNotice({super.key, this.text = AppCopy.riskNotice});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isLight ? AppColors.ivory : AppColors.darkSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
        border: Border.all(
          color: isLight ? AppColors.line : AppColors.darkLine,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.gold),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
