import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../atoms/atoms.dart';

/// Desktop Top Navigation Bar Organism
///
/// Full-width horizontal bar at the top of the desktop layout.
/// Matches Stitch design: MindWeave logo, section tabs, settings + Profile button.
///
/// Usage:
/// ```dart
/// DesktopTopBar(
///   currentSection: 'Sanctuary',
///   onSectionChanged: (section) {},
///   onProfileTap: () {},
/// )
/// ```
class DesktopTopBar extends StatelessWidget {
  final String currentSection;
  final ValueChanged<String>? onSectionChanged;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;

  static const sections = ['Library', 'Sanctuary', 'Community'];

  const DesktopTopBar({
    super.key,
    this.currentSection = 'Sanctuary',
    this.onSectionChanged,
    this.onSettingsTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withAlpha(38),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // MindWeave logo
          Text(
            'MindWeave',
            style: TypographyTokens.titleLarge.copyWith(
              color: AppColors.onSurface,
              fontFamily: TypographyTokens.displayFont,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: SpacingTokens.xxl),
          // Section tabs
          ...sections.map((section) {
            final isActive = section == currentSection;
            return Padding(
              padding: const EdgeInsets.only(right: SpacingTokens.lg),
              child: _TopBarTab(
                label: section,
                isActive: isActive,
                onTap: () => onSectionChanged?.call(section),
              ),
            );
          }),
          const Spacer(),
          // Settings icon
          MwIconButton(
            onPressed: onSettingsTap,
            icon: Icons.settings_outlined,
            size: 20,
            color: AppColors.onSurfaceVariant,
            tooltip: 'Settings',
          ),
          const SizedBox(width: SpacingTokens.xs),
          // Profile button
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.md,
                vertical: SpacingTokens.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withAlpha(76),
                borderRadius: BorderRadiusTokens.fullCircular,
                border: Border.all(
                  color: AppColors.primary.withAlpha(102),
                  width: 1,
                ),
              ),
              child: Text(
                'Profile',
                style: TypographyTokens.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _TopBarTab({
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          label,
          style: TypographyTokens.labelLarge.copyWith(
            color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
