import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Tier Payment Screen — matches Stitch design: 33_tier_management.png
///
/// Features:
/// - "CHOOSE YOUR PATH" subtitle + "Tier Management" title
/// - Three tier cards: Supporter, Mindweaver, Guardian
/// - Feature comparison table
/// - Current plan indicator
/// - Upgrade / Change Plan buttons
class TierPaymentScreen extends StatefulWidget {
  const TierPaymentScreen({super.key});

  @override
  State<TierPaymentScreen> createState() => _TierPaymentScreenState();
}

class _TierPaymentScreenState extends State<TierPaymentScreen> {
  int _selectedTier = 1;

  final _tiers = const [
    _Tier('Supporter', '\$5', '/month', Icons.coffee,
        ['Exclusive badge', 'Early access to frequencies', 'Website recognition'],
        false),
    _Tier('Mindweaver', '\$15', '/month', Icons.star,
        ['All Supporter benefits', 'Custom preset creation', 'Discord access', 'Monthly wellness report'],
        true),
    _Tier('Guardian', '\$50', '/month', Icons.diamond,
        ['All Mindweaver benefits', '1-on-1 consultation', 'Name in app credits', 'Beta features'],
        false),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;

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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                Text(
                  'CHOOSE YOUR PATH',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Tier Management.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'Support MindWeave at a level that resonates with you. Every tier helps sustain the sanctuary.',
                  textAlign: TextAlign.center,
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xxl),

                // Tier cards
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(_tiers.length, (i) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i < _tiers.length - 1
                                    ? SpacingTokens.md
                                    : 0,
                              ),
                              child: _buildTierCard(i),
                            ),
                          );
                        }),
                      )
                    : Column(
                        children: List.generate(_tiers.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: SpacingTokens.md),
                            child: _buildTierCard(i),
                          );
                        }),
                      ),

                const SizedBox(height: SpacingTokens.xxl),

                // Guarantee
                Container(
                  padding: const EdgeInsets.all(SpacingTokens.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadiusTokens.card,
                    border: Border.all(
                        color: AppColors.outlineVariant.withAlpha(38)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_outlined,
                          size: 24, color: AppColors.primary),
                      const SizedBox(width: SpacingTokens.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancel Anytime',
                              style: TypographyTokens.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'No lock-in contracts. Downgrade or cancel your subscription at any time with no questions asked.',
                              style: TypographyTokens.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: SpacingTokens.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTierCard(int index) {
    final tier = _tiers[index];
    final isSelected = index == _selectedTier;

    return GestureDetector(
      onTap: () => setState(() => _selectedTier = index),
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.xl),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(13)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadiusTokens.card,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withAlpha(38),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(tier.icon,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    size: 28),
                if (tier.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(38),
                      borderRadius: BorderRadiusTokens.smCircular,
                    ),
                    child: Text(
                      'POPULAR',
                      style: TypographyTokens.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: SpacingTokens.lg),
            Text(
              tier.name,
              style: TypographyTokens.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: SpacingTokens.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  tier.price,
                  style: TypographyTokens.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  tier.period,
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.lg),
            ...tier.benefits.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        size: 16,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant),
                    const SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: Text(
                        b,
                        style: TypographyTokens.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SpacingTokens.lg),
            SizedBox(
              width: double.infinity,
              child: isSelected
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusTokens.mdCircular,
                        ),
                      ),
                      child: const Text('Select Plan'),
                    )
                  : OutlinedButton(
                      onPressed: () =>
                          setState(() => _selectedTier = index),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onSurface,
                        side: BorderSide(
                            color:
                                AppColors.outlineVariant.withAlpha(77)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusTokens.mdCircular,
                        ),
                      ),
                      child: const Text('Choose'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tier {
  final String name;
  final String price;
  final String period;
  final IconData icon;
  final List<String> benefits;
  final bool isPopular;
  const _Tier(this.name, this.price, this.period, this.icon, this.benefits,
      this.isPopular);
}
