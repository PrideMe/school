import 'package:flutter/material.dart';

class AppColors {
  // Dark Tech Base Palette
  static const Color background = Color(0xFF0B1021);
  static const Color surface = Color(0xFF131B2E);
  static const Color surfaceLight = Color(0xFF1C2744);
  static const Color cardBg = Color(0xFF151D36);
  static const Color cardBorder = Color(0xFF263556);

  // Brand Cyber Accents
  static const Color primary = Color(0xFF00F2FE);
  static const Color primaryDark = Color(0xFF4FACFE);
  static const Color secondary = Color(0xFF7C4DFF);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentBlue = Color(0xFF2979FF);
  static const Color accentGreen = Color(0xFF00E676);
  static const Color accentOrange = Color(0xFFFF9100);
  static const Color accentRed = Color(0xFFFF5252);
  static const Color accentPurple = Color(0xFFB388FF);

  // Text Colors
  static const Color textPrimary = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0x2000F2FE), Color(0x054FACFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGreenGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF1DE9B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
