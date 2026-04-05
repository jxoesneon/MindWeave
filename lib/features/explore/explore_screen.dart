import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Explore Resonance Screen — matches Stitch design: 09_explore_resonance_search.png
///
/// Features:
/// - Header: "Explore Resonance" + subtitle + LIVE SYNC / BINAURAL ENABLED badges
/// - Category cards row: Focus, Creativity, Meditation, Deep Sleep
/// - Trending Frequencies section with frequency cards
/// - Personalized For You section with preset cards
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  SpacingTokens.lg,
                  hPad,
                  SpacingTokens.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore Resonance',
                                style: TypographyTokens.headlineLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: SpacingTokens.xs),
                              Text(
                                'Find a frequency that aligns with your intent.',
                                style: TypographyTokens.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _badge('LIVE SYNC'),
                        const SizedBox(width: SpacingTokens.sm),
                        _badge('BINAURAL ENABLED'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Category cards
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  children: const [
                    _CategoryCard(
                      label: 'Focus',
                      sub: 'WAVES • 13-30HZ',
                      icon: Icons.center_focus_strong,
                    ),
                    _CategoryCard(
                      label: 'Creativity',
                      sub: 'ALPHA WAVES • 8-13HZ',
                      icon: Icons.palette,
                    ),
                    _CategoryCard(
                      label: 'Meditation',
                      sub: 'THETA WAVES • 4-8HZ',
                      icon: Icons.self_improvement,
                    ),
                    _CategoryCard(
                      label: 'Deep Sleep',
                      sub: 'DELTA WAVES • 0.5-4HZ',
                      icon: Icons.bedtime,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

            // Trending Frequencies
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TRENDING FREQUENCIES',
                      style: TypographyTokens.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'View Global Chart',
                      style: TypographyTokens.labelSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.md)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  children: const [
                    _TrendingCard(
                      title: 'Solar Flare',
                      desc:
                          'Intensely Gamma state for rapid cognitive testing and peak performance.',
                      hz: '432Hz',
                      users: '8k Active',
                    ),
                    _TrendingCard(
                      title: 'Lunar Drift',
                      desc:
                          'Sustained Theta drift designed for ego-dissolution and deep synaptic recovery.',
                      hz: '528Hz',
                      users: '5.8k Active',
                    ),
                    _TrendingCard(
                      title: 'Deep State Gamma',
                      desc:
                          'The ultimate focus enabler. Oscillating waves tuned for deep architectural work.',
                      hz: '40Hz',
                      users: '21.3k Active',
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

            // Personalized For You
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Text(
                  'PERSONALIZED FOR YOU',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.md)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: isDesktop
                    ? const Row(
                        children: [
                          Expanded(
                            child: _PersonalizedCard(
                              tag: 'BASED ON FOCUS HISTORY',
                              title: 'Neural Synthesizer',
                              sub: '45 Min • Beta Isochronic',
                            ),
                          ),
                          SizedBox(width: SpacingTokens.md),
                          Expanded(
                            child: _PersonalizedCard(
                              tag: 'EVENING ROUTINE',
                              title: 'Event Horizon',
                              sub: '60 Min • Delta Harmonic',
                            ),
                          ),
                          SizedBox(width: SpacingTokens.md),
                          Expanded(
                            child: _PersonalizedCard(
                              tag: 'NEW ARRIVAL',
                              title: 'Aqueous Breath',
                              sub: '25 Min • Theta Monalds',
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        children: [
                          _PersonalizedCard(
                            tag: 'BASED ON FOCUS HISTORY',
                            title: 'Neural Synthesizer',
                            sub: '45 Min • Beta Isochronic',
                          ),
                          SizedBox(height: SpacingTokens.md),
                          _PersonalizedCard(
                            tag: 'EVENING ROUTINE',
                            title: 'Event Horizon',
                            sub: '60 Min • Delta Harmonic',
                          ),
                          SizedBox(height: SpacingTokens.md),
                          _PersonalizedCard(
                            tag: 'NEW ARRIVAL',
                            title: 'Aqueous Breath',
                            sub: '25 Min • Theta Monalds',
                          ),
                        ],
                      ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.xxl),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        borderRadius: BorderRadiusTokens.smCircular,
      ),
      child: Text(
        text,
        style: TypographyTokens.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final String sub;
  final IconData icon;

  const _CategoryCard({
    required this.label,
    required this.sub,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: SpacingTokens.md),
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            label,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  final String title;
  final String desc;
  final String hz;
  final String users;

  const _TrendingCard({
    required this.title,
    required this.desc,
    required this.hz,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: SpacingTokens.md),
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TypographyTokens.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(38),
                  borderRadius: BorderRadiusTokens.smCircular,
                ),
                child: Text(
                  hz,
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            desc,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                users,
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
                child: const Icon(
                  Icons.play_arrow,
                  color: AppColors.onPrimary,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonalizedCard extends StatelessWidget {
  final String tag;
  final String title;
  final String sub;

  const _PersonalizedCard({
    required this.tag,
    required this.title,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            tag,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            title,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
