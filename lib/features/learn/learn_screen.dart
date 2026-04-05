import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/atoms/atoms.dart';
import '../navigation/app_routes.dart';

/// Learn / Education Screen — matches Stitch design: 08_learn_about_flow.png
///
/// Features:
/// - Sidebar: Educational Modules with section links
/// - Hero: "Decoding Flow State" with subtitle
/// - How Binaural Beats Work section with diagram description
/// - The Benefits of Weaving list
/// - The Frequency Spectrum: Beta, Theta, Alpha, Beta, Gamma cards
/// - Safety & Ethics section
class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  String _selectedModule = 'Frequency Theory';

  final List<String> _modules = [
    'The Void',
    'Frequency Theory',
    'Science of Beats',
    'Flow Mechanics',
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
                  // Sidebar
                  _buildSidebar(),
                  // Main content
                  Expanded(child: _buildMainContent(hPad)),
                ],
              )
            : _buildMainContent(hPad),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
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
            'Educational Modules',
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'Deep Doctrine Hub',
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          ..._modules.map((m) {
            final isSelected = m == _selectedModule;
            return GestureDetector(
              onTap: () => setState(() => _selectedModule = m),
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
                child: Text(
                  m,
                  style: TypographyTokens.labelLarge.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMainContent(double hPad) {
    return CustomScrollView(
      slivers: [
        // Header subtitle + title
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              hPad,
              SpacingTokens.xl,
              hPad,
              SpacingTokens.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE SCIENCE OF CONSCIOUSNESS',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Decoding Flow\nState.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'A creative, deep-focus state where time dissolves and performance peaks. We explore the neural architecture behind humanity\'s most productive moments.',
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

        // How Binaural Beats Work + Benefits
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: _buildBinauralSection(),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

        // The Frequency Spectrum
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: _buildFrequencySpectrum(),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

        // Safety & Ethics
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: _buildSafetySection(),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xxl)),
      ],
    );
  }

  Widget _buildBinauralSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildHowItWorks()),
              const SizedBox(width: SpacingTokens.lg),
              Expanded(flex: 2, child: _buildBenefits()),
            ],
          );
        }
        return Column(
          children: [
            _buildHowItWorks(),
            const SizedBox(height: SpacingTokens.lg),
            _buildBenefits(),
          ],
        );
      },
    );
  }

  Widget _buildHowItWorks() {
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
            'How Binaural Beats Work',
            style: TypographyTokens.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          Text(
            'Binaural beats occur when two tones of slightly different frequencies are played in each ear. Your brain perceives a third "ghost" beat—the difference between the two.',
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          // Diagram placeholder
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadiusTokens.mdCircular,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LEFT EAR (440Hz)',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.lg),
                  Text(
                    'RIGHT EAR (450Hz)',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Center(
            child: MwChip(
              label: '▶ 10Hz Alpha Beat',
              isSelected: true,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.deepResonance),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    final benefits = [
      'Accelerated skill acquisition',
      'Reduced cortisol & stress response',
      'Improved focus (4× boost)',
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
            'The Benefits of Weaving',
            style: TypographyTokens.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: SpacingTokens.sm),
                  Expanded(
                    child: Text(
                      b,
                      style: TypographyTokens.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.deepResonance),
            child: Text(
              'View Clinical Studies →',
              style: TypographyTokens.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencySpectrum() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'The Frequency Spectrum',
          style: TypographyTokens.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: SpacingTokens.lg),
        const Wrap(
          spacing: SpacingTokens.sm,
          runSpacing: SpacingTokens.sm,
          children: [
            _SpectrumCard(
              band: 'Beta',
              range: '0.5 - 4Hz',
              desc: 'Deep restorative sleep and healing.',
              color: Color(0xFF1A237E),
            ),
            _SpectrumCard(
              band: 'Theta',
              range: '4 - 8Hz',
              desc: 'Meditation, deep sleep, subconscious.',
              color: Color(0xFF00695C),
            ),
            _SpectrumCard(
              band: 'Alpha',
              range: '8 - 13Hz',
              desc: 'Relaxation, light meditation, flow state.',
              color: Color(0xFF2E7D32),
            ),
            _SpectrumCard(
              band: 'Beta',
              range: '13 - 30Hz',
              desc: 'Active thinking, analytical focus, logic.',
              color: Color(0xFFF57C00),
            ),
            _SpectrumCard(
              band: 'Gamma',
              range: '30 - 100Hz',
              desc: 'Peak performance, insight, higher perception.',
              color: Color(0xFF7B1FA2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSafetySection() {
    final items = [
      (
        Icons.warning_amber,
        'Not for Epilepsy',
        'Binaural beats may trigger seizures in individuals with photosensitive epilepsy or similar conditions.',
      ),
      (
        Icons.timer_outlined,
        'The 30-Minute Rule',
        'Start with short sessions to allow your brain to adapt to frequency entrainment.',
      ),
      (
        Icons.headphones,
        'Stereo Required',
        'Binaural effects require high-quality headphones. High-quality headphones are essential for the frequencies to work.',
      ),
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
            'Safety & Ethics',
            style: TypographyTokens.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.$1, size: 20, color: AppColors.primary),
                  const SizedBox(width: SpacingTokens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$2,
                          style: TypographyTokens.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.$3,
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

class _SpectrumCard extends StatelessWidget {
  final String band;
  final String range;
  final String desc;
  final Color color;

  const _SpectrumCard({
    required this.band,
    required this.range,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withAlpha(38),
              borderRadius: BorderRadiusTokens.smCircular,
            ),
            child: Text(
              range,
              style: TypographyTokens.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 9,
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            band,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
