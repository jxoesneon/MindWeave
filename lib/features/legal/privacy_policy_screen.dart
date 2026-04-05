import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Privacy Policy Screen — matches Stitch design: 25_payment_success.png
///
/// Features:
/// - "Privacy as a Frequency" hero title
/// - Subtitle explaining privacy philosophy
/// - Numbered sections: Introduction, Data Collection, Gentle Data Usage,
///   Third-Party Integration, User Rights
/// - Have Questions? CTA at bottom
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                // Hero
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Privacy as a\nFrequency.',
                        textAlign: TextAlign.center,
                        style: TypographyTokens.displaySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      Text(
                        'At MindWeave, we believe your neurological data and the frequencies of your being are sacred. Our Privacy Policy is designed to be as transparent and harmonious as our frequencies.',
                        textAlign: TextAlign.center,
                        style: TypographyTokens.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SpacingTokens.xxl),

                _section('01', 'Introduction',
                    'Welcome to the MindWeave privacy sanctuary. This Privacy Policy describes our commitment to protecting your data, detailing what we collect, how it\'s used, and your rights. We operate from a place of radical transparency.',
                    null),
                _section('02', 'Data Collection',
                    'We collect minimal data necessary to personalize your experience:',
                    [
                      'Session duration and frequency preferences',
                      'Anonymized usage patterns for app improvement',
                      'Account information you voluntarily provide',
                    ]),
                _section('03', 'Gentle Data Usage',
                    'Your data flows through our systems with purpose:',
                    [
                      'Data Engineering: To understand how users interact with frequencies and optimize generation',
                      'Machine Learning: Anonymized, aggregated data may be used to improve recommendation algorithms',
                    ]),
                _section('04', 'Third-Party Integration',
                    'MindWeave utilizes select third-party services to enhance functionality, including:',
                    [
                      'Authentication providers',
                      'Anonymous analytics (opt-in only)',
                      'Cloud infrastructure for data storage',
                    ]),
                _section('05', 'User Rights',
                    'You maintain sovereignty over your data at all times:',
                    [
                      'Right to Access: View all data we hold about you',
                      'Right to Delete: Request complete data removal',
                      'Right to Portability: Export your data in standard formats',
                    ]),

                const SizedBox(height: SpacingTokens.xl),

                // Have Questions CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(SpacingTokens.xl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withAlpha(38),
                        AppColors.secondary.withAlpha(38),
                      ],
                    ),
                    borderRadius: BorderRadiusTokens.card,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Have Questions?',
                        style: TypographyTokens.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.sm),
                      Text(
                        'Reach out to our team for any privacy concerns.',
                        style: TypographyTokens.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusTokens.fullCircular,
                          ),
                        ),
                        child: const Text('Contact Privacy Team'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: SpacingTokens.lg),
                Center(
                  child: Text(
                    'Privacy Policy',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
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

  static Widget _section(
      String num, String title, String intro, List<String>? items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$num.',
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
            intro,
            style: TypographyTokens.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          if (items != null) ...[
            const SizedBox(height: SpacingTokens.md),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(
                    left: SpacingTokens.md, bottom: SpacingTokens.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: SpacingTokens.sm),
                    Expanded(
                      child: Text(
                        item,
                        style: TypographyTokens.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
