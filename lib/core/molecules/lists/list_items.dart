import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';

/// List Item Molecule
///
/// Standard list item with icon, title, subtitle, and optional trailing action.
/// Used in settings, menus, and data lists.
///
/// Usage:
/// ```dart
/// ListItem(
///   icon: Icons.settings,
///   title: 'Settings',
///   subtitle: 'App preferences',
///   onTap: () {},
/// )
/// ```text
class ListItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isSelected;

  const ListItem({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? AppColors.error : AppColors.onSurface;
    final subtitleColor = AppColors.onSurfaceVariant;
    final iconColor = isDestructive
        ? AppColors.error
        : isSelected
        ? AppColors.primary
        : AppColors.onSurfaceVariant;

    Widget content = Padding(
      padding: SpacingTokens.listItemPadding,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: SpacingTokens.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TypographyTokens.bodyLarge.copyWith(color: titleColor),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: SpacingTokens.xxs),
                  Text(
                    subtitle!,
                    style: TypographyTokens.bodyMedium.copyWith(
                      color: subtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: SpacingTokens.sm),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadiusTokens.smCircular,
        child: content,
      );
    }

    return content;
  }
}

/// Stat Card Molecule
///
/// Compact card for displaying statistics or metrics with value and label.
///
/// Usage:
/// ```dart
/// StatCard(
///   value: '24h',
///   label: 'Total Sessions',
///   icon: Icons.timer,
/// )
/// ```text
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? accentColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;

    Widget card = Container(
      padding: SpacingTokens.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadiusTokens.card,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withAlpha(51),
                borderRadius: BorderRadiusTokens.smCircular,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: SpacingTokens.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TypographyTokens.headlineSmall.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xxs),
                Text(
                  label,
                  style: TypographyTokens.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      card = ClipRRect(
        borderRadius: BorderRadiusTokens.card,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadiusTokens.card,
          child: card,
        ),
      );
    }

    return card;
  }
}
