import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/brainwave_preset.dart';
import '../../core/models/user_preset.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/tokens/shadow_tokens.dart';
import '../../core/atoms/atoms.dart';
import 'community_presets_controller.dart';

/// Community Hub Screen
///
/// Matches Stitch design: 32_Comunity_Hub.png
///
/// Features:
/// - Header with Community title, search bar, Create Preset button
/// - Filter chips: All, Delta, Theta, Alpha, Beta, Gamma, Newest
/// - Stats cards: Shared Presets, Active Users, New This Week
/// - Grid of community preset cards with user avatars and likes
class CommunityPresetsScreen extends ConsumerStatefulWidget {
  const CommunityPresetsScreen({super.key});

  @override
  ConsumerState<CommunityPresetsScreen> createState() =>
      _CommunityPresetsScreenState();
}

class _CommunityPresetsScreenState
    extends ConsumerState<CommunityPresetsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Delta',
    'Theta',
    'Alpha',
    'Beta',
    'Gamma',
    'Newest',
  ];

  @override
  Widget build(BuildContext context) {
    final communityPresetsAsync = ref.watch(communityPresetsControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with Community title, search, Create Preset button
            _buildTopBar(context, isDesktop),

            // Filter chips
            _buildFilterChips(),

            // Stats row
            _buildStatsRow(context, isDesktop),

            const SizedBox(height: 16),

            // Presets grid
            Expanded(
              child: communityPresetsAsync.when(
                data: (presets) =>
                    _buildPresetsGrid(context, ref, presets, isDesktop),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 64,
                        color: AppColors.onSurfaceVariant.withAlpha(128),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unable to load community presets',
                        style: TypographyTokens.bodyLarge.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(communityPresetsControllerProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? SpacingTokens.xxl : SpacingTokens.lg,
        vertical: SpacingTokens.lg,
      ),
      child: Row(
        children: [
          // Community title
          Text(
            'Community',
            style: TypographyTokens.headlineSmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: SpacingTokens.xxl),

          // Search bar (center, expanded)
          Expanded(
            child: Container(
              height: 44,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadiusTokens.fullCircular,
                border: Border.all(
                  color: AppColors.outlineVariant.withAlpha(51),
                ),
              ),
              child: const Row(
                children: [
                  SizedBox(width: SpacingTokens.md),
                  Icon(
                    Icons.search,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: SpacingTokens.sm),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search presets...',
                        hintStyle: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: SpacingTokens.md),
                ],
              ),
            ),
          ),

          const SizedBox(width: SpacingTokens.xxl),

          // Create Preset button (purple gradient)
          if (isDesktop)
            GestureDetector(
              onTap: () {
                // TODO: Open create preset dialog
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.lg,
                  vertical: SpacingTokens.sm,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadiusTokens.mdCircular,
                  boxShadow: ShadowTokens.buttonGlow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: AppColors.onPrimary, size: 18),
                    const SizedBox(width: SpacingTokens.xs),
                    Text(
                      'Create Preset',
                      style: TypographyTokens.labelLarge.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;

          return Padding(
            padding: const EdgeInsets.only(right: SpacingTokens.sm),
            child: MwChip(
              label: filter,
              isSelected: isSelected,
              onTap: () => setState(() => _selectedFilter = filter),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDesktop) {
    final stats = [
      _StatData('128', 'Shared Presets', Icons.folder_shared_outlined),
      _StatData('42', 'Active Users', Icons.people_outline),
      _StatData('24', 'New This Week', Icons.trending_up),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? SpacingTokens.xxl : SpacingTokens.lg,
        vertical: SpacingTokens.md,
      ),
      child: Row(
        children: stats.map((stat) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: SpacingTokens.md),
              padding: const EdgeInsets.all(SpacingTokens.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadiusTokens.card,
                border: Border.all(
                  color: AppColors.outlineVariant.withAlpha(38),
                ),
              ),
              child: Row(
                children: [
                  Icon(stat.icon, color: AppColors.primary, size: 24),
                  const SizedBox(width: SpacingTokens.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stat.value,
                        style: TypographyTokens.titleMedium.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        stat.label,
                        style: TypographyTokens.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPresetsGrid(
    BuildContext context,
    WidgetRef ref,
    List<UserPreset> presets,
    bool isDesktop,
  ) {
    if (presets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.onSurfaceVariant.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'No community presets yet',
              style: TypographyTokens.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share a preset!',
              style: TypographyTokens.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant.withAlpha(128),
              ),
            ),
          ],
        ),
      );
    }

    final crossAxisCount = isDesktop ? 3 : 2;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? SpacingTokens.xxl : SpacingTokens.lg,
        vertical: SpacingTokens.sm,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.9,
        crossAxisSpacing: SpacingTokens.md,
        mainAxisSpacing: SpacingTokens.md,
      ),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final preset = presets[index];
        final band = _getBandForFrequency(preset.beatFrequency);
        return _CommunityPresetCard(
          preset: preset,
          band: band,
          onTap: () => _loadPreset(context, ref, preset),
        );
      },
    );
  }

  void _loadPreset(
    BuildContext context,
    WidgetRef ref,
    UserPreset preset,
  ) async {
    await ref
        .read(communityPresetsControllerProvider.notifier)
        .loadCommunityPreset(preset);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Loaded "${preset.name}"'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  BrainwaveBand _getBandForFrequency(double beatFrequency) {
    if (beatFrequency <= 4) return BrainwaveBand.delta;
    if (beatFrequency <= 8) return BrainwaveBand.theta;
    if (beatFrequency <= 13) return BrainwaveBand.alpha;
    if (beatFrequency <= 30) return BrainwaveBand.beta;
    return BrainwaveBand.gamma;
  }
}

class _StatData {
  final String value;
  final String label;
  final IconData icon;

  _StatData(this.value, this.label, this.icon);
}

class _CommunityPresetCard extends StatelessWidget {
  final UserPreset preset;
  final BrainwaveBand band;
  final VoidCallback onTap;

  const _CommunityPresetCard({
    required this.preset,
    required this.band,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bandColor = _getBandColor(band);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadiusTokens.card,
          border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header with icon
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(SpacingTokens.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [bandColor.withAlpha(77), bandColor.withAlpha(26)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadiusTokens.mdCircular,
                ),
                child: Center(
                  child: Icon(
                    _getIconForBand(band),
                    size: 40,
                    color: bandColor,
                  ),
                ),
              ),
            ),

            // Preset name and band info
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.md,
                0,
                SpacingTokens.md,
                SpacingTokens.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preset.name,
                    style: TypographyTokens.titleSmall.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${band.name} • ${preset.beatFrequency.toStringAsFixed(1)}Hz',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // User avatar, likes, and play button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.md,
                0,
                SpacingTokens.md,
                SpacingTokens.md,
              ),
              child: Row(
                children: [
                  // User avatar (placeholder)
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    child: Icon(
                      Icons.person,
                      size: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.xs),

                  // Username placeholder
                  Expanded(
                    child: Text(
                      'User${preset.id.substring(0, 4)}',
                      style: TypographyTokens.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Likes count
                  Icon(
                    Icons.favorite,
                    size: 14,
                    color: AppColors.primary.withAlpha(179),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${(preset.id.hashCode % 50) + 10}',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(width: SpacingTokens.sm),

                  // Play button
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadiusTokens.smCircular,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 18,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForBand(BrainwaveBand band) {
    return switch (band) {
      BrainwaveBand.delta => Icons.bedtime,
      BrainwaveBand.theta => Icons.self_improvement,
      BrainwaveBand.alpha => Icons.spa,
      BrainwaveBand.beta => Icons.psychology,
      BrainwaveBand.gamma => Icons.bolt,
    };
  }

  Color _getBandColor(BrainwaveBand band) {
    return switch (band) {
      BrainwaveBand.delta => AppColors.delta,
      BrainwaveBand.theta => AppColors.theta,
      BrainwaveBand.alpha => AppColors.alpha,
      BrainwaveBand.beta => AppColors.beta,
      BrainwaveBand.gamma => AppColors.gamma,
    };
  }
}
