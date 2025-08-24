import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5A4FCF);
  static const Color primaryLight = Color(0xFF8B7EE8);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryDark = Color(0xFFE55555);
  static const Color secondaryLight = Color(0xFFFF8E8E);
  
  // Accent Colors
  static const Color accent = Color(0xFF00CEC9);
  static const Color accentDark = Color(0xFF00B3A6);
  static const Color accentLight = Color(0xFF26D0C9);
  
  // Background Colors
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF2D2D2D);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  

  
  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFE17055);
  static const Color info = Color(0xFF74B9FF);
  
  // Social Colors
  static const Color like = Color(0xFFE84393);
  static const Color comment = Color(0xFF74B9FF);
  static const Color share = Color(0xFF00CEC9);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xB3000000);
  
  // Border Colors
  static const Color border = Color(0xFF3D3D3D);
  static const Color borderLight = Color(0xFF4D4D4D);
  static const Color borderDark = Color(0xFF2D2D2D);
}