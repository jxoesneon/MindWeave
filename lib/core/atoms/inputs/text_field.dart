import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/border_radius_tokens.dart';
import '../../tokens/animation_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Text Field Atom
///
/// Input field with ghost border on focus (no hard borders at rest).
/// Follows ui-ux-pro-max form guidelines:
/// - Visible label
/// - Clear error placement
/// - 44pt minimum touch height
///
/// Usage:
/// ```dart
/// MwTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   prefixIcon: Icons.email,
/// )
/// ```text
class MwTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;

  const MwTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<MwTextField> createState() => _MwTextFieldState();
}

class _MwTextFieldState extends State<MwTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TypographyTokens.labelMedium.copyWith(
              color: hasError ? AppColors.error : AppColors.onSurface,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
        ],
        AnimatedContainer(
          duration: AnimationTokens.fast,
          curve: AnimationTokens.standardCurve,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusTokens.mdCircular,
            color: widget.enabled
                ? AppColors.surfaceContainerLow
                : AppColors.surfaceContainerLowest,
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : _isFocused
                  ? AppColors.primary
                  : Colors.transparent,
              width: _isFocused || hasError ? 1.5 : 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            onChanged: widget.onChanged,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            style: TypographyTokens.bodyLarge.copyWith(
              color: widget.enabled
                  ? AppColors.onSurface
                  : AppColors.onSurfaceVariant,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TypographyTokens.bodyLarge.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      size: 20,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? GestureDetector(
                      onTap: widget.onSuffixTap,
                      child: Icon(
                        widget.suffixIcon,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.md,
                vertical: SpacingTokens.md,
              ),
              isDense: true,
            ),
          ),
        ),
        if (hasError || widget.helperText != null) ...[
          const SizedBox(height: SpacingTokens.xs),
          Text(
            widget.errorText ?? widget.helperText!,
            style: TypographyTokens.bodySmall.copyWith(
              color: hasError ? AppColors.error : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
