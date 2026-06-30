import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5B6BFF);
  static const Color primaryDark = Color(0xFF3E48D6);
  static const Color accent = Color(0xFF45D58A);
  static const Color ink = Color(0xFF14172E);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color mutedText = Color(0xFF9CA3AF);
  static const Color line = Color(0xFFE6E9F5);
  static const Color background = Color(0xFFF7F8FF);
  static const Color card = Colors.white;
  static const Color danger = Color(0xFFFF5A6A);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.danger,
        surface: AppColors.card,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamilyFallback: const ['PingFang SC', 'Microsoft YaHei', 'Arial'],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.ink,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30.sp,
          height: 1.2,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 24.sp,
          height: 1.25,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
        titleLarge: TextStyle(
          fontSize: 20.sp,
          height: 1.3,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
        titleMedium: TextStyle(
          fontSize: 16.sp,
          height: 1.4,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 15.sp,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.sp,
          height: 1.45,
          color: AppColors.secondaryText,
        ),
        labelLarge: TextStyle(
          fontSize: 15.sp,
          height: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: AppColors.mutedText, fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFC9CEEA),
          disabledForegroundColor: Colors.white,
          minimumSize: Size.fromHeight(48.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: Size.fromHeight(48.h),
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
