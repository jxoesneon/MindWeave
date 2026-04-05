import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Daily Sine Wave Atom
///
/// Renders a sine wave that peaks at a specific day position.
/// Used for spectral resonance displays where each day has its own wave.
///
/// The wave is positioned so its crest aligns with the specified day index (0-6)
/// and its amplitude reflects the value for that day.
///
/// Usage:
/// ```dart
/// MwDailySineWave(
///   dayIndex: 0, // Monday
///   amplitude: 0.8,
///   color: AppColors.primary,
/// )
/// ```
class MwDailySineWave extends StatelessWidget {
  /// Day index 0-6 (MON-SUN)
  final int dayIndex;
  
  /// Wave amplitude (0.0 to 1.0) - the value for this day
  final double amplitude;
  
  /// Wave color
  final Color color;
  
  /// Stroke width
  final double strokeWidth;
  
  /// Whether to animate the wave
  final bool animated;
  
  /// Opacity of the wave
  final double opacity;
  
  /// Total number of days (default 7)
  final int totalDays;

  const MwDailySineWave({
    super.key,
    required this.dayIndex,
    required this.amplitude,
    required this.color,
    this.strokeWidth = 2.0,
    this.animated = false,
    this.opacity = 0.8,
    this.totalDays = 7,
  });

  @override
  Widget build(BuildContext context) {
    return animated
        ? _AnimatedDailySineWave(
            dayIndex: dayIndex,
            amplitude: amplitude,
            color: color,
            strokeWidth: strokeWidth,
            opacity: opacity,
            totalDays: totalDays,
          )
        : _StaticDailySineWave(
            dayIndex: dayIndex,
            amplitude: amplitude,
            color: color,
            strokeWidth: strokeWidth,
            opacity: opacity,
            totalDays: totalDays,
          );
  }
}

class _StaticDailySineWave extends StatelessWidget {
  final int dayIndex;
  final double amplitude;
  final Color color;
  final double strokeWidth;
  final double opacity;
  final int totalDays;

  const _StaticDailySineWave({
    required this.dayIndex,
    required this.amplitude,
    required this.color,
    required this.strokeWidth,
    required this.opacity,
    required this.totalDays,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DailySineWavePainter(
        dayIndex: dayIndex,
        amplitude: amplitude,
        color: color,
        strokeWidth: strokeWidth,
        opacity: opacity,
        totalDays: totalDays,
      ),
      size: Size.infinite,
    );
  }
}

class _AnimatedDailySineWave extends StatefulWidget {
  final int dayIndex;
  final double amplitude;
  final Color color;
  final double strokeWidth;
  final double opacity;
  final int totalDays;

  const _AnimatedDailySineWave({
    required this.dayIndex,
    required this.amplitude,
    required this.color,
    required this.strokeWidth,
    required this.opacity,
    required this.totalDays,
  });

  @override
  State<_AnimatedDailySineWave> createState() => _AnimatedDailySineWaveState();
}

class _AnimatedDailySineWaveState extends State<_AnimatedDailySineWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
          painter: _DailySineWavePainter(
            dayIndex: widget.dayIndex,
            amplitude: widget.amplitude,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            opacity: widget.opacity,
            totalDays: widget.totalDays,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _DailySineWavePainter extends CustomPainter {
  final int dayIndex;
  final double amplitude;
  final Color color;
  final double strokeWidth;
  final double opacity;
  final int totalDays;
  final double? animationValue;

  _DailySineWavePainter({
    required this.dayIndex,
    required this.amplitude,
    required this.color,
    required this.strokeWidth,
    required this.opacity,
    required this.totalDays,
    this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitude <= 0.01) return; // Don't draw if no activity

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final centerY = size.height / 2;
    final maxAmplitude = size.height * amplitude * 0.4;

    // Calculate the X position where this wave should peak (center of its day)
    final dayWidth = size.width / totalDays;
    final peakX = (dayIndex * dayWidth) + (dayWidth / 2);

    // Calculate phase offset for animation
    final phaseOffset = animationValue != null
        ? animationValue! * 2 * math.pi
        : 0.0;

    // Generate a localized sine wave that peaks at the day position
    // We use a Gaussian envelope to make the wave localized to its day
    const points = 200;
    
    for (int i = 0; i <= points; i++) {
      final x = (i / points) * size.width;
      
      // Distance from peak position (normalized -1 to 1)
      final distanceFromPeak = (x - peakX) / (dayWidth * 1.5);
      
      // Gaussian envelope - wave is strongest at day position, fades away
      final envelope = math.exp(-distanceFromPeak * distanceFromPeak);
      
      // Sine wave with phase animation
      final normalizedX = (i / points) * 4 * math.pi; // 2 full cycles
      final sineValue = math.sin(normalizedX + phaseOffset);
      
      // Combine envelope and sine
      final y = centerY - (sineValue * maxAmplitude * envelope);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DailySineWavePainter oldDelegate) {
    return oldDelegate.dayIndex != dayIndex ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.opacity != opacity ||
        oldDelegate.totalDays != totalDays ||
        oldDelegate.animationValue != animationValue;
  }
}
