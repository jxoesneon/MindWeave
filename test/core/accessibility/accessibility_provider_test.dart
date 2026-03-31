import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/accessibility/accessibility_provider.dart';

void main() {
  group('AccessibilityState Tests', () {
    test('default state has all features disabled', () {
      const state = AccessibilityState();

      expect(state.highContrast, false);
      expect(state.reducedMotion, false);
      expect(state.largeText, false);
      expect(state.screenReaderOptimized, false);
    });

    test('copyWith updates values correctly', () {
      const state = AccessibilityState();

      final updated = state.copyWith(highContrast: true, reducedMotion: true);

      expect(updated.highContrast, true);
      expect(updated.reducedMotion, true);
      expect(updated.largeText, false); // unchanged
      expect(updated.screenReaderOptimized, false); // unchanged
    });

    test('textScaleFactor returns 1.25 when largeText is true', () {
      const state = AccessibilityState(largeText: true);
      expect(state.textScaleFactor, 1.25);
    });

    test('textScaleFactor returns 1.0 when largeText is false', () {
      const state = AccessibilityState(largeText: false);
      expect(state.textScaleFactor, 1.0);
    });

    test(
      'animationDurationMultiplier returns 0.0 when reducedMotion is true',
      () {
        const state = AccessibilityState(reducedMotion: true);
        expect(state.animationDurationMultiplier, 0.0);
      },
    );

    test(
      'animationDurationMultiplier returns 1.0 when reducedMotion is false',
      () {
        const state = AccessibilityState(reducedMotion: false);
        expect(state.animationDurationMultiplier, 1.0);
      },
    );

    test('enableAnimations returns false when reducedMotion is true', () {
      const state = AccessibilityState(reducedMotion: true);
      expect(state.enableAnimations, false);
    });

    test('enableAnimations returns true when reducedMotion is false', () {
      const state = AccessibilityState(reducedMotion: false);
      expect(state.enableAnimations, true);
    });
  });

  group('HighContrastColors Tests', () {
    test('apply returns ColorScheme with enhanced contrast', () {
      final baseScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF7B68EE),
        brightness: Brightness.dark,
      );

      final highContrast = HighContrastColors.apply(baseScheme);

      expect(highContrast, isNotNull);
      expect(highContrast.primary, isNotNull);
      expect(highContrast.onPrimary, isNotNull);
    });
  });

  group('AccessibleAnimation Tests', () {
    test('duration returns reduced duration when reducedMotion is true', () {
      const state = AccessibilityState(reducedMotion: true);
      const normal = Duration(milliseconds: 300);
      const reduced = Duration(milliseconds: 0);

      final result = AccessibleAnimation.duration(
        state,
        normal: normal,
        reduced: reduced,
      );

      expect(result, reduced);
    });

    test('duration returns normal duration when reducedMotion is false', () {
      const state = AccessibilityState(reducedMotion: false);
      const normal = Duration(milliseconds: 300);
      const reduced = Duration(milliseconds: 0);

      final result = AccessibleAnimation.duration(
        state,
        normal: normal,
        reduced: reduced,
      );

      expect(result, normal);
    });

    test('curve returns reduced curve when reducedMotion is true', () {
      const state = AccessibilityState(reducedMotion: true);

      final result = AccessibleAnimation.curve(state);

      expect(result, Curves.linear);
    });

    test('curve returns normal curve when reducedMotion is false', () {
      const state = AccessibilityState(reducedMotion: false);

      final result = AccessibleAnimation.curve(state);

      expect(result, Curves.easeInOut);
    });
  });
}
