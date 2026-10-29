import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.emerald,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.emerald,
          onPrimary: AppColors.white,
          secondary: AppColors.gold,
          onSecondary: AppColors.forest,
          tertiary: AppColors.teal,
          onTertiary: AppColors.white,
          surface: AppColors.cream,
          onSurface: AppColors.ink,
          error: AppColors.danger,
          onError: AppColors.white,
        );

    final textTheme = _textTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.forest,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.forest,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerColor: AppColors.line,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.emerald.withValues(alpha: 0.35),
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.85),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.emerald,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.emerald),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.emerald,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        border: _border(AppColors.line),
        enabledBorder: _border(AppColors.line),
        focusedBorder: _border(AppColors.emerald, width: 1.6),
        errorBorder: _border(AppColors.danger),
        focusedErrorBorder: _border(AppColors.danger, width: 1.6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        height: 68,
        indicatorColor: AppColors.emerald.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.emerald : AppColors.muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.emerald : AppColors.muted,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navy,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.emerald;
          return AppColors.white;
        }),
        side: const BorderSide(color: AppColors.emerald, width: 1.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    TextStyle sans({
      double size = 14,
      FontWeight weight = FontWeight.w500,
      Color? color,
      double? height,
      double? letterSpacing,
    }) {
      return GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight,
        color: color ?? scheme.onSurface,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    TextStyle display({
      required double size,
      FontWeight weight = FontWeight.w600,
      Color? color,
    }) {
      return GoogleFonts.cormorantGaramond(
        fontSize: size,
        fontWeight: weight,
        color: color ?? scheme.onSurface,
        height: 1.05,
      );
    }

    return TextTheme(
      displayLarge: display(size: 40, weight: FontWeight.w600),
      displayMedium: display(size: 34),
      headlineLarge: display(size: 30),
      headlineMedium: sans(size: 24, weight: FontWeight.w700),
      headlineSmall: sans(size: 20, weight: FontWeight.w700),
      titleLarge: sans(size: 18, weight: FontWeight.w700),
      titleMedium: sans(size: 16, weight: FontWeight.w600),
      titleSmall: sans(size: 14, weight: FontWeight.w700),
      bodyLarge: sans(size: 16, weight: FontWeight.w500, height: 1.45),
      bodyMedium: sans(size: 14, weight: FontWeight.w500, height: 1.45),
      bodySmall: sans(
        size: 12,
        weight: FontWeight.w500,
        height: 1.4,
        color: AppColors.muted,
      ),
      labelLarge: sans(size: 14, weight: FontWeight.w700),
      labelMedium: sans(size: 12, weight: FontWeight.w600),
      labelSmall: sans(size: 11, weight: FontWeight.w600),
    );
  }
}
