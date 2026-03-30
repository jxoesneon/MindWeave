/// MindWeave Theme System
library;

///
/// Complete design system implementation based on Stitch MCP design systems:
/// - MindWeave Design System (Primary)
/// - MindWeave Deep State (Sonic Monolith)
/// - Lumina Resonance (Sonic Sanctuary)
/// - MindWeave Ethos (The Ethereal Pulse)
///
/// Design Principles:
/// - Dark mode foundation (#0D0D0F / #131315)
/// - Tonal surface hierarchy (no hard borders)
/// - Glass-morphism effects
/// - Purple primary (#7B68EE), Turquoise secondary (#00D9C0)
/// - Space Grotesk headlines, Inter body text
/// - Aura glows instead of Material shadows
/// - Brainwave band color coding
///
/// Usage:
/// ```dart
/// import 'package:mindweave/core/theme/app_theme.dart';
///
/// MaterialApp(
///   theme: AppTheme.darkTheme,
///   // ...
/// )
/// ```

// Barrel file exports
export 'app_colors.dart';
export 'app_theme.dart';
export 'app_typography.dart';
