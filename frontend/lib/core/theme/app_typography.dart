import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.6,
    color: AppColors.onSurface,
  );

  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.5,
    color: AppColors.onSurface,
  );

  static TextStyle headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.4,
    color: AppColors.onSurface,
  );

  static TextStyle headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.3,
    color: AppColors.onSurface,
  );

  static TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.onSurface,
  );

  static TextStyle titleLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.onSurface,
  );

  static TextStyle titleMedium = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.onSurface,
  );

  static TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  static TextStyle labelMedium = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.onSurface,
  );

  static TextStyle labelSmall = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
  );
}
