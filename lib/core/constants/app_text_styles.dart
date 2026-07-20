import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// AppTextStyles provides central, design-consistent typography using Google Fonts (Outfit).
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static TextStyle h1({Color color = AppColors.textDark}) => GoogleFonts.outfit(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: color,
    letterSpacing: -0.5,
  );

  static TextStyle h2({Color color = AppColors.textDark}) => GoogleFonts.outfit(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: color,
    letterSpacing: -0.2,
  );

  static TextStyle h3({Color color = AppColors.textDark}) => GoogleFonts.outfit(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // Subtitles / Titles
  static TextStyle titleLarge({Color color = AppColors.textDark}) => GoogleFonts.outfit(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle titleMedium({Color color = AppColors.textDark}) => GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: color,
  );

  static TextStyle titleSmall({Color color = AppColors.textDark}) => GoogleFonts.outfit(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: color,
  );

  // Body Texts
  static TextStyle bodyLarge({Color color = AppColors.textMedium}) => GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: color,
    height: 1.5,
  );

  static TextStyle bodyMedium({Color color = AppColors.textMedium}) => GoogleFonts.outfit(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: color,
    height: 1.4,
  );

  static TextStyle bodySmall({Color color = AppColors.textLight}) => GoogleFonts.outfit(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: color,
    height: 1.3,
  );

  // Metrics / Numbers (e.g. 82%, €1,240.00)
  static TextStyle metric({Color color = AppColors.textDark}) => GoogleFonts.outfit(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: color,
  );

  static TextStyle metricSmall({Color color = AppColors.textDark}) => GoogleFonts.outfit(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: color,
  );

  // Labels & Actions
  static TextStyle button({Color color = AppColors.surface}) => GoogleFonts.outfit(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: color,
    letterSpacing: 0.5,
  );

  static TextStyle label({Color color = AppColors.textMedium}) => GoogleFonts.outfit(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: color,
    letterSpacing: 0.5,
  );
}