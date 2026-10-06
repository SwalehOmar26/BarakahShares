import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

TextTheme _textTheme(TextTheme base, Color ink) {
  if (!GoogleFonts.config.allowRuntimeFetching) {
    return base.apply(bodyColor: ink, displayColor: ink);
  }
  return GoogleFonts.manropeTextTheme(base)
      .apply(bodyColor: ink, displayColor: ink);
}

TextStyle brandStyle({
  required double size,
  Color? color,
  FontWeight weight = FontWeight.w600,
}) {
  if (!GoogleFonts.config.allowRuntimeFetching) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.12,
    );
  }
  return GoogleFonts.fraunces(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.12,
  );
}

abstract final class AppTheme {
  static ThemeData light() {
    const ink = AppColors.ink;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.deepGreen,
      brightness: Brightness.light,
      primary: AppColors.deepGreen,
      onPrimary: Colors.white,
      primaryContainer: AppColors.greenSoft,
      onPrimaryContainer: AppColors.deepGreen,
      secondary: AppColors.gold,
      onSecondary: AppColors.deepGreenDark,
      secondaryContainer: AppColors.goldMuted,
      onSecondaryContainer: AppColors.ink,
      surface: AppColors.card,
      onSurface: AppColors.ink,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.line,
      surfaceTint: Colors.transparent,
    );
    return _base(scheme, AppColors.offWhite, ink, Brightness.light);
  }

  static ThemeData dark() {
    const ink = AppColors.darkInk;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.deepGreen,
      brightness: Brightness.dark,
      primary: AppColors.gold,
      onPrimary: AppColors.deepGreenDark,
      primaryContainer: AppColors.greenMid,
      onPrimaryContainer: AppColors.goldOnDark,
      secondary: AppColors.gold,
      onSecondary: AppColors.deepGreenDark,
      secondaryContainer: AppColors.darkCard,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkInk,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.darkLine,
      surfaceTint: Colors.transparent,
    );
    return _base(scheme, AppColors.darkBackground, ink, Brightness.dark);
  }

  static ThemeData _base(
    ColorScheme scheme,
    Color scaffold,
    Color ink,
    Brightness brightness,
  ) {
    final text = _textTheme(ThemeData(brightness: brightness).textTheme, ink);
    final isLight = brightness == Brightness.light;
    final buttonBg = isLight ? AppColors.deepGreen : AppColors.gold;
    final buttonFg = isLight ? Colors.white : AppColors.deepGreen;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      textTheme: text,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: ink,
        ),
      ),
      dividerColor: isLight ? AppColors.line : AppColors.darkLine,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight ? AppColors.card : AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: isLight
            ? AppColors.greenSoft
            : AppColors.greenMid.withValues(alpha: 0.55),
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return text.labelSmall?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? (isLight ? AppColors.deepGreen : AppColors.goldOnDark)
                : (isLight ? AppColors.inkMuted : AppColors.darkMuted),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? (isLight ? AppColors.deepGreen : AppColors.goldOnDark)
                : (isLight ? AppColors.inkMuted : AppColors.darkMuted),
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: isLight ? AppColors.card : AppColors.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppColors.ivory : AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: text.bodyMedium?.copyWith(
          color: isLight ? AppColors.inkMuted : AppColors.darkMuted,
        ),
        labelStyle: text.bodyMedium?.copyWith(
          color: isLight ? AppColors.inkMuted : AppColors.darkMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          borderSide: BorderSide(
            color: isLight ? AppColors.line : AppColors.darkLine,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          borderSide: BorderSide(
            color: isLight ? AppColors.line : AppColors.darkLine,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          borderSide: const BorderSide(color: AppColors.deepGreen, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return isLight ? AppColors.ivory : AppColors.darkLine;
            }
            if (states.contains(WidgetState.pressed)) {
              return isLight ? AppColors.deepGreenDark : AppColors.goldDeep;
            }
            return buttonBg;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return isLight ? AppColors.inkMuted : AppColors.darkMuted;
            }
            return buttonFg;
          }),
          overlayColor: WidgetStatePropertyAll(
            (isLight ? Colors.white : AppColors.deepGreenDark).withValues(
              alpha: 0.08,
            ),
          ),
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: const WidgetStatePropertyAll(Size(64, 52)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            text.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return isLight ? AppColors.inkMuted : AppColors.darkMuted;
            }
            return isLight ? AppColors.deepGreen : AppColors.goldOnDark;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return isLight ? AppColors.greenSoft : AppColors.greenMid;
            }
            return Colors.transparent;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            final color = states.contains(WidgetState.disabled)
                ? (isLight ? AppColors.line : AppColors.darkLine)
                : (isLight ? AppColors.deepGreen : AppColors.gold);
            return BorderSide(color: color);
          }),
          minimumSize: const WidgetStatePropertyAll(Size(64, 52)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isLight ? AppColors.deepGreen : AppColors.gold,
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? AppColors.ink : AppColors.darkCard,
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}
