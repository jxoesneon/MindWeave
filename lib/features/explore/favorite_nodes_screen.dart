import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/atoms/atoms.dart';

/// Favorite Nodes Screen — matches Stitch designs: 10/28
///
/// Features:
/// - "RESONANCE DISCOVERIES" subtitle + "Favorite Nodes" title
/// - Filter chips: All, Delta, Theta, Alpha, Beta, Gamma
/// - Grid of frequency node cards with waveform icons, frequency, band tag,
///   play button, and favorite toggle
/// - Desktop: 4-column grid, Mobile: 2-column grid
class FavoriteNodesScreen extends ConsumerStatefulWidget {
  const FavoriteNodesScreen({super.key});

  @override
  ConsumerState<FavoriteNodesScreen> createState() =>
      _FavoriteNodesScreenState();
}

class _FavoriteNodesScreenState extends ConsumerState<FavoriteNodesScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Delta',
    'Theta',
    'Alpha',
    'Beta',
    'Gamma',
  ];

  final List<_NodeData> _nodes = const [
    _NodeData('Cosmic Anchor', '432Hz', 'DeepTheta', Color(0xFF00695C), true),
    _NodeData('Morning Mist', '528Hz', 'AlphaFlow', Color(0xFF2E7D32), true),
    _NodeData('Solar Flare', '40Hz', 'Gamma', Color(0xFF7B1FA2), false),
    _NodeData('Neural Sync', '14Hz', 'Beta', Color(0xFFF57C00), true),
    _NodeData('Lunar Drift', '3.5Hz', 'Delta', Color(0xFF1A237E), true),
    _NodeData('Zen Garden', '7Hz', 'Theta', Color(0xFF00695C), false),
    _NodeData('Deep State', '2Hz', 'Delta', Color(0xFF1A237E), true),
    _NodeData('Focus Engine', '18Hz', 'Beta', Color(0xFFF57C00), true),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;
    final crossAxisCount = isDesktop ? 4 : 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    hPad, SpacingTokens.lg, hPad, SpacingTokens.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RESONANCE DISCOVERIES',
                      style: TypographyTokens.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    Text(
                      'Favorite Nodes',
                      style: TypographyTokens.headlineLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    Text(
                      'Your curated collection of resonance frequencies.',
                      style: TypographyTokens.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = filter == _selectedFilter;
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: SpacingTokens.sm),
                      child: MwChip(
                        label: filter,
                        isSelected: isSelected,
                        onTap: () =>
                            setState(() => _selectedFilter = filter),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
                child: SizedBox(height: SpacingTokens.lg)),

            // Grid of nodes
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: SpacingTokens.md,
                  mainAxisSpacing: SpacingTokens.md,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildNodeCard(_nodes[index]),
                  childCount: _nodes.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
                child: SizedBox(height: SpacingTokens.xxl)),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeCard(_NodeData node) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: waveform icon + favorite
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: node.color.withAlpha(38),
                  borderRadius: BorderRadiusTokens.mdCircular,
                ),
                child: Icon(Icons.waves, color: node.color, size: 20),
              ),
              Icon(
                node.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: node.isFavorite
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
          const Spacer(),
          // Band tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: node.color.withAlpha(26),
              borderRadius: BorderRadiusTokens.smCircular,
            ),
            child: Text(
              node.band,
              style: TypographyTokens.labelSmall.copyWith(
                color: node.color,
                fontWeight: FontWeight.w600,
                fontSize: 9,
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          // Title
          Text(
            node.title,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Frequency + play button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                node.hz,
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadiusTokens.fullCircular,
                ),
                child: const Icon(Icons.play_arrow,
                    color: AppColors.onPrimary, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NodeData {
  final String title;
  final String hz;
  final String band;
  final Color color;
  final bool isFavorite;
  const _NodeData(this.title, this.hz, this.band, this.color, this.isFavorite);
}
