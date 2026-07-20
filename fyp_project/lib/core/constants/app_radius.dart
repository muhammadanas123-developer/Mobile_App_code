import 'package:flutter/material.dart';

/// AppRadius defines the standard corner radii for container card shapes, inputs, and buttons.
class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double round = 999.0;

  // BorderRadius objects
  static final BorderRadius borderXS = BorderRadius.circular(xs);
  static final BorderRadius borderSM = BorderRadius.circular(sm);
  static final BorderRadius borderMD = BorderRadius.circular(md);
  static final BorderRadius borderLG = BorderRadius.circular(lg);
  static final BorderRadius borderXL = BorderRadius.circular(xl);
  static final BorderRadius borderXXL = BorderRadius.circular(xxl);
  static final BorderRadius borderRound = BorderRadius.circular(round);
}