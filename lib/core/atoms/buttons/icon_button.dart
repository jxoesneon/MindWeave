import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../theme/app_colors.dart';

/// Icon Button Atom
///
/// Circular button containing only an icon.
/// Follows ui-ux-pro-max:
/// - Touch target: 44pt minimum (even if icon is smaller)
/// - Clear press feedback
/// - Optional tonal background
///
/// Usage:
/// ```dart
/// MwIconButton(
///   onPressed: () {},
///   icon: Icons.favorite,
///   tooltip: 'Add to favorites',
/// )
/// ```text
class MwIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final bool isSelected;
  final IconData? selectedIcon;
  final Color? color;
  final Color? backgroundColor;
  final double size;

  const MwIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.isSelected = false,
    this.selectedIcon,
    this.color,
    this.backgroundColor,
    this.size = 24,
  });

  @override
  State<MwIconButton> createState() => _MwIconButtonState();
}

class _MwIconButtonState extends State<MwIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationTokens.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
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
    final iconData = widget.isSelected && widget.selectedIcon != null
        ? widget.selectedIcon!
        : widget.icon;

    final iconColor =
        widget.color ??
        (widget.isSelected ? AppColors.primary : AppColors.onSurfaceVariant);

    final bgColor =
        widget.backgroundColor ??
        (widget.isSelected
            ? AppColors.primaryContainer.withAlpha(51)
            : (_isHovered
                  ? AppColors.surfaceContainerHigh
                  : Colors.transparent));

    Widget button = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: AnimationTokens.fast,
                curve: AnimationTokens.standardCurve,
                width: SpacingTokens.minTouchTarget,
                height: SpacingTokens.minTouchTarget,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: widget.onPressed != null
                      ? iconColor
                      : iconColor.withAlpha(128),
                  size: widget.size,
                ),
              ),
            );
          },
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        preferBelow: true,
        child: button,
      );
    }

    return button;
  }
}
