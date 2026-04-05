import 'package:flutter/material.dart';

/// MindWeave Animation & Motion Tokens
///
/// Consistent animation timing and easing curves following ui-ux-pro-max guidelines:
/// - Micro-interactions: 150-300ms
/// - Complex transitions: ≤400ms
/// - Avoid >500ms
/// - Use spring physics for natural feel
///
/// Usage:
/// ```dart
/// duration: AnimationTokens.fast,
/// curve: AnimationTokens.standardCurve,
/// ```text
class AnimationTokens {
  AnimationTokens._();

  // Duration tokens (in milliseconds)

  /// Instant (0ms) - For immediate state changes, no animation
  static const Duration instant = Duration.zero;

  /// Micro (100ms) - For subtle feedback like opacity changes
  static const Duration micro = Duration(milliseconds: 100);

  /// Fast (150ms) - For hover states, color transitions, micro-interactions
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal (200ms) - Standard for most UI animations (button presses, toggles)
  static const Duration normal = Duration(milliseconds: 200);

  /// Medium (250ms) - For larger elements, card transitions
  static const Duration medium = Duration(milliseconds: 250);

  /// Slow (300ms) - For complex transitions, page transitions
  static const Duration slow = Duration(milliseconds: 300);

  /// Complex (400ms) - Maximum for complex sequences (modals, sheets)
  static const Duration complex = Duration(milliseconds: 400);

  // Easing curves (following Material Design and Apple HIG)

  /// Standard curve - For most animations (ease-in-out)
  /// Enter: ease-out, Exit: ease-in
  static const Curve standardCurve = Curves.easeInOut;

  /// Decelerate - For elements entering the screen (ease-out)
  static const Curve enterCurve = Curves.easeOut;

  /// Accelerate - For elements exiting the screen (ease-in)
  /// Exit animations should be shorter (~60-70% of enter)
  static const Curve exitCurve = Curves.easeIn;

  /// Emphasized - For important transitions (Material 3)
  static const Curve emphasizedCurve = Curves.easeInOutCubic;

  /// Spring-like - For bouncy, playful interactions
  static const Curve springCurve = Curves.elasticOut;

  /// Sharp - For quick, decisive transitions
  static const Curve sharpCurve = Curves.easeInOutQuart;

  // Stagger delays (for list/grid item entrance)

  /// Per-item delay for staggered animations
  /// Stagger list items by 30-50ms per item (ui-ux-pro-max)
  static const Duration staggerDelay = Duration(milliseconds: 40);

  /// Maximum stagger duration (avoid too slow reveals)
  static const Duration maxStagger = Duration(milliseconds: 600);

  // Page transition durations

  /// Page transition (forward navigation)
  static const Duration pageTransitionEnter = Duration(milliseconds: 300);

  /// Page transition (backward navigation) - shorter for responsiveness
  static const Duration pageTransitionExit = Duration(milliseconds: 200);

  // Modal/Sheet animations

  /// Bottom sheet enter
  static const Duration sheetEnter = Duration(milliseconds: 300);

  /// Bottom sheet exit
  static const Duration sheetExit = Duration(milliseconds: 200);

  /// Dialog enter
  static const Duration dialogEnter = Duration(milliseconds: 250);

  /// Dialog exit
  static const Duration dialogExit = Duration(milliseconds: 150);

  // Card/Container animations

  /// Card hover scale
  static const Duration cardHover = Duration(milliseconds: 200);

  /// Card selection toggle
  static const Duration cardSelection = Duration(milliseconds: 150);

  /// Shadow/glow transitions
  static const Duration shadowTransition = Duration(milliseconds: 200);

  // Button animations

  /// Button press feedback
  static const Duration buttonPress = Duration(milliseconds: 100);

  /// Button release
  static const Duration buttonRelease = Duration(milliseconds: 150);

  // Loading states

  /// Skeleton/shimmer pulse
  static const Duration shimmerPulse = Duration(milliseconds: 1500);

  /// Progress indicator
  static const Duration progressIndeterminate = Duration(milliseconds: 2000);

  /// Loading state transition (show/hide)
  static const Duration loadingTransition = Duration(milliseconds: 300);

  // Helper methods

  /// Calculate stagger duration for a list of items
  static Duration calculateStagger(int itemCount) {
    final calculated = Duration(milliseconds: 40 * itemCount);
    return calculated > maxStagger ? maxStagger : calculated;
  }

  /// Create animation controller with standard duration
  static AnimationController createController(TickerProvider vsync) {
    return AnimationController(vsync: vsync, duration: normal);
  }
}
