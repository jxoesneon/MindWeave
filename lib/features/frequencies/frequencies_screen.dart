import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/brainwave_preset.dart';

/// Educational screen for exploring brainwave frequencies and their effects.
/// Provides detailed information about Delta, Theta, Alpha, Beta, and Gamma waves.
class FrequenciesScreen extends ConsumerStatefulWidget {
  const FrequenciesScreen({super.key});

  @override
  ConsumerState<FrequenciesScreen> createState() => _FrequenciesScreenState();
}

class _FrequenciesScreenState extends ConsumerState<FrequenciesScreen> {
  BrainwaveBand? _selectedBand;

  final List<FrequencyInfo> _frequencyData = [
    FrequencyInfo(
      band: BrainwaveBand.delta,
      frequencyRange: '0.5 - 4 Hz',
      name: 'Delta Waves',
      description: 'Deep sleep, healing, and unconscious mind access.',
      benefits: [
        'Deep restorative sleep',
        'Physical healing',
        'Immune system boost',
        'Unconscious reprogramming',
        'Pain relief',
      ],
      color: const Color(0xFF1A237E),
      icon: Icons.bedtime,
    ),
    FrequencyInfo(
      band: BrainwaveBand.theta,
      frequencyRange: '4 - 8 Hz',
      name: 'Theta Waves',
      description: 'Meditation, creativity, and subconscious access.',
      benefits: [
        'Deep meditation states',
        'Enhanced creativity',
        'Improved intuition',
        'Stress reduction',
        'Emotional healing',
      ],
      color: const Color(0xFF00695C),
      icon: Icons.self_improvement,
    ),
    FrequencyInfo(
      band: BrainwaveBand.alpha,
      frequencyRange: '8 - 13 Hz',
      name: 'Alpha Waves',
      description: 'Relaxed awareness, flow states, and calm focus.',
      benefits: [
        'Relaxed alertness',
        'Flow state access',
        'Improved learning',
        'Stress relief',
        'Mind-body coordination',
      ],
      color: const Color(0xFF2E7D32),
      icon: Icons.spa,
    ),
    FrequencyInfo(
      band: BrainwaveBand.beta,
      frequencyRange: '13 - 30 Hz',
      name: 'Beta Waves',
      description: 'Active thinking, focus, and problem solving.',
      benefits: [
        'Enhanced focus',
        'Cognitive performance',
        'Problem solving',
        'Alertness',
        'Social interaction',
      ],
      color: const Color(0xFFF57C00),
      icon: Icons.psychology,
    ),
    FrequencyInfo(
      band: BrainwaveBand.gamma,
      frequencyRange: '30 - 100 Hz',
      name: 'Gamma Waves',
      description: 'Peak performance, insight, and heightened perception.',
      benefits: [
        'Peak mental performance',
        'Enhanced perception',
        'Sudden insights',
        'Memory processing',
        'Compassion and empathy',
      ],
      color: const Color(0xFF7B1FA2),
      icon: Icons.bolt,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Brainwave Frequencies',
          style: TextStyle(
            color: AppColors.onSurface,
            fontFamily: 'Space Grotesk',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard(),
          const SizedBox(height: 24),
          ..._frequencyData.map((freq) => _buildFrequencyCard(freq)),
          const SizedBox(height: 24),
          _buildUsageTipsCard(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar - Frequency list
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withAlpha(102),
            border: Border(
              right: BorderSide(color: AppColors.outlineVariant.withAlpha(51)),
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _frequencyData.length,
            itemBuilder: (context, index) {
              final freq = _frequencyData[index];
              final isSelected = _selectedBand == freq.band;
              return _buildDesktopFrequencyListItem(freq, isSelected);
            },
          ),
        ),
        // Right content area
        Expanded(
          child: _selectedBand != null
              ? _buildDesktopDetailView(
                  _frequencyData.firstWhere((f) => f.band == _selectedBand),
                )
              : _buildDesktopEmptyState(),
        ),
      ],
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.waves, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Understanding Brainwaves',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Space Grotesk',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your brain produces electrical impulses at different frequencies. '
            'Binaural beats can help guide your brain into these beneficial states.',
            style: TextStyle(
              color: Colors.white.withAlpha(230),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyCard(FrequencyInfo freq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withAlpha(102),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: freq.color.withAlpha(51),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(freq.icon, color: freq.color),
        ),
        title: Text(
          freq.name,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontFamily: 'Space Grotesk',
          ),
        ),
        subtitle: Text(
          freq.frequencyRange,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  freq.description,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Benefits:',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...freq.benefits.map(
                  (benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            benefit,
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRecommendedPresets(freq.band),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedPresets(BrainwaveBand band) {
    final presets = _getPresetsForBand(band);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Presets:',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presets
              .map(
                (preset) => Chip(
                  label: Text(preset, style: const TextStyle(fontSize: 12)),
                  backgroundColor: AppColors.surfaceContainerLow,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  List<String> _getPresetsForBand(BrainwaveBand band) {
    switch (band) {
      case BrainwaveBand.delta:
        return ['Deep Sleep', 'Healing', 'Immune Boost'];
      case BrainwaveBand.theta:
        return ['Meditation', 'Creativity', 'Dream State'];
      case BrainwaveBand.alpha:
        return ['Focus', 'Relaxation', 'Flow State'];
      case BrainwaveBand.beta:
        return ['Study Mode', 'Work Focus', 'Alertness'];
      case BrainwaveBand.gamma:
        return ['Peak Performance', 'Insight', 'Learning'];
    }
  }

  Widget _buildUsageTipsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withAlpha(102),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Usage Tips',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTip('Start with Alpha (8-13 Hz) for general relaxation'),
          _buildTip('Use headphones for best binaural beat effect'),
          _buildTip('Allow 10-15 minutes for brain to entrain'),
          _buildTip('Start at lower volumes and gradually increase'),
          _buildTip('Combine with breathing exercises for enhanced effects'),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_right,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFrequencyListItem(FrequencyInfo freq, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedBand = freq.band),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? freq.color.withAlpha(26)
              : AppColors.surfaceContainerLow.withAlpha(77),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? freq.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: freq.color.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(freq.icon, color: freq.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    freq.name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  Text(
                    freq.frequencyRange,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isSelected ? freq.color : AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.waves, size: 64, color: AppColors.primary.withAlpha(128)),
          const SizedBox(height: 16),
          const Text(
            'Select a Frequency',
            style: TextStyle(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Space Grotesk',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Click on a brainwave band to learn more',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopDetailView(FrequencyInfo freq) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: freq.color.withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(freq.icon, color: freq.color, size: 32),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    freq.name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: freq.color.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      freq.frequencyRange,
                      style: TextStyle(
                        color: freq.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            freq.description,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withAlpha(102),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Key Benefits',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                const SizedBox(height: 16),
                ...freq.benefits.map(
                  (benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: freq.color.withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check, color: freq.color, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          benefit,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildRecommendedPresets(freq.band),
        ],
      ),
    );
  }
}

class FrequencyInfo {
  final BrainwaveBand band;
  final String frequencyRange;
  final String name;
  final String description;
  final List<String> benefits;
  final Color color;
  final IconData icon;

  FrequencyInfo({
    required this.band,
    required this.frequencyRange,
    required this.name,
    required this.description,
    required this.benefits,
    required this.color,
    required this.icon,
  });
}
