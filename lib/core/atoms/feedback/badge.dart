import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../tokens/component_types.dart';

/// Badge Atom
///
/// Small status indicator for counts, notifications, status.
/// Follows Stitch design with tonal background.
///
/// Usage:
/// ```dart
/// MwBadge(
///   label: '3',
///   color: AppColors.primary,
/// )
/// ```text
class MwBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final BadgeSize size;
  final bool isPill;

  const MwBadge({
    super.key,
    required this.label,
    this.color,
    this.size = BadgeSize.small,
    this.isPill = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? AppColors.primary;
    final fgColor = _getContrastColor(bgColor);

    final padding = switch (size) {
      BadgeSize.small => const EdgeInsets.symmetric(
        horizontal: SpacingTokens.xs,
        vertical: 2,
      ),
      BadgeSize.medium => const EdgeInsets.symmetric(
        horizontal: SpacingTokens.sm,
        vertical: SpacingTokens.xxs,
      ),
      BadgeSize.large => const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.xs,
      ),
    };

    final fontSize = switch (size) {
      BadgeSize.small => 10.0,
      BadgeSize.medium => 12.0,
      BadgeSize.large => 14.0,
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: isPill
            ? BorderRadiusTokens.fullCircular
            : BorderRadiusTokens.smCircular,
      ),
      child: Text(
        label,
        style: TypographyTokens.labelMedium.copyWith(
          fontSize: fontSize,
          color: fgColor,
        ),
      ),
    );
  }

  Color _getContrastColor(Color background) {
    // Calculate luminance to determine if we need dark or light text
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? AppColors.background : AppColors.onSurface;
  }
}
