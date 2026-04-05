import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../theme/app_colors.dart';

/// Slider Atom
///
/// Custom slider with aura glow on thumb and track.
/// Follows Stitch design system for audio controls.
///
/// Usage:
/// ```dart
/// MwSlider(
///   value: _volume,
///   onChanged: (value) => setState(() => _volume = value),
///   min: 0,
///   max: 100,
///   showLabels: true,
/// )
/// ```text
class MwSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool showLabels;
  final Color? activeColor;
  final Color? inactiveColor;

  const MwSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showLabels = false,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final thumbColor = activeColor ?? AppColors.primary;
    final trackColor = inactiveColor ?? AppColors.surfaceContainerHigh;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabels && label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.xs),
        ],
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            // Active track
            activeTrackColor: thumbColor,
            // Inactive track
            inactiveTrackColor: trackColor,
            // Thumb with glow
            thumbColor: thumbColor,
            overlayColor: thumbColor.withAlpha(38),
            // Track shape
            trackHeight: 4,
            // Thumb shape - larger for easier touch
            thumbShape: const _AuraThumbShape(),
            // Overlay shape
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            // Track shape with rounded ends
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
          ),
        ),
      ],
    );
  }
}

/// Custom thumb shape with aura glow effect
class _AuraThumbShape extends SliderComponentShape {
  const _AuraThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(20, 20);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Glow effect
    final glowPaint = Paint()
      ..color = (sliderTheme.thumbColor ?? AppColors.primary).withAlpha(76)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, 12, glowPaint);

    // Main thumb
    final thumbPaint = Paint()
      ..color = sliderTheme.thumbColor ?? AppColors.primary;

    canvas.drawCircle(center, 8, thumbPaint);

    // Inner highlight
    final highlightPaint = Paint()..color = Colors.white.withAlpha(128);

    canvas.drawCircle(Offset(center.dx - 2, center.dy - 2), 3, highlightPaint);
  }
}
