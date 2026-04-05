import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../tokens/shadow_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';
import '../../tokens/component_types.dart';

/// Primary Button Atom
///
/// Filled button with primary brand color and pill shape.
/// Follows ui-ux-pro-max guidelines:
/// - Touch target: 44pt minimum
/// - Press feedback within 100ms
/// - Clear visual hierarchy
///
/// Usage:
/// ```dart
/// MwPrimaryButton(
///   onPressed: () {},
///   label: 'Get Started',
///   icon: Icons.arrow_forward,
/// )
/// ```text
class MwPrimaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonSize size;

  const MwPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = ButtonSize.medium,
  });

  @override
  State<MwPrimaryButton> createState() => _MwPrimaryButtonState();
}

class _MwPrimaryButtonState extends State<MwPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationTokens.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationTokens.standardCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusTokens.button,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: widget.onPressed != null && !widget.isLoading
                    ? ShadowTokens.buttonGlow
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadiusTokens.button,
                  splashColor: AppColors.onPrimary.withAlpha(51),
                  child: Container(
                    padding: padding,
                    constraints: const BoxConstraints(
                      minWidth: SpacingTokens.minTouchTarget,
                      minHeight: SpacingTokens.minTouchTarget,
                    ),
                    width: widget.isFullWidth ? double.infinity : null,
                    child: widget.isLoading
                        // ignore: prefer_const_constructors
                        ? SizedBox(
                            height: fontSize,
                            width: fontSize,
                            // ignore: prefer_const_constructors
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              // ignore: prefer_const_constructors
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.onPrimary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.label,
                                style: TypographyTokens.button.copyWith(
                                  fontSize: fontSize,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                              if (widget.icon != null) ...[
                                const SizedBox(width: SpacingTokens.xs),
                                // ignore: prefer_const_constructors
                                Icon(
                                  widget.icon,
                                  color: AppColors.onPrimary,
                                  size: fontSize + 4,
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
