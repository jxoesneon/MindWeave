import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Environment Card Molecule
///
/// Small card showing a sound environment option (Ocean Deep, Night Forest, etc.)
/// Matches Stitch design: 2x2 grid in the right panel.
///
/// Usage:
/// ```dart
/// EnvironmentCard(
///   icon: Icons.water,
///   label: 'Ocean Deep',
///   isSelected: true,
///   onTap: () {},
/// )
/// ```
class EnvironmentCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const EnvironmentCard({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadiusTokens.mdCircular,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.sm,
            vertical: SpacingTokens.md,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryContainer.withAlpha(76)
                : AppColors.surfaceContainerHigh,
            borderRadius: BorderRadiusTokens.mdCircular,
            border: isSelected
                ? Border.all(color: AppColors.primary.withAlpha(128), width: 1)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
                size: 28,
              ),
              const SizedBox(height: SpacingTokens.xs),
              Text(
                label,
                style: TypographyTokens.labelSmall.copyWith(
                  color: isSelected
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
