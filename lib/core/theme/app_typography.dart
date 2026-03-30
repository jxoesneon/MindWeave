import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography system for MindWeave
/// 
/// Headlines: Space Grotesk - geometric, editorial, high contrast
/// Body: Inter - human-readable, neutral, highly legible
/// 
/// Based on Stitch design system specifications:
/// - display-lg: 3.5rem (56px) for hero moments
/// - headline-md: 1.75rem (28px) for section headers
/// - body-lg: 1rem (16px) for primary content
/// - label-md: uppercase with letter-spacing for category tags

class AppTypography {
  // Font Families
  static const String headlineFont = 'Space Grotesk';
  static const String bodyFont = 'Inter';
  
  // Display Styles (Hero Moments)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: headlineFont,
    fontSize: 56,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.02,
    height: 1.2,
    color: AppColors.onSurface,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: headlineFont,
    fontSize: 44,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.02,
    height: 1.2,
    color: AppColors.onSurface,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: headlineFont,
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.02,
    height: 1.2,
    color: AppColors.onSurface,
  );
  
  // Headline Styles (Section Headers)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: headlineFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.3,
    color: AppColors.onSurface,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: headlineFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.3,
    color: AppColors.onSurface,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: headlineFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.3,
    color: AppColors.onSurface,
  );
  
  // Title Styles (Card Titles, List Items)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.onSurface,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.onSurface,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.onSurface,
  );
  
  // Body Styles (Primary Content)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.onSurface,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.onSurface,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.onSurfaceVariant,
  );
  
  // Label Styles (Category Tags, Buttons)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
    height: 1.2,
    color: AppColors.onSurface,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
    height: 1.2,
    color: AppColors.onSurface,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
    height: 1.2,
    color: AppColors.onSurfaceVariant,
  );
  
  // Specialized Styles
  static const TextStyle button = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.02,
    height: 1.2,
    color: AppColors.onSurface,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.02,
    height: 1.4,
    color: AppColors.onSurfaceVariant,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: bodyFont,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.08,
    height: 1.2,
    color: AppColors.onSurfaceVariant,
  );
  
  // Timer/Monospace Style
  static const TextStyle timer = TextStyle(
    fontFamily: bodyFont,
    fontSize: 24,
    fontWeight: FontWeight.w300,
    letterSpacing: 2,
    height: 1.2,
    color: AppColors.onSurface,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  // Frequency Display
  static const TextStyle frequency = TextStyle(
    fontFamily: headlineFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
    color: AppColors.primary,
  );
  
  // Premium Hardware Style (for settings labels)
  static const TextStyle hardwareLabel = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
    height: 1.2,
    color: AppColors.onSurfaceVariant,
  );
}

/// Extension to get themed text styles
extension TextStyleExtension on TextStyle {
  TextStyle get primary => copyWith(color: AppColors.primary);
  TextStyle get secondary => copyWith(color: AppColors.secondary);
  TextStyle get tertiary => copyWith(color: AppColors.tertiary);
  TextStyle get muted => copyWith(color: AppColors.onSurfaceVariant);
  TextStyle get onPrimary => copyWith(color: AppColors.onPrimary);
  TextStyle get onSurface => copyWith(color: AppColors.onSurface);
}
