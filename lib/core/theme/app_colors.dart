import 'package:flutter/material.dart';

/// MindWeave Design System
///
/// Based on Stitch design systems:
/// - MindWeave Design System (primary)
/// - MindWeave Deep State (Sonic Monolith)
/// - Lumina Resonance (Sonic Sanctuary)
/// - MindWeave Ethos (The Ethereal Pulse)
///
/// All systems share core principles:
/// - Dark mode foundation (#0D0D0F / #131315)
/// - Purple primary (#7B68EE / #c8bfff)
/// - Turquoise secondary (#00D9C0 / #47f5db)
/// - Glass-morphism effects
/// - Tonal layering (no hard borders)
/// - Space Grotesk + Inter typography

class AppColors {
  // Core Foundation
  static const Color background = Color(0xFF0D0D0F);
  static const Color surface = Color(0xFF131315);
  static const Color surfaceDim = Color(0xFF131315);
  static const Color surfaceBright = Color(0xFF39393B);

  // Surface Container Hierarchy (Tonal Nesting)
  static const Color surfaceContainerLowest = Color(0xFF0E0E10);
  static const Color surfaceContainerLow = Color(0xFF1B1B1D);
  static const Color surfaceContainer = Color(0xFF201F21);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2C);
  static const Color surfaceContainerHighest = Color(0xFF353437);
  static const Color surfaceVariant = Color(0xFF353437);

  // Primary Palette (Purple)
  static const Color primary = Color(0xFF7B68EE);
  static const Color primaryContainer = Color(0xFF907EFF);
  static const Color primaryFixed = Color(0xFFE5DEFF);
  static const Color primaryFixedDim = Color(0xFFC8BFFF);
  static const Color onPrimary = Color(0xFF2D009D);
  static const Color onPrimaryContainer = Color(0xFF26008B);
  static const Color onPrimaryFixed = Color(0xFF190064);
  static const Color onPrimaryFixedVariant = Color(0xFF442BB5);
  static const Color inversePrimary = Color(0xFF5C47CD);
  static const Color surfaceTint = Color(0xFFC8BFFF);

  // Secondary Palette (Turquoise/Cyan)
  static const Color secondary = Color(0xFF00D9C0);
  static const Color secondaryContainer = Color(0xFF00D9C0);
  static const Color secondaryFixed = Color(0xFF4FFBE1);
  static const Color secondaryFixedDim = Color(0xFF1ADEC5);
  static const Color onSecondary = Color(0xFF003730);
  static const Color onSecondaryContainer = Color(0xFF00594E);
  static const Color onSecondaryFixed = Color(0xFF00201B);
  static const Color onSecondaryFixedVariant = Color(0xFF005046);

  // Tertiary Palette (Warm Accent)
  static const Color tertiary = Color(0xFFFFB86A);
  static const Color tertiaryContainer = Color(0xFFCA801D);
  static const Color tertiaryFixed = Color(0xFFFFDCBC);
  static const Color tertiaryFixedDim = Color(0xFFFFB86A);
  static const Color onTertiary = Color(0xFF492900);
  static const Color onTertiaryContainer = Color(0xFF3F2300);
  static const Color onTertiaryFixed = Color(0xFF2C1700);
  static const Color onTertiaryFixedVariant = Color(0xFF683D00);

  // Content Colors
  static const Color onSurface = Color(0xFFE5E1E4);
  static const Color onSurfaceVariant = Color(0xFFC9C4D6);
  static const Color onBackground = Color(0xFFE5E1E4);
  static const Color inverseOnSurface = Color(0xFF313032);
  static const Color inverseSurface = Color(0xFFE5E1E4);

  // Outlines (Ghost Borders)
  static const Color outline = Color(0xFF928E9F);
  static const Color outlineVariant = Color(0xFF474554);

  // Error Colors
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onError = Color(0xFF690005);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Brainwave Band Colors (Frequency States)
  static const Color delta = Color(0xFF4A90D9); // Deep Sleep (Blue)
  static const Color theta = Color(0xFF9B59B6); // Meditation (Purple)
  static const Color alpha = Color(0xFF7B68EE); // Relaxation (Slate Blue)
  static const Color beta = Color(0xFFE67E22); // Focus (Orange)
  static const Color gamma = Color(0xFFE74C3C); // Peak (Red)

  // Gradient Helpers
  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get secondaryGradient => const LinearGradient(
    colors: [secondary, secondaryFixed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get glassGradient => LinearGradient(
    colors: [
      surfaceVariant.withAlpha(153), // 0.6 * 255
      surfaceContainer.withAlpha(102), // 0.4 * 255
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Aura Glow Colors
  static Color get auraGlow =>
      const Color(0xFF7B68EE).withAlpha(38); // 0.15 * 255
  static Color get auraGlowStrong =>
      const Color(0xFF7B68EE).withAlpha(64); // 0.25 * 255
  static Color get secondaryAura =>
      const Color(0xFF00D9C0).withAlpha(38); // 0.15 * 255
}
