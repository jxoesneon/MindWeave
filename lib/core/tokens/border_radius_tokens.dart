import 'package:flutter/material.dart';

/// MindWeave Border Radius Tokens
///
/// Consistent corner rounding following Material Design 3 and Stitch design.
/// Soft, rounded aesthetic matching the app's glass-morphism style.
///
/// Usage:
/// ```dart
/// BorderRadius.circular(BorderRadiusTokens.lg) // 12px
/// ```text
class BorderRadiusTokens {
  BorderRadiusTokens._();

  /// Extra small (2px) - Subtle rounding for small elements
  static const double xs = 2;

  /// Small (4px) - Chips, small buttons, badges
  static const double sm = 4;

  /// Medium (8px) - Cards, dialogs, medium buttons (default)
  static const double md = 8;

  /// Large (12px) - Bottom sheets, modals, large cards
  static const double lg = 12;

  /// Extra large (16px) - Full cards, hero sections
  static const double xl = 16;

  /// Full (9999px) - Pills, buttons with fully rounded ends
  static const double full = 9999;

  // Pre-built BorderRadius values for convenience
  static BorderRadius get xsCircular => BorderRadius.circular(xs);
  static BorderRadius get smCircular => BorderRadius.circular(sm);
  static BorderRadius get mdCircular => BorderRadius.circular(md);
  static BorderRadius get lgCircular => BorderRadius.circular(lg);
  static BorderRadius get xlCircular => BorderRadius.circular(xl);
  static BorderRadius get fullCircular => BorderRadius.circular(full);

  // Vertical-only radius (for bottom sheets)
  static BorderRadius get topSheet =>
      const BorderRadius.vertical(top: Radius.circular(lg));

  // Card-specific radius (large on all corners)
  static BorderRadius get card => BorderRadius.circular(lg);

  // Button-specific radius (full pill shape)
  static BorderRadius get button => BorderRadius.circular(full);

  // Input field radius (medium)
  static BorderRadius get input => BorderRadius.circular(md);

  // Chip/Badge radius (small)
  static BorderRadius get chip => BorderRadius.circular(sm);
}
