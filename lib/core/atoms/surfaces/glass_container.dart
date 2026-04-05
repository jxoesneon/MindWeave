import 'dart:ui';
import 'package:flutter/material.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/shadow_tokens.dart';
import '../../theme/app_colors.dart';

/// Glass Container Atom
///
/// Frosted glass effect container using BackdropFilter.
/// Core component of Stitch design system glass-morphism aesthetic.
///
/// Usage:
/// ```dart
/// MwGlassContainer(
///   child: Text('Content inside glass'),
/// )
/// ```text
class MwGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final Color? backgroundColor;
  final List<BoxShadow>? shadow;
  final Border? border;
  final double? width;
  final double? height;

  const MwGlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurSigma = 20,
    this.backgroundColor,
    this.shadow,
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadiusTokens.card,
        boxShadow: shadow ?? ShadowTokens.glassShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadiusTokens.card,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  AppColors.surfaceVariant.withAlpha(102), // 40%
              borderRadius: borderRadius ?? BorderRadiusTokens.card,
              border:
                  border ??
                  Border.all(
                    color: AppColors.outlineVariant.withAlpha(76), // 30%
                    width: 1,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
