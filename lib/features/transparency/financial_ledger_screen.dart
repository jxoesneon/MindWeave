import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/atoms/atoms.dart';

/// Financial Ledger Screen — matches Stitch designs: 02/15_financial_transparency_ledger.png
///
/// Features:
/// - "PUBLIC LEDGER" subtitle + "Financial Transparency" title
/// - Summary cards: Total Income, Total Expenses, Net
/// - Filter chips: All, Income, Expenses
/// - Ledger table with date, description, category, amount
/// - Monthly breakdown chart placeholder
class FinancialLedgerScreen extends StatefulWidget {
  const FinancialLedgerScreen({super.key});

  @override
  State<FinancialLedgerScreen> createState() => _FinancialLedgerScreenState();
}

class _FinancialLedgerScreenState extends State<FinancialLedgerScreen> {
  String _selectedFilter = 'All';

  final List<_LedgerEntry> _entries = const [
    _LedgerEntry('Oct 15', 'Community Donations', 'Income', '+\$1,247'),
    _LedgerEntry('Oct 14', 'AWS Hosting', 'Infrastructure', '-\$420'),
    _LedgerEntry('Oct 13', 'Developer Stipend', 'Payroll', '-\$1,200'),
    _LedgerEntry('Oct 12', 'Tier Subscriptions', 'Income', '+\$2,000'),
    _LedgerEntry('Oct 10', 'Audio Licensing', 'Content', '-\$360'),
    _LedgerEntry('Oct 8', 'CDN Services', 'Infrastructure', '-\$85'),
    _LedgerEntry('Oct 5', 'One-time Donations', 'Income', '+\$450'),
    _LedgerEntry('Oct 3', 'Design Tools', 'Operations', '-\$115'),
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
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  hPad, SpacingTokens.sm, hPad, SpacingTokens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PUBLIC LEDGER',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    'Financial\nTransparency.',
                    style: TypographyTokens.displaySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.lg)),

          // Summary cards
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: LayoutBuilder(builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final cards = [
                  _summaryCard(
                      'Total Income', '\$3,697', const Color(0xFF2E7D32)),
                  _summaryCard(
                      'Total Expenses', '\$2,180', AppColors.error),
                  _summaryCard(
                      'Net Balance', '\$1,517', AppColors.primary),
                ];
                if (isWide) {
                  return Row(
                    children: cards
                        .map((c) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      c == cards.last ? 0 : SpacingTokens.md,
                                ),
                                child: c,
                              ),
                            ))
                        .toList(),
                  );
                }
                return Column(
                  children: cards
                      .map((c) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: SpacingTokens.sm),
                            child: c,
                          ))
                      .toList(),
                );
              }),
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.xl)),

          // Filter chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: hPad),
                children: [
                  for (final f in ['All', 'Income', 'Expenses'])
                    Padding(
                      padding: const EdgeInsets.only(right: SpacingTokens.sm),
                      child: MwChip(
                        label: f,
                        isSelected: f == _selectedFilter,
                        onTap: () => setState(() => _selectedFilter = f),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.lg)),

          // Ledger table
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadiusTokens.card,
                  border: Border.all(
                      color: AppColors.outlineVariant.withAlpha(38)),
                ),
                child: Column(
                  children: [
                    // Table header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: SpacingTokens.lg,
                          vertical: SpacingTokens.md),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text('DATE',
                                style: TypographyTokens.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9)),
                          ),
                          Expanded(
                            child: Text('DESCRIPTION',
                                style: TypographyTokens.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9)),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text('CATEGORY',
                                style: TypographyTokens.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9)),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text('AMOUNT',
                                textAlign: TextAlign.right,
                                style: TypographyTokens.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                        color: AppColors.outlineVariant, height: 1),
                    // Table rows
                    ..._entries.map((e) => _buildLedgerRow(e)),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.xxl)),
        ],
      ),
    );
  }

  static Widget _summaryCard(String label, String value, Color color) {
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
            label,
            style: TypographyTokens.labelSmall
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            value,
            style: TypographyTokens.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildLedgerRow(_LedgerEntry entry) {
    final isIncome = entry.amount.startsWith('+');
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.lg, vertical: SpacingTokens.sm),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(entry.date,
                style: TypographyTokens.bodySmall
                    .copyWith(color: AppColors.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(entry.description,
                style: TypographyTokens.bodySmall
                    .copyWith(color: AppColors.onSurface)),
          ),
          SizedBox(
            width: 100,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadiusTokens.smCircular,
              ),
              child: Text(
                entry.category,
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              entry.amount,
              textAlign: TextAlign.right,
              style: TypographyTokens.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isIncome
                    ? const Color(0xFF2E7D32)
                    : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LedgerEntry {
  final String date;
  final String description;
  final String category;
  final String amount;
  const _LedgerEntry(this.date, this.description, this.category, this.amount);
}
