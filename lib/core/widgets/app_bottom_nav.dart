import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.explore_outlined, Icons.explore, 'Discover'),
    (Icons.pie_chart_outline, Icons.pie_chart, 'Portfolio'),
    (Icons.receipt_long_outlined, Icons.receipt_long, 'Activity'),
    (Icons.person_outline, Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      height: 68,
      backgroundColor: isLight ? AppColors.card : AppColors.darkSurface,
      indicatorColor: isLight
          ? AppColors.greenSoft
          : AppColors.greenMid.withValues(alpha: 0.55),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        for (final item in _items)
          NavigationDestination(
            icon: Icon(item.$1),
            selectedIcon: Icon(
              item.$2,
              color: isLight ? AppColors.deepGreen : AppColors.goldOnDark,
            ),
            label: item.$3,
          ),
      ],
    );
  }
}
