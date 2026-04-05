import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../molecules/cards/environment_card.dart';
import '../../molecules/cards/preset_card.dart';
import '../../molecules/badges/band_badge.dart';
import '../../models/brainwave_preset.dart';

/// Desktop Sanctuary Panel Organism
///
/// Right-hand panel for the desktop Sanctuary/Player view.
/// Matches Stitch design: 21_desktop_player_dashboard.png
///
/// Contains:
/// - Environment grid (2x2 sound environments)
/// - Frequency band chips
/// - Favorite Nodes section
/// - "Become a Mindweaver" CTA
class DesktopSanctuaryPanel extends StatelessWidget {
  final String? selectedEnvironment;
  final BrainwaveBand? selectedBand;
  final ValueChanged<String>? onEnvironmentChanged;
  final ValueChanged<BrainwaveBand>? onBandChanged;
  final VoidCallback? onViewAllNodes;

  const DesktopSanctuaryPanel({
    super.key,
    this.selectedEnvironment,
    this.selectedBand,
    this.onEnvironmentChanged,
    this.onBandChanged,
    this.onViewAllNodes,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Environment section
          Text(
            'Environment',
            style: TypographyTokens.titleMedium.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          _buildEnvironmentGrid(),
          const SizedBox(height: SpacingTokens.lg),

          // Frequencies section
          Text(
            'FREQUENCIES',
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          _buildFrequencyChips(),
          const SizedBox(height: SpacingTokens.lg),

          // Favorite Nodes section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Favorite Nodes',
                style: TypographyTokens.titleMedium.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              GestureDetector(
                onTap: onViewAllNodes,
                child: Text(
                  'View All',
                  style: TypographyTokens.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.sm),
          _buildFavoriteNodes(),
          const SizedBox(height: SpacingTokens.lg),

          // Become a Mindweaver CTA
          _buildMindweaverCta(),
        ],
      ),
    );
  }

  Widget _buildEnvironmentGrid() {
    const environments = [
      _EnvData(Icons.water_drop, 'Ocean Deep', 'ocean'),
      _EnvData(Icons.park, 'Night Forest', 'forest'),
      _EnvData(Icons.auto_awesome, 'White Noise', 'white_noise'),
      _EnvData(Icons.thunderstorm, 'Heavy Rain', 'rain'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: SpacingTokens.sm,
      crossAxisSpacing: SpacingTokens.sm,
      childAspectRatio: 1.3,
      children: environments.map((env) {
        return EnvironmentCard(
          icon: env.icon,
          label: env.label,
          isSelected: selectedEnvironment == env.id,
          onTap: () => onEnvironmentChanged?.call(env.id),
        );
      }).toList(),
    );
  }

  Widget _buildFrequencyChips() {
    return Wrap(
      spacing: SpacingTokens.xs,
      runSpacing: SpacingTokens.xs,
      children: BrainwaveBand.values.where((b) => b != BrainwaveBand.gamma).map(
        (band) {
          return BandBadge(
            band: band,
            isActive: selectedBand == band,
            showFrequency: false,
            onTap: () => onBandChanged?.call(band),
          );
        },
      ).toList(),
    );
  }

  Widget _buildFavoriteNodes() {
    return Column(
      children: [
        PresetCard(
          title: 'Cosmic Anchor',
          description: '12 Hz Alpha • Rain • 45m',
          icon: Icons.anchor,
          iconColor: BrainwaveBand.alpha.color,
          isFavorite: true,
          onTap: () {},
          onFavoriteTap: () {},
        ),
        const SizedBox(height: SpacingTokens.sm),
        PresetCard(
          title: 'Morning Mist',
          description: '8 Hz Theta • Forest • 30m',
          icon: Icons.cloud,
          iconColor: BrainwaveBand.theta.color,
          isFavorite: true,
          onTap: () {},
          onFavoriteTap: () {},
        ),
      ],
    );
  }

  Widget _buildMindweaverCta() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadiusTokens.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Become a Mindweaver',
            style: TypographyTokens.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Unlock all frequencies and environments',
            style: TypographyTokens.bodySmall.copyWith(
              color: Colors.white.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnvData {
  final IconData icon;
  final String label;
  final String id;
  const _EnvData(this.icon, this.label, this.id);
}
