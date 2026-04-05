import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/typography_tokens.dart';
import '../../models/brainwave_preset.dart';

/// Brainwave Band Badge Molecule
///
/// Visual indicator for brainwave frequency bands (Delta, Theta, Alpha, Beta, Gamma).
/// Shows color-coded badge with frequency range.
///
/// Usage:
/// ```dart
/// BandBadge(
///   band: BrainwaveBand.gamma,
///   frequency: 40.0,
///   isActive: true,
/// )
/// ```text
class BandBadge extends StatelessWidget {
  final BrainwaveBand band;
  final double? frequency;
  final bool isActive;
  final bool showFrequency;
  final VoidCallback? onTap;

  const BandBadge({
    super.key,
    required this.band,
    this.frequency,
    this.isActive = false,
    this.showFrequency = true,
    this.onTap,
  });

  String get _label => band.label;
  Color get _color => band.color;

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive ? _color : _color.withAlpha(38);
    final fgColor = isActive ? Colors.white : _color;

    Widget badge = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.sm,
        vertical: SpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadiusTokens.fullCircular,
        border: isActive
            ? null
            : Border.all(color: _color.withAlpha(128), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: SpacingTokens.xs),
          if (showFrequency && frequency != null)
            Text(
              '$_label • ${frequency!.toStringAsFixed(1)} Hz',
              style: TypographyTokens.labelMedium.copyWith(
                color: fgColor,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Text(
              _label,
              style: TypographyTokens.labelMedium.copyWith(
                color: fgColor,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );

    if (onTap != null) {
      badge = GestureDetector(onTap: onTap, child: badge);
    }

    return badge;
  }
}

extension BrainwaveBandExtension on BrainwaveBand {
  String get label {
    switch (this) {
      case BrainwaveBand.delta:
        return 'Delta';
      case BrainwaveBand.theta:
        return 'Theta';
      case BrainwaveBand.alpha:
        return 'Alpha';
      case BrainwaveBand.beta:
        return 'Beta';
      case BrainwaveBand.gamma:
        return 'Gamma';
    }
  }

  String get frequencyRange {
    switch (this) {
      case BrainwaveBand.delta:
        return '0.5-4 Hz';
      case BrainwaveBand.theta:
        return '4-8 Hz';
      case BrainwaveBand.alpha:
        return '8-13 Hz';
      case BrainwaveBand.beta:
        return '13-30 Hz';
      case BrainwaveBand.gamma:
        return '30-100 Hz';
    }
  }

  Color get color {
    switch (this) {
      case BrainwaveBand.delta:
        return const Color(0xFF9C27B0); // Purple
      case BrainwaveBand.theta:
        return const Color(0xFF2196F3); // Blue
      case BrainwaveBand.alpha:
        return const Color(0xFF4CAF50); // Green
      case BrainwaveBand.beta:
        return const Color(0xFFFF9800); // Orange
      case BrainwaveBand.gamma:
        return const Color(0xFFF44336); // Red
    }
  }

  String get description {
    switch (this) {
      case BrainwaveBand.delta:
        return 'Deep sleep, healing, regeneration';
      case BrainwaveBand.theta:
        return 'Meditation, creativity, intuition';
      case BrainwaveBand.alpha:
        return 'Relaxation, calm focus, flow state';
      case BrainwaveBand.beta:
        return 'Active thinking, problem solving';
      case BrainwaveBand.gamma:
        return 'Peak concentration, insight, memory';
    }
  }
}
