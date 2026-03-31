import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Accessibility settings provider for managing user preferences.
///
/// Provides reactive state for:
/// - High contrast mode
/// - Reduced motion
/// - Large text
/// - Screen reader optimization
final accessibilityControllerProvider = NotifierProvider<AccessibilityController, AccessibilityState>(
  AccessibilityController.new,
);

class AccessibilityController extends Notifier<AccessibilityState> {
  @override
  AccessibilityState build() {
    return const AccessibilityState();
  }

  /// Toggle high contrast mode.
  void setHighContrast(bool enabled) {
    state = state.copyWith(highContrast: enabled);
  }

  /// Toggle reduced motion.
  void setReducedMotion(bool enabled) {
    state = state.copyWith(reducedMotion: enabled);
  }

  /// Toggle large text.
  void setLargeText(bool enabled) {
    state = state.copyWith(largeText: enabled);
  }

  /// Toggle screen reader optimization.
  void setScreenReaderOptimized(bool enabled) {
    state = state.copyWith(screenReaderOptimized: enabled);
  }

  /// Update all settings at once.
  void updateSettings(AccessibilityState newState) {
    state = newState;
  }
}

/// Accessibility state containing all user preferences.
@immutable
class AccessibilityState {
  final bool highContrast;
  final bool reducedMotion;
  final bool largeText;
  final bool screenReaderOptimized;

  const AccessibilityState({
    this.highContrast = false,
    this.reducedMotion = false,
    this.largeText = false,
    this.screenReaderOptimized = false,
  });

  AccessibilityState copyWith({
    bool? highContrast,
    bool? reducedMotion,
    bool? largeText,
    bool? screenReaderOptimized,
  }) {
    return AccessibilityState(
      highContrast: highContrast ?? this.highContrast,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      largeText: largeText ?? this.largeText,
      screenReaderOptimized: screenReaderOptimized ?? this.screenReaderOptimized,
    );
  }

  /// Get text scale factor based on large text setting.
  double get textScaleFactor => largeText ? 1.25 : 1.0;

  /// Get animation duration multiplier based on reduced motion.
  double get animationDurationMultiplier => reducedMotion ? 0.0 : 1.0;

  /// Check if animations should be shown.
  bool get enableAnimations => !reducedMotion;
}

/// High contrast color scheme generator.
///
/// Takes a base color scheme and enhances contrast for better accessibility.
class HighContrastColors {
  /// Convert a color scheme to high contrast variant.
  static ColorScheme apply(ColorScheme base) {
    return base.copyWith(
      // Enhance primary colors
      primary: _enhanceContrast(base.primary, base.surface),
      onPrimary: _ensureMaximumContrast(base.onPrimary, base.primary),
      primaryContainer: _enhanceContrast(base.primaryContainer, base.surface),
      onPrimaryContainer: _ensureMaximumContrast(base.onPrimaryContainer, base.primaryContainer),

      // Enhance secondary colors
      secondary: _enhanceContrast(base.secondary, base.surface),
      onSecondary: _ensureMaximumContrast(base.onSecondary, base.secondary),
      secondaryContainer: _enhanceContrast(base.secondaryContainer, base.surface),
      onSecondaryContainer: _ensureMaximumContrast(base.onSecondaryContainer, base.secondaryContainer),

      // Enhance surface colors
      surface: base.surface,
      onSurface: _ensureMaximumContrast(base.onSurface, base.surface),
      onSurfaceVariant: _ensureMaximumContrast(base.onSurfaceVariant, base.surface),

      // Enhance error colors
      error: _enhanceContrast(base.error, base.surface),
      onError: _ensureMaximumContrast(base.onError, base.error),

      // Stronger outlines
      outline: _ensureMaximumContrast(base.outline, base.surface),
      outlineVariant: _ensureMaximumContrast(base.outlineVariant, base.surface),
    );
  }

  /// Enhance contrast of a color against a background.
  static Color _enhanceContrast(Color foreground, Color background) {
    final contrast = _calculateContrastRatio(foreground, background);

    if (contrast >= 7.0) {
      return foreground; // Already high contrast
    }

    // Adjust luminance to achieve better contrast
    final hsl = HSLColor.fromColor(foreground);
    final bgLuminance = _calculateLuminance(background);

    if (bgLuminance > 0.5) {
      // Dark background, darken foreground
      return hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
    } else {
      // Light background, lighten foreground
      return hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
    }
  }

  /// Ensure maximum contrast (black or white).
  static Color _ensureMaximumContrast(Color foreground, Color background) {
    final bgLuminance = _calculateLuminance(background);
    return bgLuminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Calculate relative luminance of a color.
  static double _calculateLuminance(Color color) {
    final r = _linearizeComponent(color.r);
    final g = _linearizeComponent(color.g);
    final b = _linearizeComponent(color.b);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearize RGB component for luminance calculation.
  static double _linearizeComponent(double component) {
    final c = component / 255.0;
    return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  /// Calculate contrast ratio between two colors.
  static double _calculateContrastRatio(Color color1, Color color2) {
    final lum1 = _calculateLuminance(color1);
    final lum2 = _calculateLuminance(color2);
    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;
    return (lighter + 0.05) / (darker + 0.05);
  }
}

/// Animation duration configuration for reduced motion support.
class AccessibleAnimation {
  /// Get animation duration considering reduced motion setting.
  static Duration duration(
    AccessibilityState state, {
    Duration normal = const Duration(milliseconds: 300),
    Duration reduced = const Duration(milliseconds: 0),
  }) {
    return state.reducedMotion ? reduced : normal;
  }

  /// Get curve considering reduced motion.
  static Curve curve(
    AccessibilityState state, {
    Curve normal = Curves.easeInOut,
    Curve reduced = Curves.linear,
  }) {
    return state.reducedMotion ? reduced : normal;
  }

  /// Wrap a widget with reduced motion support.
  static Widget wrap(
    AccessibilityState state, {
    required Widget child,
    required Animation<double> animation,
    Widget Function(Animation<double>, Widget) builder = _defaultBuilder,
  }) {
    if (state.reducedMotion) {
      return child;
    }
    return builder(animation, child);
  }

  static Widget _defaultBuilder(Animation<double> animation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

/// Accessible focus decoration for keyboard navigation.
class AccessibleFocus extends StatelessWidget {
  final Widget child;
  final Color? focusColor;
  final double borderRadius;

  const AccessibleFocus({
    super.key,
    required this.child,
    this.focusColor,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: child,
      onKeyEvent: (node, event) {
        // Handle keyboard navigation
        return KeyEventResult.ignored;
      },
      onFocusChange: (hasFocus) {
        // Handle focus change
      },
    );
  }
}

/// Semantic wrapper for better screen reader support.
class AccessibleSemantics extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? hint;
  final String? value;
  final String? increasedValue;
  final String? decreasedValue;
  final bool header;
  final TextDirection? textDirection;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AccessibleSemantics({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.increasedValue,
    this.decreasedValue,
    this.header = false,
    this.textDirection,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      increasedValue: increasedValue,
      decreasedValue: decreasedValue,
      header: header,
      textDirection: textDirection,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}
