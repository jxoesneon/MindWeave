import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Player Visualizer Organism
///
/// Animated visualizer for audio playback with frequency bars and
/// brainwave band indicators. Central component of the player screen.
///
/// Usage:
/// ```dart
/// PlayerVisualizer(
///   isPlaying: true,
///   primaryBand: BrainwaveBand.gamma,
///   frequency: 40.0,
/// )
/// ```text
class PlayerVisualizer extends StatefulWidget {
  final bool isPlaying;
  final Color? primaryColor;
  final double intensity;

  const PlayerVisualizer({
    super.key,
    this.isPlaying = false,
    this.primaryColor,
    this.intensity = 0.7,
  });

  @override
  State<PlayerVisualizer> createState() => _PlayerVisualizerState();
}

class _PlayerVisualizerState extends State<PlayerVisualizer>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final int _barCount = 12;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _barCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600 + (index * 50)),
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: AnimationTokens.standardCurve,
        ),
      );
    }).toList();
  }

  @override
  void didUpdateWidget(PlayerVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        for (final controller in _controllers) {
          controller.repeat(reverse: true);
        }
      } else {
        for (final controller in _controllers) {
          controller.stop();
          controller.value = 0.3;
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.primaryColor ?? AppColors.primary;

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_barCount, (index) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  final height = widget.isPlaying
                      ? 40 + (_animations[index].value * 120 * widget.intensity)
                      : 20.0;

                  return Container(
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [color.withAlpha(76), color],
                      ),
                      borderRadius: BorderRadiusTokens.fullCircular,
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha(widget.isPlaying ? 102 : 51),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Circular Frequency Dial Organism
///
/// Circular display showing current frequency with animated ring.
///
/// Usage:
/// ```dart
/// FrequencyDial(
///   frequency: 40.0,
///   band: BrainwaveBand.gamma,
///   isPlaying: true,
/// )
/// ```text
class FrequencyDial extends StatelessWidget {
  final double frequency;
  final Color? accentColor;
  final bool isPlaying;
  final double size;
  final Duration? remainingTime;

  const FrequencyDial({
    super.key,
    required this.frequency,
    this.accentColor,
    this.isPlaying = false,
    this.size = 200,
    this.remainingTime,
  });

  String _formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    final showTimer = isPlaying && remainingTime != null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withAlpha(51), Colors.transparent],
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.85,
          height: size * 0.85,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withAlpha(isPlaying ? 204 : 102),
              width: 3,
            ),
            boxShadow: isPlaying
                ? [
                    BoxShadow(
                      color: color.withAlpha(128),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showTimer)
                  Text(
                    _formatTime(remainingTime!),
                    style: TypographyTokens.timeDisplay.copyWith(
                      color: AppColors.onSurface,
                    ),
                  )
                else
                  Text(
                    frequency.toStringAsFixed(1),
                    style: TypographyTokens.displayMedium.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                Text(
                  showTimer ? '' : 'Hz',
                  style: TypographyTokens.labelLarge.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
