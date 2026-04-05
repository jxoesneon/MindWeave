import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../tokens/shadow_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../atoms/atoms.dart';

/// Preset Card Molecule
///
/// Card displaying a brainwave preset with icon, title, description,
/// and optional favorite/overflow actions.
///
/// Usage:
/// ```dart
/// PresetCard(
///   title: 'Focus',
///   description: '40Hz gamma for concentration',
///   icon: Icons.bolt,
///   isFavorite: true,
///   onTap: () {},
///   onFavoriteTap: () {},
/// )
/// ```text
class PresetCard extends StatefulWidget {
  final String title;
  final String? description;
  final IconData icon;
  final Color? iconColor;
  final bool isFavorite;
  final bool isPublic;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onMoreTap;
  final bool showGlow;

  const PresetCard({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.iconColor,
    this.isFavorite = false,
    this.isPublic = false,
    this.onTap,
    this.onFavoriteTap,
    this.onMoreTap,
    this.showGlow = false,
  });

  @override
  State<PresetCard> createState() => _PresetCardState();
}

class _PresetCardState extends State<PresetCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationTokens.fast,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasGlow = widget.showGlow || _isHovered;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AnimationTokens.fast,
          curve: AnimationTokens.standardCurve,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadiusTokens.card,
            boxShadow: hasGlow ? ShadowTokens.cardHover : ShadowTokens.cardRest,
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusTokens.card,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadiusTokens.card,
                child: Padding(
                  padding: SpacingTokens.cardPadding,
                  child: Row(
                    children: [
                      // Icon container
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (widget.iconColor ?? AppColors.primary)
                              .withAlpha(51),
                          borderRadius: BorderRadiusTokens.mdCircular,
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor ?? AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.md),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: TypographyTokens.titleSmall.copyWith(
                                color: AppColors.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.description != null) ...[
                              const SizedBox(height: SpacingTokens.xxs),
                              Text(
                                widget.description!,
                                style: TypographyTokens.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Actions
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.onFavoriteTap != null)
                            MwIconButton(
                              onPressed: widget.onFavoriteTap,
                              icon: widget.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              selectedIcon: Icons.favorite,
                              isSelected: widget.isFavorite,
                              color: widget.isFavorite
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                              size: 20,
                            ),
                          if (widget.onMoreTap != null)
                            MwIconButton(
                              onPressed: widget.onMoreTap,
                              icon: Icons.more_vert,
                              color: AppColors.onSurfaceVariant,
                              size: 20,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
