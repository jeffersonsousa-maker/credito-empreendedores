import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'PlusJakartaSans';

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.red,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.red,
      onPrimary: AppColors.white,
      secondary: AppColors.textStrong,
      onSecondary: AppColors.white,
      error: AppColors.error,
      surface: AppColors.white,
      onSurface: AppColors.textStrong,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.white,
      visualDensity: VisualDensity.standard,
    );

    final textTheme = base.textTheme
        .apply(
          fontFamily: fontFamily,
          bodyColor: AppColors.text,
          displayColor: AppColors.textStrong,
        )
        .copyWith(
          displayMedium: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 52,
            height: 1.08,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
            color: AppColors.textStrong,
          ),
          headlineLarge: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 38,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: AppColors.textStrong,
          ),
          headlineMedium: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 30,
            height: 1.2,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: AppColors.textStrong,
          ),
          titleLarge: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 20,
            height: 1.3,
            fontWeight: FontWeight.w700,
            color: AppColors.textStrong,
          ),
          titleMedium: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 17,
            height: 1.35,
            fontWeight: FontWeight.w700,
            color: AppColors.textStrong,
          ),
          bodyLarge: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 18,
            height: 1.6,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
          ),
          bodyMedium: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            height: 1.6,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
          ),
          bodySmall: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
          labelLarge: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        );

    const radius = BorderRadius.all(Radius.circular(12));

    OutlineInputBorder border(Color color, [double width = 1.2]) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: fontFamily,
          color: AppColors.redDark,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(
          fontFamily: fontFamily,
          color: AppColors.textMuted,
        ),
        errorStyle: const TextStyle(
          fontFamily: fontFamily,
          color: AppColors.error,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        errorMaxLines: 3,
        border: border(AppColors.border),
        enabledBorder: border(AppColors.border),
        focusedBorder: border(AppColors.red, 2),
        errorBorder: border(AppColors.error, 1.5),
        focusedErrorBorder: border(AppColors.error, 2),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textStrong,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: radius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textStrong,
          minimumSize: const Size(48, 44),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.textMuted, width: 1.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textStrong,
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          color: AppColors.white,
          fontSize: 15,
          height: 1.4,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      focusColor: AppColors.redTintStrong,
      // Transição com zoom e fade entre a página principal e o Aviso de
      // Privacidade, igual em todos os sistemas.
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: const ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }
}
