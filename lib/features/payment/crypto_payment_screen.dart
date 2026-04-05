import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Crypto Payment Screen — matches Stitch designs: 01/05_crypto_payment.png
///
/// Features:
/// - "DECENTRALIZED SUPPORT" subtitle + "Support with Crypto" title
/// - Wallet address display with copy button
/// - QR code placeholder
/// - Supported cryptocurrencies grid (BTC, ETH, SOL, USDC)
/// - Transaction status section
/// - Security notice
class CryptoPaymentScreen extends StatelessWidget {
  const CryptoPaymentScreen({super.key});

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
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DECENTRALIZED SUPPORT',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Support with\nCrypto.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'Contribute to MindWeave using your preferred cryptocurrency. All transactions are verified on-chain.',
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xxl),

                // Supported Currencies
                Text(
                  'SELECT CURRENCY',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                const Row(
                  children: [
                    Expanded(
                      child: _CurrencyCard(
                        symbol: 'BTC',
                        name: 'Bitcoin',
                        isSelected: true,
                      ),
                    ),
                    SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: _CurrencyCard(
                        symbol: 'ETH',
                        name: 'Ethereum',
                        isSelected: false,
                      ),
                    ),
                    SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: _CurrencyCard(
                        symbol: 'SOL',
                        name: 'Solana',
                        isSelected: false,
                      ),
                    ),
                    SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: _CurrencyCard(
                        symbol: 'USDC',
                        name: 'USD Coin',
                        isSelected: false,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: SpacingTokens.xl),

                // Wallet address + QR
                Container(
                  padding: const EdgeInsets.all(SpacingTokens.xl),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadiusTokens.card,
                    border: Border.all(
                      color: AppColors.outlineVariant.withAlpha(38),
                    ),
                  ),
                  child: Column(
                    children: [
                      // QR placeholder
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadiusTokens.mdCircular,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.qr_code_2,
                            size: 80,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.lg),
                      Text(
                        'Wallet Address',
                        style: TypographyTokens.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SpacingTokens.md,
                          vertical: SpacingTokens.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadiusTokens.smCircular,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'bc1qxy2kgdyg...j0a5e9hx5c',
                                style: TypographyTokens.bodySmall.copyWith(
                                  fontFamily: 'Space Grotesk',
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: SpacingTokens.sm),
                            const Icon(
                              Icons.copy,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: SpacingTokens.xl),

                // Amount selection
                Text(
                  'AMOUNT',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                const Row(
                  children: [
                    Expanded(
                      child: _AmountChip(label: '\$10', isSelected: false),
                    ),
                    SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: _AmountChip(label: '\$25', isSelected: true),
                    ),
                    SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: _AmountChip(label: '\$50', isSelected: false),
                    ),
                    SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: _AmountChip(label: 'Custom', isSelected: false),
                    ),
                  ],
                ),

                const SizedBox(height: SpacingTokens.xl),

                // Security notice
                Container(
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(13),
                    borderRadius: BorderRadiusTokens.mdCircular,
                    border: Border.all(color: AppColors.primary.withAlpha(38)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                      Expanded(
                        child: Text(
                          'All crypto transactions are verified on-chain. No personal data is collected during the payment process.',
                          style: TypographyTokens.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
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
}

class _CurrencyCard extends StatelessWidget {
  final String symbol;
  final String name;
  final bool isSelected;

  const _CurrencyCard({
    required this.symbol,
    required this.name,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withAlpha(26)
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
        children: [
          Text(
            symbol,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.primary : AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _AmountChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: SpacingTokens.md),
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
          label,
          style: TypographyTokens.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
