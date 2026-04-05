import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../tokens/component_types.dart';

/// Secondary Button Atom
///
/// Ghost/outlined button for secondary actions.
/// Uses tonal border that appears on focus/hover.
/// Follows ui-ux-pro-max "No hard borders" rule from Stitch design.
///
/// Usage:
/// ```dart
/// MwSecondaryButton(
///   onPressed: () {},
///   label: 'Cancel',
/// )
/// ```text
class MwSecondaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isFullWidth;
  final ButtonSize size;

  const MwSecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isFullWidth = false,
    this.size = ButtonSize.medium,
  });

  @override
  State<MwSecondaryButton> createState() => _MwSecondaryButtonState();
}

class _MwSecondaryButtonState extends State<MwSecondaryButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final padding = switch (widget.size) {
      ButtonSize.small => const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.xs,
      ),
      ButtonSize.medium => const EdgeInsets.symmetric(
        horizontal: SpacingTokens.lg,
        vertical: SpacingTokens.sm,
      ),
      ButtonSize.large => const EdgeInsets.symmetric(
        horizontal: SpacingTokens.xl,
        vertical: SpacingTokens.md,
      ),
    };

    final fontSize = switch (widget.size) {
      ButtonSize.small => 12.0,
      ButtonSize.medium => 14.0,
      ButtonSize.large => 16.0,
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: AnimationTokens.fast,
          curve: AnimationTokens.standardCurve,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusTokens.button,
            color: _isPressed
                ? AppColors.surfaceContainerHigh
                : _isHovered
                ? AppColors.surfaceContainer
                : Colors.transparent,
            border: Border.all(
              color: _isHovered || _isPressed
                  ? AppColors.outlineVariant
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadiusTokens.button,
              splashColor: AppColors.primary.withAlpha(25),
              child: Container(
                padding: padding,
                constraints: const BoxConstraints(
                  minWidth: SpacingTokens.minTouchTarget,
                  minHeight: SpacingTokens.minTouchTarget,
                ),
                width: widget.isFullWidth ? double.infinity : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: AppColors.onSurface,
                        size: fontSize + 4,
                      ),
                      const SizedBox(width: SpacingTokens.xs),
                    ],
                    Text(
                      widget.label,
                      style: TypographyTokens.labelLarge.copyWith(
                        fontSize: fontSize,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
