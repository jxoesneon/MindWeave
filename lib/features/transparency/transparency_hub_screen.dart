import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../navigation/app_routes.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Transparency Hub Screen — matches Stitch designs: 29/35
///
/// Features:
/// - "RADICAL TRANSPARENCY" subtitle + "Trust Through Openness" title
/// - Revenue breakdown cards (Monthly Revenue, Expenses, Net Balance)
/// - Live Ledger section with transaction list
/// - Where Your Money Goes pie chart placeholder
/// - Sidebar: Quick Stats + Trust Badges
class TransparencyHubScreen extends ConsumerWidget {
  const TransparencyHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildMainContent(hPad)),
                  _buildSidebar(context),
                ],
              )
            : _buildMainContent(hPad),
      ),
    );
  }

  Widget _buildMainContent(double hPad) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              hPad,
              SpacingTokens.xl,
              hPad,
              SpacingTokens.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RADICAL TRANSPARENCY',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                Text(
                  'Trust Through\nOpenness.',
                  style: TypographyTokens.displaySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: SpacingTokens.md),
                Text(
                  'Every dollar, every decision, fully transparent. We believe trust is built through radical openness about how your support flows.',
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.lg)),

        // Revenue cards row
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final cards = [
                  _buildRevenueCard(
                    'Monthly Revenue',
                    '\$3,247',
                    '+12.5%',
                    AppColors.primary,
                  ),
                  _buildRevenueCard(
                    'Monthly Expenses',
                    '\$2,180',
                    '-3.2%',
                    AppColors.secondary,
                  ),
                  _buildRevenueCard(
                    'Net Balance',
                    '\$1,067',
                    '+8.1%',
                    AppColors.tertiary,
                  ),
                ];
                if (isWide) {
                  return Row(
                    children: cards
                        .map(
                          (c) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: c == cards.last ? 0 : SpacingTokens.md,
                              ),
                              child: c,
                            ),
                          ),
                        )
                        .toList(),
                  );
                }
                return Column(
                  children: cards
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: SpacingTokens.sm,
                          ),
                          child: c,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

        // Live Ledger
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Text(
              'LIVE LEDGER',
              style: TypographyTokens.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.md)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadiusTokens.card,
                border: Border.all(
                  color: AppColors.outlineVariant.withAlpha(38),
                ),
              ),
              child: Column(
                children: [
                  _ledgerRow(
                    'Server Infrastructure',
                    'Hosting & CDN',
                    '-\$420',
                    'OCT 2025',
                  ),
                  const Divider(color: AppColors.outlineVariant, height: 1),
                  _ledgerRow(
                    'Community Donations',
                    '42 supporters',
                    '+\$3,247',
                    'OCT 2025',
                  ),
                  const Divider(color: AppColors.outlineVariant, height: 1),
                  _ledgerRow(
                    'Developer Stipend',
                    'Core maintainer',
                    '-\$1,200',
                    'OCT 2025',
                  ),
                  const Divider(color: AppColors.outlineVariant, height: 1),
                  _ledgerRow(
                    'Audio Licensing',
                    'Soundscape assets',
                    '-\$360',
                    'OCT 2025',
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),

        // Where Your Money Goes
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Container(
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
                  Text(
                    'Where Your Money Goes',
                    style: TypographyTokens.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.lg),
                  _breakdownRow('Development', 0.45, AppColors.primary),
                  _breakdownRow('Infrastructure', 0.20, AppColors.secondary),
                  _breakdownRow('Audio Content', 0.18, AppColors.tertiary),
                  _breakdownRow('Community', 0.10, const Color(0xFFF57C00)),
                  _breakdownRow('Reserve', 0.07, AppColors.error),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xxl)),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.outlineVariant.withAlpha(38)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SpacingTokens.xl),
          _buildQuickStats(),
          const SizedBox(height: SpacingTokens.xl),
          _buildTrustBadges(context),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          _quickStatRow('Active Supporters', '42'),
          _quickStatRow('Total Raised', '\$18.4k'),
          _quickStatRow('Months Funded', '6 of 12'),
          _quickStatRow('Open Issues', '3'),
        ],
      ),
    );
  }

  Widget _quickStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: Row(
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
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadges(BuildContext context) {
    final badges = [
      (Icons.verified_outlined, 'Open Source Verified', AppRoutes.openSource),
      (Icons.lock_outlined, 'Audited Financials', AppRoutes.financialLedger),
      (Icons.groups_outlined, 'Community Governed', null),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trust Badges',
          style: TypographyTokens.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: SpacingTokens.md),
        ...badges.map(
          (b) => GestureDetector(
            onTap: b.$3 != null
                ? () => Navigator.pushNamed(context, b.$3!)
                : null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
              child: Row(
                children: [
                  Icon(b.$1, size: 18, color: AppColors.primary),
                  const SizedBox(width: SpacingTokens.sm),
                  Text(
                    b.$2,
                    style: TypographyTokens.labelMedium.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildRevenueCard(
    String title,
    String value,
    String change,
    Color color,
  ) {
    final isPositive = change.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            value,
            style: TypographyTokens.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TypographyTokens.labelSmall.copyWith(
              color: isPositive ? const Color(0xFF2E7D32) : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _ledgerRow(
    String title,
    String desc,
    String amount,
    String date,
  ) {
    final isPositive = amount.startsWith('+');
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.lg,
        vertical: SpacingTokens.md,
      ),
      child: Row(
        children: [
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TypographyTokens.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isPositive ? const Color(0xFF2E7D32) : AppColors.error,
                ),
              ),
              Text(
                date,
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _breakdownRow(String label, double fraction, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: SpacingTokens.sm),
                  Text(
                    label,
                    style: TypographyTokens.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                '${(fraction * 100).toInt()}%',
                style: TypographyTokens.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
