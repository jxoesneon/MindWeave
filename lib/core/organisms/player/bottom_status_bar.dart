import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../atoms/atoms.dart';

/// Bottom Status Bar Organism
///
/// Desktop-only status bar showing carrier frequency, signal status, and utility icons.
/// Matches Stitch design bottom bar.
///
/// Usage:
/// ```dart
/// BottomStatusBar(
///   carrierFrequency: 200.0,
///   isSynchronized: true,
/// )
/// ```
class BottomStatusBar extends StatelessWidget {
  final double carrierFrequency;
  final bool isSynchronized;
  final VoidCallback? onSettingsTap;

  const BottomStatusBar({
    super.key,
    this.carrierFrequency = 200.0,
    this.isSynchronized = true,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withAlpha(38),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Carrier frequency
          Text(
            'CARRIER FREQ',
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: SpacingTokens.sm),
          // Mini waveform indicator
          _MiniWaveform(),
          const SizedBox(width: SpacingTokens.lg),
          // Signal status
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SIGNAL STATUS',
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: SpacingTokens.xs),
              Text(
                isSynchronized ? 'Binaural Synchronized' : 'Standby',
                style: TypographyTokens.labelMedium.copyWith(
                  color: isSynchronized
                      ? AppColors.secondary
                      : AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Utility icons
          MwIconButton(
            onPressed: () {},
            icon: Icons.volume_up,
            size: 20,
            color: AppColors.onSurfaceVariant,
            tooltip: 'Volume',
          ),
          MwIconButton(
            onPressed: () {},
            icon: Icons.equalizer,
            size: 20,
            color: AppColors.onSurfaceVariant,
            tooltip: 'Equalizer',
          ),
          MwIconButton(
            onPressed: onSettingsTap,
            icon: Icons.settings_outlined,
            size: 20,
            color: AppColors.onSurfaceVariant,
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// Tiny animated waveform bars for the carrier frequency indicator
class _MiniWaveform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(8, (i) {
        final height = 4.0 + (i % 3 + 1) * 4.0;
        return Container(
          width: 3,
          height: height,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(180),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
