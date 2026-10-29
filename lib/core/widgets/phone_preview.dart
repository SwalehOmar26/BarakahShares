import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Centers a phone-width column when the window is a desktop browser.
class PhonePreview extends StatelessWidget {
  const PhonePreview({required this.child, super.key});

  final Widget child;

  static const frameWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final framed =
            constraints.maxWidth >= 560 && constraints.maxHeight >= 700;
        if (!framed) return child;
        final height = constraints.maxHeight.clamp(0.0, 860.0);
        return ColoredBox(
          color: const Color(0xFF071510),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: SizedBox(
                width: frameWidth,
                height: height,
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(size: Size(frameWidth, height)),
                  child: ColoredBox(color: AppColors.cream, child: child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
