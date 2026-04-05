import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Sine Wave Atom
///
/// Renders an animated or static sine wave visualization.
/// Used for spectral resonance displays and audio frequency visualizations.
///
/// Usage:
/// ```dart
/// MwSineWave(
///   amplitude: 0.8,
///   frequency: 2.0,
///   color: AppColors.primary,
/// )
/// ```
class MwSineWave extends StatelessWidget {
  final double amplitude;
  final double frequency;
  final Color color;
  final double strokeWidth;
  final bool animated;
  final int phaseShift;
  final double opacity;

  const MwSineWave({
    super.key,
    this.amplitude = 0.5,
    this.frequency = 1.0,
    required this.color,
    this.strokeWidth = 2.0,
    this.animated = false,
    this.phaseShift = 0,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return animated
        ? _AnimatedSineWave(
            amplitude: amplitude,
            frequency: frequency,
            color: color,
            strokeWidth: strokeWidth,
            phaseShift: phaseShift,
            opacity: opacity,
          )
        : _StaticSineWave(
            amplitude: amplitude,
            frequency: frequency,
            color: color,
            strokeWidth: strokeWidth,
            phaseShift: phaseShift,
            opacity: opacity,
          );
  }
}

class _StaticSineWave extends StatelessWidget {
  final double amplitude;
  final double frequency;
  final Color color;
  final double strokeWidth;
  final int phaseShift;
  final double opacity;

  const _StaticSineWave({
    required this.amplitude,
    required this.frequency,
    required this.color,
    required this.strokeWidth,
    required this.phaseShift,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SineWavePainter(
        amplitude: amplitude,
        frequency: frequency,
        color: color,
        strokeWidth: strokeWidth,
        phaseShift: phaseShift,
        opacity: opacity,
      ),
      size: Size.infinite,
    );
  }
}

class _AnimatedSineWave extends StatefulWidget {
  final double amplitude;
  final double frequency;
  final Color color;
  final double strokeWidth;
  final int phaseShift;
  final double opacity;

  const _AnimatedSineWave({
    required this.amplitude,
    required this.frequency,
    required this.color,
    required this.strokeWidth,
    required this.phaseShift,
    required this.opacity,
  });

  @override
  State<_AnimatedSineWave> createState() => _AnimatedSineWaveState();
}

class _AnimatedSineWaveState extends State<_AnimatedSineWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SineWavePainter(
            amplitude: widget.amplitude,
            frequency: widget.frequency,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            phaseShift: widget.phaseShift,
            opacity: widget.opacity,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _SineWavePainter extends CustomPainter {
  final double amplitude;
  final double frequency;
  final Color color;
  final double strokeWidth;
  final int phaseShift;
  final double opacity;
  final double? animationValue;

  _SineWavePainter({
    required this.amplitude,
    required this.frequency,
    required this.color,
    required this.strokeWidth,
    required this.phaseShift,
    required this.opacity,
    this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final centerY = size.height / 2;
    final maxAmplitude = size.height * amplitude * 0.4;

    // Calculate phase offset for animation or static phase
    final phaseOffset = animationValue != null
        ? animationValue! * 2 * math.pi
        : phaseShift * math.pi / 4;

    // Start point
    path.moveTo(0, centerY);

    // Generate sine wave points
    const points = 100;
    for (int i = 0; i <= points; i++) {
      final x = (i / points) * size.width;
      final normalizedX = (i / points) * frequency * 2 * math.pi;
      final y = centerY + math.sin(normalizedX + phaseOffset) * maxAmplitude;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SineWavePainter oldDelegate) {
    return oldDelegate.amplitude != amplitude ||
        oldDelegate.frequency != frequency ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.phaseShift != phaseShift ||
        oldDelegate.opacity != opacity ||
        oldDelegate.animationValue != animationValue;
  }
}
