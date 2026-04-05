import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Crypto FAQ Screen — matches Stitch design: 03_crypto_faq_dashboard.png
///
/// Features:
/// - "CRYPTO KNOWLEDGE BASE" subtitle + "Crypto FAQ" title
/// - Search bar
/// - FAQ categories: Getting Started, Wallets, Transactions, Security
/// - Expandable FAQ items
/// - Still Have Questions CTA
class CryptoFaqScreen extends StatelessWidget {
  const CryptoFaqScreen({super.key});

  static const _faqs = [
    _FaqItem('What cryptocurrencies does MindWeave accept?',
        'We currently accept Bitcoin (BTC), Ethereum (ETH), Solana (SOL), and USD Coin (USDC). We plan to expand to additional networks based on community demand.'),
    _FaqItem('How do I set up a crypto wallet?',
        'We recommend using a self-custody wallet like MetaMask (for ETH/USDC), Phantom (for SOL), or any BTC-compatible wallet. Download from the official website, create a new wallet, and securely backup your seed phrase.'),
    _FaqItem('Are crypto donations tax-deductible?',
        'Tax treatment varies by jurisdiction. In many countries, cryptocurrency donations to open-source projects may qualify for deductions. Consult your local tax advisor for specific guidance.'),
    _FaqItem('How long do transactions take to confirm?',
        'Confirmation times vary: BTC (10-60 min), ETH (15 sec - 5 min), SOL (< 1 sec), USDC (varies by network). We credit your account after 1 confirmation for most chains.'),
    _FaqItem('Is my payment information private?',
        'Yes. We never collect personal data during crypto transactions. Your wallet address is the only identifier, and we do not link it to any personal information.'),
    _FaqItem('What happens if I send the wrong currency?',
        'Unfortunately, blockchain transactions are irreversible. Always verify the network and wallet address before sending. If you accidentally send to the wrong address, recovery is typically not possible.'),
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
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CRYPTO KNOWLEDGE BASE',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Crypto FAQ.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'Everything you need to know about supporting MindWeave with cryptocurrency.',
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xl),

                // Search
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadiusTokens.mdCircular,
                    border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
                  ),
                  child: TextField(
                    style: TypographyTokens.bodyMedium.copyWith(color: AppColors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search FAQ...',
                      hintStyle: TypographyTokens.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                      border: InputBorder.none,
                      icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: SpacingTokens.xl),

                // FAQ items
                ..._faqs.map((faq) => Container(
                      margin: const EdgeInsets.only(bottom: SpacingTokens.sm),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadiusTokens.card,
                        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: SpacingTokens.lg),
                        childrenPadding: const EdgeInsets.fromLTRB(
                            SpacingTokens.lg, 0, SpacingTokens.lg, SpacingTokens.lg),
                        title: Text(
                          faq.question,
                          style: TypographyTokens.titleSmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                        iconColor: AppColors.onSurfaceVariant,
                        collapsedIconColor: AppColors.onSurfaceVariant,
                        children: [
                          Text(
                            faq.answer,
                            style: TypographyTokens.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: SpacingTokens.xl),

                // Still Have Questions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(SpacingTokens.xl),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadiusTokens.card,
                    border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Still Have Questions?',
                        style: TypographyTokens.titleMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      Text(
                        'Our community is always ready to help with crypto-related queries.',
                        textAlign: TextAlign.center,
                        style: TypographyTokens.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.people_outline, size: 16),
                        label: const Text('Ask the Community'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusTokens.fullCircular),
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

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}
