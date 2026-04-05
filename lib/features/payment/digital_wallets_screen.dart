import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Digital Wallets Screen — matches Stitch design: 04_digital_wallets_management.png
///
/// Features:
/// - "WALLET MANAGEMENT" subtitle + "Digital Wallets" title
/// - Connected wallets list with status indicators
/// - Add new wallet button
/// - Transaction history section
/// - Wallet security tips
class DigitalWalletsScreen extends StatelessWidget {
  const DigitalWalletsScreen({super.key});

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
                  'WALLET MANAGEMENT',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Digital Wallets.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'Manage your connected wallets for seamless crypto contributions.',
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xxl),

                // Connected wallets
                Text(
                  'CONNECTED WALLETS',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                _walletCard('MetaMask', '0x7a3d...8f2c', 'Ethereum', true),
                _walletCard('Phantom', 'Gh4x...9kLp', 'Solana', true),
                _walletCard('Ledger Nano', 'bc1q...h5xc', 'Bitcoin', false),

                const SizedBox(height: SpacingTokens.lg),

                // Add wallet button
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Connect New Wallet'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withAlpha(128)),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusTokens.mdCircular,
                    ),
                  ),
                ),

                const SizedBox(height: SpacingTokens.xxl),

                // Recent Transactions
                Text(
                  'RECENT TRANSACTIONS',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadiusTokens.card,
                    border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
                  ),
                  child: Column(
                    children: [
                      _txRow('Donation', 'MetaMask → MindWeave', '0.015 ETH', 'Confirmed'),
                      const Divider(color: AppColors.outlineVariant, height: 1),
                      _txRow('Monthly Support', 'Phantom → MindWeave', '2.5 SOL', 'Confirmed'),
                      const Divider(color: AppColors.outlineVariant, height: 1),
                      _txRow('One-time', 'MetaMask → MindWeave', '25 USDC', 'Pending'),
                    ],
                  ),
                ),

                const SizedBox(height: SpacingTokens.xxl),

                // Security tips
                Container(
                  padding: const EdgeInsets.all(SpacingTokens.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadiusTokens.card,
                    border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined, size: 18, color: AppColors.primary),
                          const SizedBox(width: SpacingTokens.sm),
                          Text(
                            'Wallet Security Tips',
                            style: TypographyTokens.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      _tipRow('Never share your seed phrase with anyone'),
                      _tipRow('Use hardware wallets for large holdings'),
                      _tipRow('Verify wallet addresses before sending'),
                      _tipRow('Enable 2FA on all exchange accounts'),
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

  static Widget _walletCard(
      String name, String address, String network, bool isConnected) {
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadiusTokens.mdCircular,
            ),
            child: const Icon(Icons.account_balance_wallet,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: SpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TypographyTokens.titleSmall
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(
                  '$address • $network',
                  style: TypographyTokens.labelSmall
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected
                  ? const Color(0xFF2E7D32).withAlpha(26)
                  : AppColors.outlineVariant.withAlpha(26),
              borderRadius: BorderRadiusTokens.smCircular,
            ),
            child: Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: TypographyTokens.labelSmall.copyWith(
                color: isConnected
                    ? const Color(0xFF2E7D32)
                    : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _txRow(
      String type, String desc, String amount, String status) {
    final isPending = status == 'Pending';
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.lg, vertical: SpacingTokens.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type,
                    style: TypographyTokens.titleSmall
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(desc,
                    style: TypographyTokens.labelSmall
                        .copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: TypographyTokens.labelMedium
                      .copyWith(fontWeight: FontWeight.w700)),
              Text(
                status,
                style: TypographyTokens.labelSmall.copyWith(
                  color: isPending
                      ? const Color(0xFFF57C00)
                      : const Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _tipRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
          const SizedBox(width: SpacingTokens.sm),
          Expanded(
            child: Text(
              text,
              style: TypographyTokens.bodySmall
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
