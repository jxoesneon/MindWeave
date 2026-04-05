import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../atoms/atoms.dart';

/// Bottom Navigation Bar Organism
///
/// Responsive navigation bar with 4-5 items for mobile.
/// Uses glass-morphism effect and smooth transitions.
///
/// Usage:
/// ```dart
/// BottomNavBar(
///   currentIndex: 0,
///   onTap: (index) {},
///   items: [
///     NavItem(icon: Icons.home, label: 'Home'),
///     NavItem(icon: Icons.library_music, label: 'Library'),
///     NavItem(icon: Icons.explore, label: 'Explore'),
///     NavItem(icon: Icons.person, label: 'Profile'),
///   ],
/// )
/// ```text
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<NavItem> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withAlpha(242),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withAlpha(76),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: _NavBarItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => onTap?.call(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadiusTokens.mdCircular,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: AnimationTokens.fast,
              padding: const EdgeInsets.all(SpacingTokens.xs),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer.withAlpha(76)
                    : Colors.transparent,
                borderRadius: BorderRadiusTokens.mdCircular,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: SpacingTokens.xxs),
            Text(
              label,
              style: TypographyTokens.labelSmall.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation item definition
class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}

/// Desktop Sidebar Navigation Organism
///
/// Collapsible sidebar for desktop navigation with 280px expanded
/// and 72px collapsed states.
///
/// Usage:
/// ```dart
/// SidebarNavigation(
///   currentIndex: 0,
///   onTap: (index) {},
///   isCollapsed: false,
///   items: [...],
/// )
/// ```text
class SidebarNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool isCollapsed;
  final List<NavItem> items;
  final VoidCallback? onToggleCollapse;

  const SidebarNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.isCollapsed = false,
    required this.items,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final width = isCollapsed ? 72.0 : 280.0;

    return AnimatedContainer(
      duration: AnimationTokens.medium,
      curve: AnimationTokens.standardCurve,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(
          right: BorderSide(
            color: AppColors.outlineVariant.withAlpha(76),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header with collapse toggle
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
            child: Row(
              children: [
                if (!isCollapsed) ...[
                  Expanded(
                    child: Text(
                      'MindWeave',
                      style: TypographyTokens.titleLarge.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ],
                MwIconButton(
                  onPressed: onToggleCollapse,
                  icon: isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                  tooltip: isCollapsed ? 'Expand' : 'Collapse',
                ),
              ],
            ),
          ),
          // Preset subtitle (Stitch: "Celestial Echo / DEEP FREQUENCY MODE")
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.md,
                vertical: SpacingTokens.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Celestial Echo',
                    style: TypographyTokens.titleSmall.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    'DEEP FREQUENCY MODE',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: SpacingTokens.sm),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == currentIndex;

                return _SidebarItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  isCollapsed: isCollapsed,
                  onTap: () => onTap?.call(index),
                );
              },
            ),
          ),
          // Start Session button (Stitch design)
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: SizedBox(
                width: double.infinity,
                child: MwPrimaryButton(
                  label: 'Start Session',
                  onPressed: () {
                    // Navigate to Sanctuary tab (index 1)
                    onTap?.call(1);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.isCollapsed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.onSurfaceVariant;

    Widget item = Container(
      height: 48,
      margin: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.sm,
        vertical: SpacingTokens.xxs,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryContainer.withAlpha(76)
            : Colors.transparent,
        borderRadius: BorderRadiusTokens.mdCircular,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadiusTokens.mdCircular,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              if (!isCollapsed) ...[
                const SizedBox(width: SpacingTokens.md),
                Expanded(
                  child: Text(
                    label,
                    style: TypographyTokens.labelLarge.copyWith(
                      color: color,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return item;
  }
}
