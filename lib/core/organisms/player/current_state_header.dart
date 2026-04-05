import 'package:flutter/material.dart';
import '../../tokens/spacing_tokens.dart';
import '../../theme/app_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Current State Header Organism
///
/// Displays the current brainwave state with editorial typography.
/// Matches Stitch design: "CURRENT STATE" label + large display headline + subtitle.
///
/// Usage:
/// ```dart
/// CurrentStateHeader(
///   stateName: 'Deep Theta Flow',
///   description: 'Synchronizing neural pathways for deep creative resonance',
/// )
/// ```
class CurrentStateHeader extends StatelessWidget {
  final String stateName;
  final String? description;

  const CurrentStateHeader({
    super.key,
    required this.stateName,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // "CURRENT STATE" overline label
        Text(
          'CURRENT STATE',
          style: TypographyTokens.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: SpacingTokens.xs),
        // Large display headline
        Text(
          stateName,
          style: TypographyTokens.displaySmall.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        if (description != null) ...[
          const SizedBox(height: SpacingTokens.sm),
          Text(
            description!,
            style: TypographyTokens.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
