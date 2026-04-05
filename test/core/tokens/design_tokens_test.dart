import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/tokens/spacing_tokens.dart';
import 'package:mindweave/core/tokens/border_radius_tokens.dart';
import 'package:mindweave/core/tokens/shadow_tokens.dart';
import 'package:mindweave/core/tokens/animation_tokens.dart';
import 'package:mindweave/core/tokens/typography_tokens.dart';
import 'package:mindweave/core/tokens/component_types.dart';

void main() {
  group('Design Tokens', () {
    group('SpacingTokens', () {
      test('should have correct base values', () {
        expect(SpacingTokens.xxs, equals(4));
        expect(SpacingTokens.xs, equals(8));
        expect(SpacingTokens.sm, equals(12));
        expect(SpacingTokens.md, equals(16));
        expect(SpacingTokens.lg, equals(24));
        expect(SpacingTokens.xl, equals(32));
        expect(SpacingTokens.xxl, equals(40));
        expect(SpacingTokens.xxxl, equals(48));
      });

      test('should follow 8dp grid with 4dp micro-adjustments', () {
        // All values should be multiples of 4
        const values = [
          SpacingTokens.xxs,
          SpacingTokens.xs,
          SpacingTokens.sm,
          SpacingTokens.md,
          SpacingTokens.lg,
          SpacingTokens.xl,
          SpacingTokens.xxl,
          SpacingTokens.xxxl,
          SpacingTokens.huge,
        ];
        for (final value in values) {
          expect(
            value % 4,
            equals(0),
            reason: 'Value $value is not divisible by 4',
          );
        }
      });

      test('should provide minimum touch target of 44pt', () {
        expect(SpacingTokens.minTouchTarget, greaterThanOrEqualTo(44.0));
      });

      test('should provide correct EdgeInsets helpers', () {
        final cardPadding = SpacingTokens.cardPadding;
        expect(cardPadding.left, equals(16));
        expect(cardPadding.right, equals(16));
        expect(cardPadding.top, equals(16));
        expect(cardPadding.bottom, equals(16));

        final buttonPadding = SpacingTokens.buttonPadding;
        expect(buttonPadding.left, equals(24));
        expect(buttonPadding.right, equals(24));
        expect(buttonPadding.top, equals(12));
        expect(buttonPadding.bottom, equals(12));

        final listItemPadding = SpacingTokens.listItemPadding;
        expect(listItemPadding.left, equals(16));
        expect(listItemPadding.right, equals(16));
        expect(listItemPadding.top, equals(12));
        expect(listItemPadding.bottom, equals(12));
      });

      test('should provide correct screen edge insets', () {
        expect(
          SpacingTokens.screenPaddingMobile.horizontal,
          equals(64),
        ); // 32*2
        expect(
          SpacingTokens.screenPaddingTablet.horizontal,
          equals(80),
        ); // 40*2
        expect(
          SpacingTokens.screenPaddingDesktop.horizontal,
          equals(96),
        ); // 48*2
      });
    });

    group('BorderRadiusTokens', () {
      test('should have increasing radius values', () {
        expect(BorderRadiusTokens.xs, lessThan(BorderRadiusTokens.sm));
        expect(BorderRadiusTokens.sm, lessThan(BorderRadiusTokens.md));
        expect(BorderRadiusTokens.md, lessThan(BorderRadiusTokens.lg));
        expect(BorderRadiusTokens.lg, lessThan(BorderRadiusTokens.xl));
        expect(BorderRadiusTokens.xl, lessThan(BorderRadiusTokens.full));
      });

      test('should provide correct BorderRadius presets', () {
        // Verify circular presets are created correctly
        expect(BorderRadiusTokens.xsCircular, isA<BorderRadius>());
        expect(BorderRadiusTokens.smCircular, isA<BorderRadius>());
        expect(BorderRadiusTokens.mdCircular, isA<BorderRadius>());
        expect(BorderRadiusTokens.lgCircular, isA<BorderRadius>());
        expect(BorderRadiusTokens.xlCircular, isA<BorderRadius>());
        expect(BorderRadiusTokens.fullCircular, isA<BorderRadius>());
      });

      test('card preset should use lg radius', () {
        expect(BorderRadiusTokens.card, equals(BorderRadiusTokens.lgCircular));
      });

      test('button preset should use full pill shape', () {
        expect(
          BorderRadiusTokens.button,
          equals(BorderRadiusTokens.fullCircular),
        );
      });

      test('input preset should use md radius', () {
        expect(BorderRadiusTokens.input, equals(BorderRadiusTokens.mdCircular));
      });
    });

    group('ShadowTokens', () {
      test('should provide card rest shadows', () {
        expect(ShadowTokens.cardRest, isNotEmpty);
        // ignore: deprecated_member_use
        expect(ShadowTokens.cardRest.first.color.opacity, greaterThan(0));
      });

      test('should provide card hover shadows', () {
        expect(ShadowTokens.cardHover, isNotEmpty);
      });

      test('should provide button glow shadows', () {
        expect(ShadowTokens.buttonGlow, isNotEmpty);
        // ignore: deprecated_member_use
        expect(ShadowTokens.buttonGlow.first.color.opacity, greaterThan(0));
      });

      test('should provide secondary glow shadows', () {
        expect(ShadowTokens.secondaryGlow, isNotEmpty);
      });

      test('should provide glass container shadows', () {
        expect(ShadowTokens.glassShadow, isNotEmpty);
      });

      test('should provide modal/dialog shadows', () {
        expect(ShadowTokens.modalShadow, isNotEmpty);
      });

      test('should provide bottom sheet shadows', () {
        expect(ShadowTokens.sheetShadow, isNotEmpty);
      });

      test('card rest should have smaller blur than hover', () {
        expect(
          ShadowTokens.cardRest.first.blurRadius,
          lessThan(ShadowTokens.cardHover.first.blurRadius),
        );
      });
    });

    group('AnimationTokens', () {
      test('should have fast duration <= 150ms', () {
        expect(AnimationTokens.fast.inMilliseconds, lessThanOrEqualTo(150));
      });

      test('should have medium duration between 200-300ms', () {
        expect(
          AnimationTokens.medium.inMilliseconds,
          greaterThanOrEqualTo(200),
        );
        expect(AnimationTokens.medium.inMilliseconds, lessThanOrEqualTo(300));
      });

      test('should have slow duration <= 400ms', () {
        expect(AnimationTokens.slow.inMilliseconds, lessThanOrEqualTo(400));
      });

      test('should have standard easing curve', () {
        expect(AnimationTokens.standardCurve, isA<Cubic>());
      });

      test('should have enter/exit curves', () {
        expect(AnimationTokens.enterCurve, isA<Cubic>());
        expect(AnimationTokens.exitCurve, isA<Cubic>());
      });

      test('should have shimmer pulse duration for loading states', () {
        expect(AnimationTokens.shimmerPulse.inMilliseconds, greaterThan(0));
      });
    });

    group('TypographyTokens', () {
      test('should provide display styles', () {
        expect(TypographyTokens.displayLarge.fontSize, equals(57));
        expect(TypographyTokens.displayMedium.fontSize, equals(45));
        expect(TypographyTokens.displaySmall.fontSize, equals(36));
      });

      test('should provide headline styles', () {
        expect(TypographyTokens.headlineLarge.fontSize, equals(32));
        expect(TypographyTokens.headlineMedium.fontSize, equals(28));
        expect(TypographyTokens.headlineSmall.fontSize, equals(24));
      });

      test('should provide body styles', () {
        expect(TypographyTokens.bodyLarge.fontSize, equals(16));
        expect(TypographyTokens.bodyMedium.fontSize, equals(14));
        expect(TypographyTokens.bodySmall.fontSize, equals(12));
      });

      test('should provide label styles', () {
        expect(TypographyTokens.labelLarge.fontSize, equals(14));
        expect(TypographyTokens.labelMedium.fontSize, equals(12));
        expect(TypographyTokens.labelSmall.fontSize, equals(11));
      });

      test('should have letter spacing for display styles', () {
        expect(TypographyTokens.displayLarge.letterSpacing, equals(-0.25));
      });

      test('button style should have correct properties', () {
        expect(TypographyTokens.button.fontSize, equals(14));
        expect(TypographyTokens.button.fontWeight, equals(FontWeight.w600));
        expect(TypographyTokens.button.letterSpacing, equals(0.1));
      });
    });

    group('ComponentTypes', () {
      test('ButtonSize should have three variants', () {
        expect(ButtonSize.values.length, equals(3));
        expect(ButtonSize.values, contains(ButtonSize.small));
        expect(ButtonSize.values, contains(ButtonSize.medium));
        expect(ButtonSize.values, contains(ButtonSize.large));
      });

      test('BadgeSize should have three variants', () {
        expect(BadgeSize.values.length, equals(3));
        expect(BadgeSize.values, contains(BadgeSize.small));
        expect(BadgeSize.values, contains(BadgeSize.medium));
        expect(BadgeSize.values, contains(BadgeSize.large));
      });

      test('TonalLevel should have five hierarchy levels', () {
        expect(TonalLevel.values.length, equals(5));
        expect(TonalLevel.values, contains(TonalLevel.surfaceContainerLowest));
        expect(TonalLevel.values, contains(TonalLevel.surfaceContainerLow));
        expect(TonalLevel.values, contains(TonalLevel.surfaceContainer));
        expect(TonalLevel.values, contains(TonalLevel.surfaceContainerHigh));
        expect(TonalLevel.values, contains(TonalLevel.surfaceContainerHighest));
      });

      test('TonalLevelColor extension should return valid colors', () {
        for (final level in TonalLevel.values) {
          expect(level.color, isA<Color>());
          // ignore: deprecated_member_use
          expect(level.color.alpha, equals(255));
        }
      });
    });
  });
}
