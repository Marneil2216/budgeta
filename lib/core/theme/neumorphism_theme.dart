import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class NeumorphismTheme {
  NeumorphismTheme._();

  static BoxDecoration raised({
    Color? color,
    double radius = AppSpacing.cardRadius,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.surfaceBase,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowDark,
            offset: Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      );

  static BoxDecoration inset({
    Color? color,
    double radius = AppSpacing.cardRadius,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.surfaceBase,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowDark,
            offset: Offset(-3, -3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(3, 3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      );

  static BoxDecoration heroCard = BoxDecoration(
    borderRadius: BorderRadius.circular(AppSpacing.heroCardRadius),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.deepGreen, Color(0xFF2DA876)],
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.deepGreen.withOpacity(0.4),
        offset: const Offset(0, 8),
        blurRadius: 20,
      ),
    ],
  );

  static BoxDecoration overspentCard = BoxDecoration(
    borderRadius: BorderRadius.circular(AppSpacing.heroCardRadius),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFB71C1C), Color(0xFFE53935)],
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.errorRed.withOpacity(0.4),
        offset: const Offset(0, 8),
        blurRadius: 20,
      ),
    ],
  );
}
