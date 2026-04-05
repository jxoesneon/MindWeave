import 'package:flutter/material.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/component_types.dart';

/// Tonal Container Atom
///
/// Surface using Material 3 tonal hierarchy.
/// No glass effects, pure tonal layering for content grouping.
///
/// Usage:
/// ```dart
/// MwTonalContainer(
///   tonalLevel: TonalLevel.surfaceContainerHigh,
///   child: Text('Content'),
/// )
/// ```text
class MwTonalContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final TonalLevel tonalLevel;
  final List<BoxShadow>? shadow;
  final Border? border;

  const MwTonalContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.tonalLevel = TonalLevel.surfaceContainer,
    this.shadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: tonalLevel.color,
        borderRadius: borderRadius ?? BorderRadiusTokens.mdCircular,
        boxShadow: shadow,
        border: border,
      ),
      child: child,
    );
  }
}
