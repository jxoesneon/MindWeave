import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Documentation Screen — matches Stitch design: 37_your_resonance_archive.png
///
/// Features:
/// - Sidebar with doc sections (Getting Started, Frequency Theory, etc.)
/// - "Lumina Resonance" title with subtitle
/// - What is Lumina Resonance section
/// - Core Concepts cards: Frequency Weaving, Neural Entrainment, Session Architecture
/// - Quick Start guide
class DocumentationScreen extends StatefulWidget {
  const DocumentationScreen({super.key});

  @override
  State<DocumentationScreen> createState() => _DocumentationScreenState();
}

class _DocumentationScreenState extends State<DocumentationScreen> {
  String _selectedSection = 'Overview';

  final List<(String, IconData)> _sections = [
    ('Overview', Icons.home_outlined),
    ('Getting Started', Icons.play_circle_outline),
    ('Frequency Theory', Icons.waves),
    ('Session Types', Icons.category_outlined),
    ('Audio Engine', Icons.surround_sound_outlined),
    ('API Reference', Icons.code),
    ('FAQ', Icons.help_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSidebar(),
                  Expanded(child: _buildContent(hPad)),
                ],
              )
            : _buildContent(hPad),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.outlineVariant.withAlpha(38)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documentation',
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'v2.0 Reference',
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.xl),
          ..._sections.map((s) {
            final isSelected = s.$1 == _selectedSection;
            return GestureDetector(
              onTap: () => setState(() => _selectedSection = s.$1),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: SpacingTokens.xs),
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.md,
                  vertical: SpacingTokens.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withAlpha(26)
                      : Colors.transparent,
                  borderRadius: BorderRadiusTokens.smCircular,
                ),
                child: Row(
                  children: [
                    Icon(
                      s.$2,
                      size: 16,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: SpacingTokens.sm),
                    Text(
                      s.$1,
                      style: TypographyTokens.labelLarge.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent(double hPad) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                hPad, SpacingTokens.xl, hPad, SpacingTokens.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MINDWEAVE DOCUMENTATION',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Lumina\nResonance.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'Complete guide to understanding and leveraging MindWeave\'s frequency generation engine for optimal cognitive enhancement.',
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

        // What is Lumina Resonance
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Container(
              padding: const EdgeInsets.all(SpacingTokens.xl),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadiusTokens.card,
                border:
                    Border.all(color: AppColors.primary.withAlpha(38)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is Lumina Resonance?',
                    style: TypographyTokens.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  Text(
                    'Lumina Resonance is MindWeave\'s proprietary audio synthesis engine that generates precisely calibrated binaural beats, isochronic tones, and harmonic layers. It combines decades of neuroscience research with real-time adaptive algorithms to create personalized frequency experiences.',
                    style: TypographyTokens.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

        // Core Concepts
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Text(
              'CORE CONCEPTS',
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
            child: LayoutBuilder(builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              final cards = [
                _conceptCard(Icons.waves, 'Frequency Weaving',
                    'Layer multiple frequency bands simultaneously to create complex cognitive states beyond simple binaural beats.'),
                _conceptCard(Icons.psychology, 'Neural Entrainment',
                    'The brain\'s natural tendency to synchronize its electrical cycles to external rhythmic stimulation.'),
                _conceptCard(Icons.timer_outlined, 'Session Architecture',
                    'Structured frequency progressions that guide the brain through states: warm-up, peak, and cool-down phases.'),
              ];
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cards
                      .map((c) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: c == cards.last
                                    ? 0
                                    : SpacingTokens.md,
                              ),
                              child: c,
                            ),
                          ))
                      .toList(),
                );
              }
              return Column(
                children: cards
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: SpacingTokens.md),
                          child: c,
                        ))
                    .toList(),
              );
            }),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

        // Quick Start
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: _buildQuickStart(),
          ),
        ),

        const SliverToBoxAdapter(
            child: SizedBox(height: SpacingTokens.xxl)),
      ],
    );
  }

  static Widget _conceptCard(IconData icon, String title, String body) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadiusTokens.mdCircular,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: SpacingTokens.md),
          Text(
            title,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            body,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildQuickStart() {
    final steps = [
      ('1', 'Choose a Frequency Band',
          'Select from Delta, Theta, Alpha, Beta, or Gamma based on your desired state.'),
      ('2', 'Set Your Duration',
          'Use the Sonic Sanctuary timer to set your session length (recommended: 15-30 min).'),
      ('3', 'Wear Headphones',
          'Stereo headphones are required for binaural beats to work properly.'),
      ('4', 'Begin Your Session',
          'Press play, close your eyes, and let the frequencies guide your consciousness.'),
    ];

    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Start Guide',
            style: TypographyTokens.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          ...steps.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(38),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        s.$1,
                        style: TypographyTokens.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.$2,
                          style: TypographyTokens.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.$3,
                          style: TypographyTokens.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
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
}
