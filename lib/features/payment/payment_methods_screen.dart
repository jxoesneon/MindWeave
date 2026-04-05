import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Payment Methods Screen — matches Stitch design: 11_open_finances_transparency.png
///
/// Mobile-first layout with:
/// - "PAYMENT OPTIONS" subtitle + "Choose Your Method" title
/// - Payment method cards: Apple Pay, Credit Card, Crypto, PayPal
/// - Selected method details section
/// - Secure checkout button
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedIndex = 0;

  final _methods = const [
    _PayMethod(Icons.apple, 'Apple Pay', 'Instant • No fees'),
    _PayMethod(Icons.credit_card, 'Credit Card', 'Visa, Mastercard, AMEX'),
    _PayMethod(Icons.currency_bitcoin, 'Cryptocurrency', 'BTC, ETH, SOL, USDC'),
    _PayMethod(Icons.account_balance_wallet, 'PayPal', 'PayPal account'),
  ];

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
              'PAYMENT OPTIONS',
              style: TypographyTokens.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: SpacingTokens.sm),
            Text(
              'Choose Your\nMethod.',
              style: TypographyTokens.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
            const SizedBox(height: SpacingTokens.md),
            Text(
              'Select your preferred payment method to support MindWeave.',
              style: TypographyTokens.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: SpacingTokens.xxl),

            // Method cards
            ...List.generate(_methods.length, (index) {
              final method = _methods[index];
              final isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: SpacingTokens.sm),
                  padding: const EdgeInsets.all(SpacingTokens.lg),
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
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withAlpha(38)
                              : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadiusTokens.mdCircular,
                        ),
                        child: Icon(
                          method.icon,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.name,
                              style: TypographyTokens.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              method.desc,
                              style: TypographyTokens.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 22),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: SpacingTokens.xxl),

            // Order summary
            Container(
              padding: const EdgeInsets.all(SpacingTokens.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadiusTokens.card,
                border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
              ),
              child: Column(
                children: [
                  _summaryRow('Subtotal', '\$10.00'),
                  const SizedBox(height: SpacingTokens.sm),
                  _summaryRow('Processing Fee', '\$0.00'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: SpacingTokens.sm),
                    child: Divider(color: AppColors.outlineVariant),
                  ),
                  _summaryRow('Total', '\$10.00', isBold: true),
                ],
              ),
            ),

            const SizedBox(height: SpacingTokens.xl),

            // Checkout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: SpacingTokens.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusTokens.mdCircular,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, size: 16),
                    const SizedBox(width: SpacingTokens.sm),
                    Text(
                      'Secure Checkout',
                      style: TypographyTokens.button.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: SpacingTokens.md),

            // Security note
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_outlined,
                      size: 14, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    'Encrypted & Secure',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingTokens.xxl),
          ],
        ),
      ),
    );
  }

  static Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? TypographyTokens.titleSmall.copyWith(fontWeight: FontWeight.w700)
              : TypographyTokens.bodySmall
                  .copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: isBold
              ? TypographyTokens.titleSmall.copyWith(fontWeight: FontWeight.w700)
              : TypographyTokens.bodySmall
                  .copyWith(color: AppColors.onSurface),
        ),
      ],
    );
  }
}

class _PayMethod {
  final IconData icon;
  final String name;
  final String desc;
  const _PayMethod(this.icon, this.name, this.desc);
}
