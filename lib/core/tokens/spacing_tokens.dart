import 'package:flutter/material.dart';

/// MindWeave Spacing Tokens
///
/// Based on 8dp grid system (Material Design) with 4dp micro-adjustments.
/// Follows ui-ux-pro-max spacing guidelines for consistent rhythm.
///
/// Usage: Use these tokens instead of hardcoded values for consistent spacing.
///
/// Example:
/// ```dart
/// Padding(padding: EdgeInsets.all(SpacingTokens.md)) // 16dp
/// ```text
class SpacingTokens {
  SpacingTokens._();

  // Base unit (4dp) - smallest increment
  static const double unit = 4;

  // Micro spacing (4-8dp) - tight gaps, internal padding
  static const double xxs = 4; // space-1: Icon-to-text, tight internal gaps
  static const double xs = 8; // space-2: Compact element padding

  // Small spacing (12-16dp) - related element grouping
  static const double sm =
      12; // space-3: Card internal padding, form field gaps
  static const double md =
      16; // space-4: Standard element padding, section dividers

  // Medium spacing (20-24dp) - section separation
  static const double lg = 24; // space-6: Section padding, card margins
  static const double xl =
      32; // space-8: Large section gaps, screen edge padding (mobile)

  // Large spacing (40-64dp) - major section breaks
  static const double xxl = 40; // space-10: Desktop screen edge padding start
  static const double xxxl = 48; // space-12: Major section breaks
  static const double huge = 64; // space-16: Hero spacing, major dividers

  // Edge insets by breakpoint (responsive)
  static EdgeInsets get screenPaddingMobile => const EdgeInsets.symmetric(
    horizontal: xl, // 32dp
    vertical: md, // 16dp
  );

  static EdgeInsets get screenPaddingTablet => const EdgeInsets.symmetric(
    horizontal: xxl, // 40dp
    vertical: lg, // 24dp
  );

  static EdgeInsets get screenPaddingDesktop => const EdgeInsets.symmetric(
    horizontal: xxxl, // 48dp
    vertical: lg, // 24dp
  );

  // Component-specific spacing
  static EdgeInsets get cardPadding => const EdgeInsets.all(md); // 16dp
  static EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
    horizontal: lg, // 24dp
    vertical: sm, // 12dp
  );
  static EdgeInsets get listItemPadding => const EdgeInsets.symmetric(
    horizontal: md, // 16dp
    vertical: sm, // 12dp
  );
  static EdgeInsets get chipPadding => const EdgeInsets.symmetric(
    horizontal: sm, // 12dp
    vertical: xs, // 8dp
  );

  // Touch target minimum size (44pt iOS / 48dp Android)
  // Per ui-ux-pro-max: Minimum 44×44pt for accessibility
  static const double minTouchTarget = 44;

  // Gap between touch targets (minimum 8dp per ui-ux-pro-max)
  static const double minTouchGap = 8;
}
