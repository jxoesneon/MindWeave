import 'package:flutter/material.dart';

/// Shared component enums and types
///
/// Button size variants used across atomic components
enum ButtonSize { small, medium, large }

/// Badge size variants
enum BadgeSize { small, medium, large }

/// Tonal hierarchy levels per Material 3
enum TonalLevel {
  /// Lowest - For modal sheets/scrimmed backgrounds
  surfaceContainerLowest,

  /// Low - For cards, secondary content
  surfaceContainerLow,

  /// Default - For primary containers
  surfaceContainer,

  /// High - For elevated cards, hover states
  surfaceContainerHigh,

  /// Highest - For highest elevation surfaces
  surfaceContainerHighest,
}

/// Extension to get color values for TonalLevel
extension TonalLevelColor on TonalLevel {
  /// Returns the corresponding AppColors color for this tonal level
  Color get color {
    switch (this) {
      case TonalLevel.surfaceContainerLowest:
        return const Color(0xFF0E0E10); // AppColors.surfaceContainerLowest
      case TonalLevel.surfaceContainerLow:
        return const Color(0xFF1B1B1D); // AppColors.surfaceContainerLow
      case TonalLevel.surfaceContainer:
        return const Color(0xFF201F21); // AppColors.surfaceContainer
      case TonalLevel.surfaceContainerHigh:
        return const Color(0xFF2A2A2C); // AppColors.surfaceContainerHigh
      case TonalLevel.surfaceContainerHighest:
        return const Color(0xFF353437); // AppColors.surfaceContainerHighest
    }
  }
}
