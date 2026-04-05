import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Terms of Service Screen — matches Stitch design: 14_Terms_of_Service.png
///
/// Features:
/// - "LEGAL FRAMEWORK" subtitle + "Terms of Service" title
/// - Effective date & last updated
/// - Numbered sections: Acceptance, License, Prohibited Use, etc.
/// - Accept Terms button at bottom
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
                  'LEGAL FRAMEWORK',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Terms of Service.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'Effective: January 1, 2025 • Last updated: October 2025',
                  style: TypographyTokens.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xl),

                _section('01', 'Acceptance of Terms',
                    'By accessing or using MindWeave, you agree to be bound by these Terms of Service. If you disagree with any part of the terms, you do not have permission to access the service.'),
                _section('02', 'License Grant',
                    'MindWeave grants you a limited, non-exclusive, non-transferable, revocable license to use the application for personal, non-commercial purposes subject to these Terms.'),
                _section('03', 'User Responsibilities',
                    'You are responsible for maintaining the confidentiality of your account. You agree not to share your credentials or allow unauthorized access to your account.'),
                _section('04', 'Prohibited Use',
                    'You may not use MindWeave for any unlawful purpose, to solicit others to perform unlawful acts, or to violate any international, federal, or state regulations.'),
                _section('05', 'Health Disclaimer',
                    'MindWeave is not a medical device. Binaural beats and frequency entrainment are provided for wellness purposes only. Consult a healthcare provider before use if you have epilepsy or other neurological conditions.'),
                _section('06', 'Intellectual Property',
                    'All content, features, and functionality of MindWeave are owned by the project contributors and are protected under open-source licenses as specified in our repository.'),
                _section('07', 'Termination',
                    'We may terminate or suspend your access immediately, without prior notice, for any reason including breach of these Terms.'),

                const SizedBox(height: SpacingTokens.xl),

                // Accept button
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
                    child: const Text('I Accept These Terms'),
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

  static Widget _section(String num, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                num,
                style: TypographyTokens.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: SpacingTokens.sm),
              Text(
                title,
                style: TypographyTokens.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            body,
            style: TypographyTokens.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
