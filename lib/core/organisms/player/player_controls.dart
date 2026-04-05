import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../tokens/shadow_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../atoms/atoms.dart';
import '../../tokens/component_types.dart';

/// Player Control Bar Organism
///
/// Bottom control bar with play/pause, skip, volume, and progress.
///
/// Usage:
/// ```dart
/// PlayerControlBar(
///   isPlaying: true,
///   progress: 0.5,
///   onPlayPause: () {},
///   onPrevious: () {},
///   onNext: () {},
///   onProgressChanged: (value) {},
/// )
/// ```text
class PlayerControlBar extends StatelessWidget {
  final bool isPlaying;
  final double progress;
  final VoidCallback? onPlayPause;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<double>? onProgressChanged;
  final double volume;
  final ValueChanged<double>? onVolumeChanged;

  const PlayerControlBar({
    super.key,
    this.isPlaying = false,
    this.progress = 0.0,
    this.onPlayPause,
    this.onPrevious,
    this.onNext,
    this.onProgressChanged,
    this.volume = 1.0,
    this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadiusTokens.card,
        boxShadow: ShadowTokens.cardRest,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          if (onProgressChanged != null)
            Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.md),
              child: MwSlider(
                value: progress,
                onChanged: onProgressChanged,
                showLabels: false,
              ),
            ),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              if (onPrevious != null)
                MwIconButton(
                  onPressed: onPrevious,
                  icon: Icons.skip_previous,
                  size: 32,
                ),
              const SizedBox(width: SpacingTokens.lg),
              // Play/Pause button (larger)
              _PlayPauseButton(isPlaying: isPlaying, onPressed: onPlayPause),
              const SizedBox(width: SpacingTokens.lg),
              // Next button
              if (onNext != null)
                MwIconButton(
                  onPressed: onNext,
                  icon: Icons.skip_next,
                  size: 32,
                ),
            ],
          ),
          const SizedBox(height: SpacingTokens.md),
          // Volume control
          if (onVolumeChanged != null)
            Row(
              children: [
                Icon(
                  volume == 0
                      ? Icons.volume_off
                      : volume < 0.5
                      ? Icons.volume_down
                      : Icons.volume_up,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: SpacingTokens.sm),
                Expanded(
                  child: MwSlider(
                    value: volume,
                    onChanged: onVolumeChanged,
                    showLabels: false,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onPressed;

  const _PlayPauseButton({required this.isPlaying, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: AnimationTokens.fast,
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: ShadowTokens.buttonGlow,
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: AppColors.onPrimary,
          size: 32,
        ),
      ),
    );
  }
}

/// Mixer Control Panel Organism
///
/// Panel for adjusting carrier tone, beat frequency, and noise levels.
///
/// Usage:
/// ```dart
/// MixerPanel(
///   carrierFrequency: 200,
///   beatFrequency: 40,
///   noiseLevel: 0.3,
///   onCarrierChanged: (value) {},
///   onBeatChanged: (value) {},
///   onNoiseChanged: (value) {},
/// )
/// ```text
class MixerPanel extends StatelessWidget {
  final double carrierFrequency;
  final double beatFrequency;
  final double noiseLevel;
  final ValueChanged<double>? onCarrierChanged;
  final ValueChanged<double>? onBeatChanged;
  final ValueChanged<double>? onNoiseChanged;

  const MixerPanel({
    super.key,
    this.carrierFrequency = 200,
    this.beatFrequency = 10,
    this.noiseLevel = 0.0,
    this.onCarrierChanged,
    this.onBeatChanged,
    this.onNoiseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MwTonalContainer(
      tonalLevel: TonalLevel.surfaceContainerHigh,
      borderRadius: BorderRadiusTokens.card,
      padding: SpacingTokens.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Audio Mixer',
            style: TypographyTokens.titleMedium.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          // Carrier frequency
          _MixerSlider(
            label: 'Carrier',
            value: carrierFrequency,
            min: 100,
            max: 500,
            unit: 'Hz',
            onChanged: onCarrierChanged,
          ),
          const SizedBox(height: SpacingTokens.md),
          // Beat frequency
          _MixerSlider(
            label: 'Beat Frequency',
            value: beatFrequency,
            min: 0.5,
            max: 50,
            unit: 'Hz',
            onChanged: onBeatChanged,
          ),
          const SizedBox(height: SpacingTokens.md),
          // Noise level
          _MixerSlider(
            label: 'Noise',
            value: noiseLevel,
            min: 0,
            max: 1,
            unit: '',
            isPercentage: true,
            onChanged: onNoiseChanged,
          ),
        ],
      ),
    );
  }
}

class _MixerSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final bool isPercentage;
  final ValueChanged<double>? onChanged;

  const _MixerSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    this.isPercentage = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = isPercentage
        ? '${(value * 100).round()}%'
        : '${value.toStringAsFixed(1)} $unit';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TypographyTokens.labelLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            Text(
              displayValue,
              style: TypographyTokens.labelMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.xs),
        MwSlider(
          value: (value - min) / (max - min),
          onChanged: onChanged != null
              ? (normalized) {
                  onChanged!(min + (normalized * (max - min)));
                }
              : null,
          showLabels: false,
        ),
      ],
    );
  }
}
