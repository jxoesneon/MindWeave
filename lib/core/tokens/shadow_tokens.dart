import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// MindWeave Shadow & Elevation Tokens
///
/// Aura glow shadows replacing Material elevation shadows.
/// Consistent with Stitch design system glass-morphism aesthetic.
///
/// Usage:
/// ```dart
/// BoxShadow shadow = ShadowTokens.cardRest;
/// ```text
class ShadowTokens {
  ShadowTokens._();

  // Primary aura colors
  static Color get _primaryAura => AppColors.primary.withAlpha(38); // 15%
  static Color get _primaryAuraStrong => AppColors.primary.withAlpha(64); // 25%
  static Color get _secondaryAura => AppColors.secondary.withAlpha(38); // 15%

  // Card shadows (rest state)
  static List<BoxShadow> get cardRest => [
    BoxShadow(
      color: _primaryAura,
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  // Card shadows (hover state)
  static List<BoxShadow> get cardHover => [
    BoxShadow(
      color: _primaryAuraStrong,
      blurRadius: 20,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];

  // Button glow (primary)
  static List<BoxShadow> get buttonGlow => [
    BoxShadow(color: _primaryAuraStrong, blurRadius: 15, spreadRadius: 1),
  ];

  // Secondary glow
  static List<BoxShadow> get secondaryGlow => [
    BoxShadow(color: _secondaryAura, blurRadius: 15, spreadRadius: 1),
  ];

  // Glass container shadow (subtle)
  static List<BoxShadow> get glassShadow => [
    BoxShadow(
      color: AppColors.surfaceVariant.withAlpha(76), // 30%
      blurRadius: 20,
      spreadRadius: -5,
      offset: const Offset(0, 8),
    ),
  ];

  // Modal/Dialog shadow (elevated)
  static List<BoxShadow> get modalShadow => [
    BoxShadow(
      color: AppColors.background.withAlpha(128), // 50%
      blurRadius: 40,
      spreadRadius: 0,
      offset: const Offset(0, 20),
    ),
    BoxShadow(color: _primaryAuraStrong, blurRadius: 30, spreadRadius: -10),
  ];

  // Bottom sheet shadow
  static List<BoxShadow> get sheetShadow => [
    BoxShadow(
      color: AppColors.background.withAlpha(204), // 80%
      blurRadius: 30,
      spreadRadius: 0,
      offset: const Offset(0, -10),
    ),
  ];

  // No shadow (flat)
  static List<BoxShadow> get none => [];
}
