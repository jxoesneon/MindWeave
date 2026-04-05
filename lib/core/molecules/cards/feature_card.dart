import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../tokens/shadow_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Feature Card Molecule
///
/// Card for displaying educational content about frequencies, features,
/// or other informational content with icon, title, and description.
///
/// Usage:
/// ```dart
/// FeatureCard(
///   title: 'Binaural Beats',
///   description: 'Two slightly different frequencies...',
///   icon: Icons.headphones,
///   onTap: () {},
/// )
/// ```text
class FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? accentColor;
  final VoidCallback? onTap;
  final bool isCompact;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.accentColor,
    this.onTap,
    this.isCompact = false,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? AppColors.primary;
    final padding = widget.isCompact
        ? const EdgeInsets.all(SpacingTokens.md)
        : SpacingTokens.cardPadding;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AnimationTokens.fast,
        curve: AnimationTokens.standardCurve,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadiusTokens.card,
          boxShadow: _isHovered
              ? ShadowTokens.cardHover
              : ShadowTokens.cardRest,
        ),
        child: ClipRRect(
          borderRadius: BorderRadiusTokens.card,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadiusTokens.card,
              child: Padding(
                padding: padding,
                child: widget.isCompact
                    ? _buildCompactLayout(color)
                    : _buildFullLayout(color),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullLayout(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withAlpha(51),
            borderRadius: BorderRadiusTokens.mdCircular,
          ),
          child: Icon(widget.icon, color: color, size: 28),
        ),
        const SizedBox(height: SpacingTokens.md),
        Text(
          widget.title,
          style: TypographyTokens.titleSmall.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: SpacingTokens.xs),
        Text(
          widget.description,
          style: TypographyTokens.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCompactLayout(Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withAlpha(51),
            borderRadius: BorderRadiusTokens.smCircular,
          ),
          child: Icon(widget.icon, color: color, size: 20),
        ),
        const SizedBox(width: SpacingTokens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TypographyTokens.labelLarge.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SpacingTokens.xxs),
              Text(
                widget.description,
                style: TypographyTokens.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.onSurfaceVariant,
          size: 16,
        ),
      ],
    );
  }
}
