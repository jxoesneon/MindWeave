import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../navigation/app_routes.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Support Sanctuary Screen — matches Stitch design: 07_support_sanctuary.png
///
/// Mobile-first layout with:
/// - "Find your way back to tranquility" hero
/// - Search bar
/// - Featured Guides section
/// - Explore Categories grid (Technical, Science & Mind, Troubleshooting, Premium Resource)
/// - Need More Help card with Live Chat button
/// - Community FAQ accordion
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hPad = SpacingTokens.lg;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Support Sanctuary',
          style: TypographyTokens.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Hero
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(hPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOPE LIVES HERE',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    'Find your way back\nto tranquility.',
                    style: TypographyTokens.headlineMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadiusTokens.mdCircular,
                  border: Border.all(
                    color: AppColors.outlineVariant.withAlpha(38),
                  ),
                ),
                child: TextField(
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search guides, frequencies, or find...',
                    hintStyle: TypographyTokens.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

          // Featured Guides
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Guides',
                    style: TypographyTokens.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'View All',
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
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: hPad),
                children: [
                  _guideCard('First Steps: Your First\nSession'),
                  _guideCard('Understanding Your\nFrequency Profile'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

          // Explore Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Text(
                'Explore Categories',
                style: TypographyTokens.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.md)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: const Wrap(
                spacing: SpacingTokens.sm,
                runSpacing: SpacingTokens.sm,
                children: [
                  _CategoryChip(icon: Icons.build_outlined, label: 'Technical'),
                  _CategoryChip(
                    icon: Icons.psychology_outlined,
                    label: 'Science &\nMind',
                  ),
                  _CategoryChip(
                    icon: Icons.warning_amber,
                    label: 'Trouble-\nshooting',
                  ),
                  _CategoryChip(
                    icon: Icons.diamond_outlined,
                    label: 'Premium\nResource',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

          // Need More Help
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Container(
                padding: const EdgeInsets.all(SpacingTokens.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadiusTokens.card,
                  border: Border.all(
                    color: AppColors.outlineVariant.withAlpha(38),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Need More Help?',
                      style: TypographyTokens.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.xs),
                    Text(
                      'Our resonance specialists are available to guide you through any disruption on your journey.',
                      textAlign: TextAlign.center,
                      style: TypographyTokens.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.md),
                    OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.documentation),
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Live Chat'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusTokens.fullCircular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

          // Community FAQ
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Text(
                'Community FAQ',
                style: TypographyTokens.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.md)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Column(
                children: [
                  _faqTile('How do binaural beats work?'),
                  _faqTile('Is MindWeave safe for all-day listening?'),
                  _faqTile('Can I use MindWeave while sleeping?'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xxl)),
        ],
      ),
    );
  }

  static Widget _guideCard(String title) {
    return Container(
      width: 180,
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
          Text(
            title,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _faqTile(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: SpacingTokens.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.mdCircular,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: ListTile(
        dense: true,
        title: Text(
          question,
          style: TypographyTokens.bodyMedium.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        trailing: const Icon(
          Icons.expand_more,
          color: AppColors.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 80,
      padding: const EdgeInsets.all(SpacingTokens.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
