import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// MindWeave App Theme
///
/// Complete Material 3 theme implementation based on Stitch design systems:
/// - Uses tonal surface hierarchy (surfaceContainerLowest to Highest)
/// - Glass-morphism elevation effects
/// - "No-Line" rule (no hard borders, use tonal separation)
/// - Soft, rounded corners (8px-12px radius)
/// - Glow shadows instead of Material shadows

class AppTheme {
  // Private constructor
  AppTheme._();

  /// Main dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.primary.withAlpha(25),
        scrim: AppColors.background.withAlpha(204),
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.background,

      // Typography
      textTheme: _textTheme,

      // App Bar Theme
      appBarTheme: _appBarTheme,

      // Card Theme
      cardTheme: _cardTheme,

      // Input Decoration Theme
      inputDecorationTheme: _inputDecorationTheme,

      // Button Themes
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,

      // Chip Theme
      chipTheme: _chipTheme,

      // Slider Theme
      sliderTheme: _sliderTheme,

      // Switch Theme
      switchTheme: _switchTheme,

      // Bottom Sheet Theme
      bottomSheetTheme: _bottomSheetTheme,

      // Dialog Theme
      dialogTheme: _dialogTheme,

      // Divider Theme (Ghost borders)
      dividerTheme: _dividerTheme,

      // Icon Theme
      iconTheme: _iconTheme,

      // Tooltip Theme
      tooltipTheme: _tooltipTheme,

      // Snack Bar Theme
      snackBarTheme: _snackBarTheme,

      // Floating Action Button Theme
      floatingActionButtonTheme: _floatingActionButtonTheme,
    );
  }

  // Text Theme
  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: AppTypography.displayLarge,
      displayMedium: AppTypography.displayMedium,
      displaySmall: AppTypography.displaySmall,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      titleSmall: AppTypography.titleSmall,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    );
  }

  // App Bar Theme - Transparent with blur effect
  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.surface.withAlpha(102),
      foregroundColor: AppColors.onSurface,
      titleTextStyle: AppTypography.headlineSmall,
      centerTitle: true,
      toolbarHeight: 56,
    );
  }

  // Card Theme - Tonal nesting, soft corners
  static CardThemeData get _cardTheme {
    return CardThemeData(
      elevation: 0,
      color: AppColors.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }

  // Input Decoration - Ghost border on focus
  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outlineVariant, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      hintStyle: AppTypography.bodyMedium.muted,
      labelStyle: AppTypography.labelMedium,
    );
  }

  // Elevated Button - Gradient fill, pill shape
  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppTypography.button,
      ),
    );
  }

  // Text Button - Minimal, ghost style
  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.labelMedium,
      ),
    );
  }

  // Outlined Button - Ghost border
  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: AppTypography.labelMedium,
      ),
    );
  }

  // Chip Theme - Pill shape, tonal background
  static ChipThemeData get _chipTheme {
    return ChipThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: AppTypography.labelSmall,
      secondaryLabelStyle: AppTypography.labelSmall.onPrimary,
      brightness: Brightness.dark,
    );
  }

  // Slider Theme - Aura glow on thumb
  static SliderThemeData get _sliderTheme {
    return SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.surfaceContainerHigh,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withAlpha(25),
      trackHeight: 2,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
    );
  }

  // Switch Theme - Glow effect
  static SwitchThemeData get _switchTheme {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.surfaceBright;
        }
        return AppColors.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary.withAlpha(77);
        }
        return AppColors.surfaceContainerHigh;
      }),
    );
  }

  // Bottom Sheet Theme - Glass morphism
  static BottomSheetThemeData get _bottomSheetTheme {
    return BottomSheetThemeData(
      backgroundColor: AppColors.surfaceContainer.withAlpha(242),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      modalBackgroundColor: AppColors.surfaceContainer.withAlpha(250),
    );
  }

  // Dialog Theme - Glass morphism
  static DialogThemeData get _dialogTheme {
    return DialogThemeData(
      backgroundColor: AppColors.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: AppTypography.headlineSmall,
      contentTextStyle: AppTypography.bodyMedium,
    );
  }

  // Divider Theme - Ghost border
  static DividerThemeData get _dividerTheme {
    return DividerThemeData(
      color: AppColors.outlineVariant.withAlpha(77),
      thickness: 1,
      space: 1,
    );
  }

  // Icon Theme
  static IconThemeData get _iconTheme {
    return const IconThemeData(color: AppColors.onSurfaceVariant, size: 24);
  }

  // Tooltip Theme
  static TooltipThemeData get _tooltipTheme {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTypography.labelSmall,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  // Snack Bar Theme
  static SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      contentTextStyle: AppTypography.bodyMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    );
  }

  // Floating Action Button Theme
  static FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryContainer,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

/// Glass morphism decoration helper
class GlassDecoration extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final double opacity;
  final double blurSigma;

  const GlassDecoration({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(16),
    this.opacity = 0.6,
    this.blurSigma = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ColorFilter.mode(
          AppColors.surfaceVariant.withAlpha((opacity * 255).round()),
          BlendMode.srcOver,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withAlpha((opacity * 255).round()),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.outlineVariant.withAlpha(76)),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Aura glow decoration for active elements
class AuraGlow extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blurRadius;
  final double spreadRadius;

  const AuraGlow({
    super.key,
    required this.child,
    this.color = AppColors.primary,
    this.blurRadius = 40,
    this.spreadRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((0.2 * 255).round()),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Tonal surface container that follows hierarchy
class TonalContainer extends StatelessWidget {
  final Widget child;
  final TonalLevel level;
  final EdgeInsets padding;
  final double borderRadius;
  final Border? border;

  const TonalContainer({
    super.key,
    required this.child,
    this.level = TonalLevel.surfaceContainer,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: level.color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: child,
    );
  }
}

/// Tonal surface hierarchy levels
enum TonalLevel {
  surface,
  surfaceContainerLowest,
  surfaceContainerLow,
  surfaceContainer,
  surfaceContainerHigh,
  surfaceContainerHighest,
  surfaceVariant,
}

extension TonalLevelExtension on TonalLevel {
  Color get color {
    switch (this) {
      case TonalLevel.surface:
        return AppColors.surface;
      case TonalLevel.surfaceContainerLowest:
        return AppColors.surfaceContainerLowest;
      case TonalLevel.surfaceContainerLow:
        return AppColors.surfaceContainerLow;
      case TonalLevel.surfaceContainer:
        return AppColors.surfaceContainer;
      case TonalLevel.surfaceContainerHigh:
        return AppColors.surfaceContainerHigh;
      case TonalLevel.surfaceContainerHighest:
        return AppColors.surfaceContainerHighest;
      case TonalLevel.surfaceVariant:
        return AppColors.surfaceVariant;
    }
  }
}
