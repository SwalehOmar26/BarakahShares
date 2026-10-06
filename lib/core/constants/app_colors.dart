import 'package:flutter/material.dart';

/// BarakahShares palette, refined from the original forest green and gold.
///
/// The hues stay the same. Depth comes from quieter saturation, cooler
/// neutrals, and a small shift of the green toward a jewel emerald.
abstract final class AppColors {
  /// Original primary was #0B3D2E. This is the same green, slightly deeper
  /// and cooler, so it reads as emerald rather than a bright brand fill.
  static const deepGreen = Color(0xFF0C3832);
  static const deepGreenDark = Color(0xFF071E1C);
  static const greenMid = Color(0xFF1A4E48);
  static const greenSoft = Color(0xFFE6EFEC);

  /// Original accent was #C8A951. [gold] is the control color; [goldOnDark]
  /// is the lighter step used for text on the deep green.
  static const gold = Color(0xFFC1A15A);
  static const goldDeep = Color(0xFF8F7640);
  static const goldOnDark = Color(0xFFE6D3A2);
  static const goldMuted = Color(0xFFEFE6D2);

  static const offWhite = Color(0xFFF4F6F5);
  static const ivory = Color(0xFFE8EEEC);
  static const ink = Color(0xFF1A2426);
  static const inkMuted = Color(0xFF5C696C);
  static const line = Color(0xFFD9E0DC);
  static const card = Color(0xFFFFFFFF);

  static const success = Color(0xFF1C6E48);
  static const successSoft = Color(0xFFE4F1EA);
  static const warning = Color(0xFF7D6324);
  static const warningSoft = Color(0xFFF6F0DE);
  static const error = Color(0xFF9B3A32);
  static const errorSoft = Color(0xFFF8ECEA);
  static const info = Color(0xFF1E4A6B);
  static const infoSoft = Color(0xFFE7EEF3);

  static const darkBackground = Color(0xFF070E12);
  static const darkSurface = Color(0xFF10181C);
  static const darkCard = Color(0xFF162126);
  static const darkLine = Color(0xFF2C3C42);
  static const darkInk = Color(0xFFF2F4F3);
  static const darkMuted = Color(0xFFA9B6B4);

  /// Close shades of the primary only. Used on the splash and the portfolio hero.
  static const jewelDepth = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepGreenDark, deepGreen],
  );
}
