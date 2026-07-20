import 'package:flutter/material.dart';

/// AppColors contains all the color constants used throughout the Lumière Beauty app.
class AppColors {
  AppColors._();

  // Brand Palette
  static const Color primaryDark = Color(0xFF2A4B3D); // Deep forest green
  static const Color primaryAccent = Color(0xFFB1E0C9); // Mint accent
  static const Color primaryLight = Color(0xFFE1F2E8); // Light mint background/chips

  // Neutral Palette
  static const Color background = Color(0xFFF8F9FA); // Very light grey/white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFF1F5F9); // Light card grey
  static const Color border = Color(0xFFE2E8F0); // Subtle dividers/borders

  // Text colors
  static const Color textDark = Color(0xFF13201A); // Dark charcoal green
  static const Color textMedium = Color(0xFF475569); // Dark grey
  static const Color textLight = Color(0xFF94A3B8); // Slate grey

  // Status & Accents
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningText = Color(0xFFD97706);
  static const Color errorBg = Color(0xFFFEE2E2); // Light red for irregular texture/sensitivity
  static const Color errorText = Color(0xFFEF4444); // Dark red for errors
  static const Color success = Color(0xFF10B981); // Emerald green for optimal indicators
  static const Color starYellow = Color(0xFFFBBF24); // Star rating gold

  // Overlay colors
  static const Color shadow = Color(0x0A000000);
  static const Color overlayDark = Color(0x7F000000);
}