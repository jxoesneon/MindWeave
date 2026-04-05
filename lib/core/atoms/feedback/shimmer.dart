import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../theme/app_colors.dart';

/// Shimmer/Skeleton Loading Atom
///
/// Placeholder for loading states with animated shimmer effect.
/// Follows ui-ux-pro-max loading guidelines.
///
/// Usage:
/// ```dart
/// MwShimmer(
///   child: Container(
///     height: 100,
///     width: double.infinity,
///   ),
/// )
/// ```text
class MwShimmer extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const MwShimmer({super.key, required this.child, this.isLoading = true});

  @override
  State<MwShimmer> createState() => _MwShimmerState();
}

class _MwShimmerState extends State<MwShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationTokens.shimmerPulse,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              // ignore: prefer_const_literals_to_create_immutables
              colors: [
                AppColors.surfaceContainerLow,
                AppColors.surfaceContainerHigh,
                AppColors.surfaceContainerLow,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              transform: _ShimmerTransform(_controller.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
    );
  }
}

class _ShimmerTransform extends GradientTransform {
  final double progress;

  const _ShimmerTransform(this.progress);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final slideWidth = bounds.width * 2;
    final offset = progress * slideWidth - slideWidth / 2;
    return Matrix4.translationValues(offset, 0, 0);
  }
}

/// Skeleton Text - Pre-configured shimmer for text placeholders
class MwSkeletonText extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double? width;

  const MwSkeletonText({
    super.key,
    this.lines = 1,
    this.lineHeight = 14,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLast = index == lines - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : SpacingTokens.xs),
          child: MwShimmer(
            child: Container(
              height: lineHeight,
              width: width ?? double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadiusTokens.smCircular,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Skeleton Card - Pre-configured shimmer for card placeholders
class MwSkeletonCard extends StatelessWidget {
  final double height;

  const MwSkeletonCard({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return MwShimmer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadiusTokens.mdCircular,
        ),
      ),
    );
  }
}
