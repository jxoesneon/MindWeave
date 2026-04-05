import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Subscription Success Screen — matches Stitch design: 23_subscription_success.png
///
/// Features:
/// - Centered layout with animated check icon
/// - "Resonance Achieved" title
/// - Confirmation message with tier details
/// - What's Unlocked section with benefit list
/// - Continue to Sanctuary button
/// - Receipt link
class SubscriptionSuccessScreen extends StatelessWidget {
  const SubscriptionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SpacingTokens.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withAlpha(64),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xl),

                  // Title
                  Text(
                    'Resonance\nAchieved.',
                    textAlign: TextAlign.center,
                    style: TypographyTokens.displaySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.md),

                  // Confirmation
                  Text(
                    'Your Mindweaver tier is now active. Thank you for supporting the MindWeave sanctuary.',
                    textAlign: TextAlign.center,
                    style: TypographyTokens.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xxl),

                  // What's Unlocked
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(SpacingTokens.xl),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadiusTokens.card,
                      border: Border.all(
                          color: AppColors.outlineVariant.withAlpha(38)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "WHAT'S UNLOCKED",
                          style: TypographyTokens.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: SpacingTokens.lg),
                        _benefitRow('Custom preset creation tools'),
                        _benefitRow('Exclusive Discord community'),
                        _benefitRow('Monthly wellness report'),
                        _benefitRow('Early access to new frequencies'),
                        _benefitRow('Ad-free experience'),
                      ],
                    ),
                  ),

                  const SizedBox(height: SpacingTokens.xl),

                  // Transaction summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(SpacingTokens.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadiusTokens.card,
                      border: Border.all(
                          color: AppColors.outlineVariant.withAlpha(38)),
                    ),
                    child: Column(
                      children: [
                        _detailRow('Plan', 'Mindweaver'),
                        const SizedBox(height: SpacingTokens.sm),
                        _detailRow('Amount', '\$15.00/month'),
                        const SizedBox(height: SpacingTokens.sm),
                        _detailRow('Next billing', 'Nov 15, 2025'),
                        const SizedBox(height: SpacingTokens.sm),
                        _detailRow('Payment', 'Apple Pay'),
                      ],
                    ),
                  ),

                  const SizedBox(height: SpacingTokens.xxl),

                  // CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            vertical: SpacingTokens.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusTokens.mdCircular,
                        ),
                      ),
                      child: const Text('Continue to Sanctuary'),
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.md),

                  // Receipt link
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View Receipt',
                      style: TypographyTokens.labelSmall.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _benefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              size: 18, color: AppColors.primary),
          const SizedBox(width: SpacingTokens.sm),
          Expanded(
            child: Text(
              text,
              style: TypographyTokens.bodySmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TypographyTokens.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TypographyTokens.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
