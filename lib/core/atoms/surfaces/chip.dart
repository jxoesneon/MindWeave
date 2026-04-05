import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Chip Atom
///
/// Pill-shaped tag/chip for filtering, categories, tags.
/// Follows Stitch design with tonal background.
///
/// Usage:
/// ```dart
/// MwChip(
///   label: 'Meditation',
///   isSelected: true,
///   onTap: () {},
/// )
/// ```text
class MwChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool showCheckmark;

  const MwChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.showCheckmark = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? AppColors.primaryContainer.withAlpha(76)
        : AppColors.surfaceContainer;

    final fgColor = isSelected ? AppColors.primary : AppColors.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadiusTokens.fullCircular,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.sm,
            vertical: SpacingTokens.xs,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadiusTokens.fullCircular,
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected && showCheckmark) ...[
                Icon(Icons.check, size: 16, color: fgColor),
                const SizedBox(width: SpacingTokens.xxs),
              ] else if (icon != null) ...[
                Icon(icon, size: 16, color: fgColor),
                const SizedBox(width: SpacingTokens.xxs),
              ],
              Text(
                label,
                style: TypographyTokens.labelMedium.copyWith(color: fgColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
