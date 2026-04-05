import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Support Us Screen — matches Stitch design: 36_support_us_mobile.png
///
/// Mobile-first layout with:
/// - "SUSTAIN THE SANCTUARY" subtitle + "Support MindWeave" title
/// - Funding goal progress bar
/// - One-time donation amount chips
/// - Monthly tier cards (Supporter, Mindweaver, Guardian)
/// - Other ways to help section
class SupportUsScreen extends StatefulWidget {
  const SupportUsScreen({super.key});

  @override
  State<SupportUsScreen> createState() => _SupportUsScreenState();
}

class _SupportUsScreenState extends State<SupportUsScreen> {
  int _selectedAmount = 25;

  @override
  Widget build(BuildContext context) {
    final hPad = SpacingTokens.lg;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SUSTAIN THE SANCTUARY',
              style: TypographyTokens.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: SpacingTokens.sm),
            Text(
              'Support\nMindWeave.',
              style: TypographyTokens.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            Text(
              'MindWeave is a community-funded project. Your support keeps the frequencies flowing.',
              style: TypographyTokens.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),

            // Funding goal
            Container(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadiusTokens.card,
                border: Border.all(
                  color: AppColors.outlineVariant.withAlpha(38),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monthly Funding Goal',
                        style: TypographyTokens.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$3,247 / \$5,000',
                        style: TypographyTokens.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.65,
                      backgroundColor: AppColors.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    '42 supporters this month',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),

            // One-time donation
            Text(
              'ONE-TIME DONATION',
              style: TypographyTokens.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            Row(
              children: [5, 10, 25, 50, 100].map((amount) {
                final isSelected = amount == _selectedAmount;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedAmount = amount),
                    child: Container(
                      margin: const EdgeInsets.only(right: SpacingTokens.xs),
                      padding: const EdgeInsets.symmetric(
                        vertical: SpacingTokens.md,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withAlpha(38)
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadiusTokens.mdCircular,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.outlineVariant.withAlpha(38),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '\$$amount',
                          style: TypographyTokens.labelLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: SpacingTokens.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    vertical: SpacingTokens.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusTokens.mdCircular,
                  ),
                ),
                child: Text('Donate \$$_selectedAmount'),
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),

            // Monthly tiers
            Text(
              'MONTHLY TIERS',
              style: TypographyTokens.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            _tierRow(
              Icons.coffee,
              'Supporter',
              '\$5/mo',
              'Badge + Early access',
            ),
            _tierRow(
              Icons.star,
              'Mindweaver',
              '\$15/mo',
              'Custom presets + Discord',
            ),
            _tierRow(
              Icons.diamond,
              'Guardian',
              '\$50/mo',
              '1-on-1 sessions + Credits',
            ),
            const SizedBox(height: SpacingTokens.xxl),

            // Other ways
            Text(
              'OTHER WAYS TO HELP',
              style: TypographyTokens.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            _helpRow(
              Icons.share_outlined,
              'Share MindWeave',
              'Spread the word on social media',
            ),
            _helpRow(
              Icons.star_outline,
              'Rate the App',
              'Leave a review on the App Store',
            ),
            _helpRow(
              Icons.code,
              'Contribute Code',
              'Open-source contributions welcome',
            ),
            _helpRow(
              Icons.currency_bitcoin,
              'Crypto Donation',
              'Support with BTC, ETH, SOL',
            ),
            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
    );
  }

  static Widget _tierRow(
    IconData icon,
    String name,
    String price,
    String desc,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: SpacingTokens.sm),
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: SpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TypographyTokens.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  desc,
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TypographyTokens.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _helpRow(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: SpacingTokens.sm),
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadiusTokens.mdCircular,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: SpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TypographyTokens.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  desc,
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
