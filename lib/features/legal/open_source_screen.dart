import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Open Source Attributions Screen — matches Stitch design: 16_desktop_settings_support.png
///
/// Features:
/// - "GRATITUDE IN CODE" subtitle + "Open Source Attributions" title
/// - Search packages field
/// - Package cards with name, license, version, description
/// - License type chips
class OpenSourceScreen extends StatelessWidget {
  const OpenSourceScreen({super.key});

  static const _packages = [
    _Package('flutter_riverpod', '2.6.1', 'MIT',
        'Reactive caching and data-binding framework for Flutter.'),
    _Package('freezed_annotation', '2.4.4', 'MIT',
        'Annotations for the freezed code generation package.'),
    _Package('audio_service', '0.18.15', 'MIT',
        'Flutter plugin for playing audio in the background.'),
    _Package('hive', '2.2.3', 'Apache-2.0',
        'Lightweight and blazing fast key-value database.'),
    _Package('health', '10.2.0', 'MIT',
        'A Flutter plugin for reading health data from Apple Health & Google Fit.'),
    _Package('go_router', '14.6.2', 'BSD-3-Clause',
        'A declarative routing package for Flutter.'),
    _Package('fl_chart', '0.69.2', 'MIT',
        'A powerful Flutter chart library for drawing beautiful charts.'),
    _Package('firebase_analytics', '11.3.6', 'BSD-3-Clause',
        'Flutter plugin for Firebase Analytics.'),
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
                    'GRATITUDE IN CODE',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    'Open Source\nAttributions.',
                    style: TypographyTokens.displaySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.md),
                  Text(
                    'MindWeave stands on the shoulders of giants. These open source packages make our vision possible.',
                    style: TypographyTokens.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadiusTokens.mdCircular,
                  border: Border.all(
                      color: AppColors.outlineVariant.withAlpha(38)),
                ),
                child: TextField(
                  style: TypographyTokens.bodyMedium
                      .copyWith(color: AppColors.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search packages...',
                    hintStyle: TypographyTokens.bodyMedium
                        .copyWith(color: AppColors.onSurfaceVariant),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search,
                        color: AppColors.onSurfaceVariant, size: 20),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.lg)),

          // Package list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: _buildPackageCard(_packages[index]),
              ),
              childCount: _packages.length,
            ),
          ),

          const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.xxl)),
        ],
      ),
    );
  }

  static Widget _buildPackageCard(_Package pkg) {
    return Container(
      margin: const EdgeInsets.only(bottom: SpacingTokens.md),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pkg.name,
                style: TypographyTokens.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(26),
                  borderRadius: BorderRadiusTokens.smCircular,
                ),
                child: Text(
                  pkg.license,
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'v${pkg.version}',
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            pkg.description,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Package {
  final String name;
  final String version;
  final String license;
  final String description;
  const _Package(this.name, this.version, this.license, this.description);
}
