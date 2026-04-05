import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// MindWeave Typography Tokens
///
/// Semantic typography scale mapping to Material 3 type roles.
/// Uses Space Grotesk for display/headlines, Inter for body.
///
/// Usage:
/// ```dart
/// style: TypographyTokens.displayLarge
/// ```text
class TypographyTokens {
  TypographyTokens._();

  // Font families
  static const String displayFont = 'Space Grotesk';
  static const String bodyFont = 'Inter';

  // Display styles (Space Grotesk) - Large, bold, attention-grabbing

  /// Display Large - Hero text, welcome screens (57px)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12, // 64px line height
    letterSpacing: -0.25,
    color: AppColors.onSurface,
  );

  /// Display Medium - Large headlines (45px)
  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
    color: AppColors.onSurface,
  );

  /// Display Small - Section heroes (36px)
  static const TextStyle displaySmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.22,
    color: AppColors.onSurface,
  );

  // Headline styles (Space Grotesk) - Page titles, important sections

  /// Headline Large - Page titles (32px)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.25,
    color: AppColors.onSurface,
  );

  /// Headline Medium - Section headers (28px)
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.29,
    color: AppColors.onSurface,
  );

  /// Headline Small - Subsection headers (24px)
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.onSurface,
  );

  // Title styles (Inter) - Card titles, list items

  /// Title Large - Card titles, dialog titles (22px)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.27,
    color: AppColors.onSurface,
  );

  /// Title Medium - List item titles (16px)
  static const TextStyle titleMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.onSurface,
  );

  /// Title Small - Compact titles, metadata (14px)
  static const TextStyle titleSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  // Body styles (Inter) - Paragraphs, descriptions

  /// Body Large - Primary body text (16px)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  /// Body Medium - Secondary body text (14px)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: AppColors.onSurfaceVariant,
  );

  /// Body Small - Captions, helper text (12px)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
  );

  // Label styles (Inter) - Buttons, chips, navigation

  /// Label Large - Buttons, tabs (14px)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  /// Label Medium - Chips, badges (12px)
  static const TextStyle labelMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  /// Label Small - Captions, overlines (11px)
  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
    color: AppColors.onSurfaceVariant,
  );

  // Specialized styles

  /// Button text style
  static const TextStyle button = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.onPrimary,
  );

  /// Tab bar label
  static const TextStyle tabLabel = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.onSurfaceVariant,
  );

  /// Stat/metric number (tabular figures)
  static const TextStyle statNumber = TextStyle(
    fontFamily: bodyFont,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.onSurface,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Time display (tabular figures)
  static const TextStyle timeDisplay = TextStyle(
    fontFamily: displayFont,
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: AppColors.onSurface,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
