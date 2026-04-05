import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Deep Resonance Research Screen — matches Stitch design: 13_deep_flow_immersion.png
///
/// Features:
/// - "NEURAL SCIENCE" subtitle + "The Mathematics of Deep Resonance" title
/// - Core Principle: Frequency Following Response card
/// - The Neural Pathway diagram placeholder
/// - Scientific References section
/// - Key Research Findings cards
class DeepResonanceScreen extends StatelessWidget {
  const DeepResonanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEURAL SCIENCE',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'The Mathematics of\nDeep Resonance.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'Exploring the intersection of neuroscience, mathematics, and consciousness through the lens of brainwave entrainment.',
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: SpacingTokens.xxl),

                // Core Principle card
                _buildCorePrinciple(),

                const SizedBox(height: SpacingTokens.xl),

                // Neural Pathway
                _buildNeuralPathway(),

                const SizedBox(height: SpacingTokens.xl),

                // Key Research Findings
                Text(
                  'KEY RESEARCH FINDINGS',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _findingCard(
                              '40Hz Gamma',
                              'MIT researchers found that 40Hz light and sound stimulation reduced amyloid plaques in Alzheimer\'s mouse models by 50%.',
                              'Iaccarino et al., Nature 2016',
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.md),
                          Expanded(
                            child: _findingCard(
                              'Theta Meditation',
                              'Regular theta entrainment showed 23% improvement in working memory scores over 8-week controlled trials.',
                              'Chaieb et al., Frontiers 2015',
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.md),
                          Expanded(
                            child: _findingCard(
                              'Alpha Relaxation',
                              'Alpha binaural beats (10Hz) significantly reduced pre-operative anxiety compared to placebo audio.',
                              'Padmanabhan et al., 2005',
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _findingCard(
                          '40Hz Gamma',
                          'MIT researchers found that 40Hz stimulation reduced amyloid plaques in Alzheimer\'s models by 50%.',
                          'Iaccarino et al., Nature 2016',
                        ),
                        const SizedBox(height: SpacingTokens.md),
                        _findingCard(
                          'Theta Meditation',
                          'Regular theta entrainment showed 23% improvement in working memory over 8 weeks.',
                          'Chaieb et al., Frontiers 2015',
                        ),
                        const SizedBox(height: SpacingTokens.md),
                        _findingCard(
                          'Alpha Relaxation',
                          'Alpha binaural beats (10Hz) significantly reduced pre-operative anxiety.',
                          'Padmanabhan et al., 2005',
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: SpacingTokens.xl),

                // Scientific References
                _buildReferences(),

                const SizedBox(height: SpacingTokens.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildCorePrinciple() {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.primary.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: SpacingTokens.sm),
              Text(
                'Core Principle',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.md),
          Text(
            'Frequency Following Response (FFR)',
            style: TypographyTokens.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            'When the brain receives two slightly different frequencies through each ear, it creates a third "phantom" frequency — the binaural beat. The brain\'s natural tendency is to synchronize its electrical activity to this frequency, a phenomenon known as neural entrainment.',
            style: TypographyTokens.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          // Formula placeholder
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SpacingTokens.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadiusTokens.mdCircular,
            ),
            child: Center(
              child: Text(
                'f_beat = |f_left - f_right|',
                style: TypographyTokens.titleMedium.copyWith(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildNeuralPathway() {
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
            'The Neural Pathway',
            style: TypographyTokens.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          // Simplified pathway visualization
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _pathwayStep('Auditory\nInput', Icons.headphones),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.onSurfaceVariant,
                size: 16,
              ),
              _pathwayStep('Brainstem\nProcessing', Icons.psychology),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.onSurfaceVariant,
                size: 16,
              ),
              _pathwayStep('Cortical\nEntrainment', Icons.waves),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.onSurfaceVariant,
                size: 16,
              ),
              _pathwayStep('Altered\nState', Icons.auto_awesome),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _pathwayStep(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TypographyTokens.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  static Widget _findingCard(String title, String body, String source) {
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
          const SizedBox(height: SpacingTokens.sm),
          Text(
            source,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildReferences() {
    final refs = [
      'Oster, G. (1973). Auditory beats in the brain. Scientific American.',
      'Lane, J.D. et al. (1998). Binaural auditory beats affect vigilance performance and mood.',
      'Wahbeh, H. et al. (2007). Binaural beat technology in humans: a pilot study.',
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
            'Scientific References',
            style: TypographyTokens.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          ...refs.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[${entry.key + 1}]',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.sm),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TypographyTokens.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
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
