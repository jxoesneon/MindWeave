import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/atoms/buttons/secondary_button.dart';
import '../../core/atoms/feedback/daily_sine_wave.dart';
import '../../core/auth/google_sign_in_service.dart';
import '../../core/auth/user_profile_provider.dart';
import '../../core/providers/user_stats_provider.dart';
import '../../core/repository/favorites_repository.dart';
import '../../core/repository/journal_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';

/// Profile Screen — matches Stitch design: 27_purchase_success.png
///
/// Desktop layout with sidebar nav, user profile header with avatar,
/// stats cards (Cumulative, Current State, Biological), spectral resonance
/// chart, saved frequencies grid, and journal entries.
/// Uses real data from repositories with empty states for new users.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;
    final userProfile = ref.watch(userProfileProvider);
    final userStatsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Profile header with back button inline
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(hPad),
                child: _buildProfileHeader(
                  isDesktop,
                  userProfile,
                  ref,
                  context,
                ),
              ),
            ),
            // Stats row
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: userStatsAsync.when(
                  data: (stats) => _buildStatsRow(isDesktop, stats),
                  loading: () => _buildStatsRow(isDesktop, const UserStats()),
                  error: (_, _) => _buildStatsRow(isDesktop, const UserStats()),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),
            // Spectral Resonance chart
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: userStatsAsync.when(
                  data: (stats) => _buildSpectralResonance(isDesktop, stats),
                  loading: () =>
                      _buildSpectralResonance(isDesktop, const UserStats()),
                  error: (_, _) =>
                      _buildSpectralResonance(isDesktop, const UserStats()),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xl)),
            // Saved Frequencies + Journal
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: userStatsAsync.when(
                  data: (stats) => isDesktop
                      ? _buildDesktopBottomRow(stats)
                      : _buildMobileBottomSection(stats),
                  loading: () => isDesktop
                      ? _buildDesktopBottomRow(const UserStats())
                      : _buildMobileBottomSection(const UserStats()),
                  error: (_, _) => isDesktop
                      ? _buildDesktopBottomRow(const UserStats())
                      : _buildMobileBottomSection(const UserStats()),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.xxl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    bool isDesktop,
    UserProfile userProfile,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button (left side, inline with name)
        MwSecondaryButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back,
          label: 'Back',
        ),
        // Profile info (right side)
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info column (right-aligned)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  userProfile.displayNameOrFallback,
                  style: TypographyTokens.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SpacingTokens.xs),
                Text(
                  userProfile.isAnonymous
                      ? 'GUEST USER'
                      : 'LEVEL: GAMMA WEAVER',
                  style: TypographyTokens.labelSmall.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                if (userProfile.email != null)
                  Text(
                    userProfile.email!,
                    style: TypographyTokens.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: SpacingTokens.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(38),
                    borderRadius: BorderRadiusTokens.smCircular,
                  ),
                  child: Text(
                    userProfile.isAnonymous ? 'GUEST' : 'ACTIVE',
                    style: TypographyTokens.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: SpacingTokens.lg),
            // Avatar column with sign out button below
            Column(
              children: [
                // Avatar with user image or initials
                Container(
                  width: isDesktop ? 96 : 72,
                  height: isDesktop ? 96 : 72,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadiusTokens.lgCircular,
                    border: Border.all(
                      color: AppColors.primary.withAlpha(102),
                      width: 2,
                    ),
                    image: userProfile.hasAvatar
                        ? DecorationImage(
                            image: NetworkImage(userProfile.avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: userProfile.hasAvatar
                      ? null
                      : Center(
                          child: Text(
                            userProfile.initials,
                            style: TypographyTokens.headlineMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: SpacingTokens.sm),
                // Sign out button below avatar
                MwSecondaryButton(
                  onPressed: () async {
                    final googleSignIn = ref.read(googleSignInServiceProvider);
                    await googleSignIn.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icons.logout,
                  label: 'Sign Out',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(bool isDesktop, UserStats stats) {
    final statItems = [
      _StatData(
        Icons.headphones,
        'CUMULATIVE',
        stats.cumulativeValue,
        stats.cumulativeUnit,
        'Total Focus Time',
      ),
      _StatData(
        Icons.bolt,
        'CURRENT STATE',
        stats.streakValue,
        'Days',
        'Current Streak',
      ),
      _StatData(
        Icons.auto_awesome,
        'BIOLOGICAL',
        stats.coherenceValue,
        '%',
        'Average Coherence',
      ),
    ];

    if (isDesktop) {
      return Row(
        children: statItems
            .map(
              (s) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: s == statItems.last ? 0 : SpacingTokens.md,
                  ),
                  child: _buildStatCard(s),
                ),
              ),
            )
            .toList(),
      );
    }
    return Column(
      children: statItems
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
              child: _buildStatCard(s),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatCard(_StatData stat) {
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
          Row(
            children: [
              Icon(stat.icon, size: 16, color: AppColors.primary),
              const SizedBox(width: SpacingTokens.xs),
              Text(
                stat.label,
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                stat.value,
                style: TypographyTokens.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                stat.unit,
                style: TypographyTokens.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            stat.description,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpectralResonance(bool isDesktop, UserStats stats) {
    // Get weekly resonance data (7 days)
    final weeklyData = stats.weeklyResonance.isNotEmpty
        ? stats.weeklyResonance
        : UserStats.defaultWeeklyResonance;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spectral Resonance',
                style: TypographyTokens.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  _legendDot(AppColors.primary, 'Deep Flow'),
                  const SizedBox(width: SpacingTokens.md),
                  _legendDot(AppColors.secondary, 'Gamma Peak'),
                ],
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.lg),
          // Daily sine wave visualization - each wave peaks at its day
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                // Deep Flow waves - one per day
                ...weeklyData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  return MwDailySineWave(
                    dayIndex: index,
                    amplitude: day.deepFlow,
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                    animated: true,
                    opacity: 0.7,
                  );
                }),
                // Gamma Peak waves - one per day (slightly offset)
                ...weeklyData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  return MwDailySineWave(
                    dayIndex: index,
                    amplitude: day.gammaPeak,
                    color: AppColors.secondary,
                    strokeWidth: 2,
                    animated: true,
                    opacity: 0.6,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          // Day labels row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weeklyData
                .map(
                  (day) => Text(
                    day.day,
                    style: TypographyTokens.labelSmall.copyWith(
                      color: day.totalMinutes > 0
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontSize: 9,
                      fontWeight: day.totalMinutes > 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TypographyTokens.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopBottomRow(UserStats stats) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saved Frequencies
        Expanded(flex: 3, child: _buildSavedFrequencies(stats)),
        const SizedBox(width: SpacingTokens.lg),
        // Journal
        Expanded(flex: 2, child: _buildJournal(stats)),
      ],
    );
  }

  Widget _buildMobileBottomSection(UserStats stats) {
    return Column(
      children: [
        _buildSavedFrequencies(stats),
        const SizedBox(height: SpacingTokens.lg),
        _buildJournal(stats),
      ],
    );
  }

  Widget _buildSavedFrequencies(UserStats stats) {
    return Consumer(
      builder: (context, ref, child) {
        final favoritesAsync = ref.watch(favoritesRepositoryProvider);

        return FutureBuilder(
          future: favoritesAsync.getFavorites(),
          builder: (context, snapshot) {
            final favorites = snapshot.data ?? [];
            final hasFavorites = favorites.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saved Frequencies',
                      style: TypographyTokens.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (hasFavorites)
                      Text(
                        'View All',
                        style: TypographyTokens.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: SpacingTokens.md),
                if (!hasFavorites)
                  _buildEmptyState(
                    icon: Icons.favorite_border,
                    message:
                        'No saved frequencies yet.\nExplore and save your favorites!',
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildFreqCard(
                          favorites.first.name,
                          '${favorites.first.carrierFrequency}Hz • ${favorites.first.beatFrequency}Hz beat',
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.md),
                      if (favorites.length > 1)
                        Expanded(
                          child: _buildFreqCard(
                            favorites[1].name,
                            '${favorites[1].carrierFrequency}Hz • ${favorites[1].beatFrequency}Hz beat',
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.onSurfaceVariant.withAlpha(128),
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreqCard(String title, String subtitle) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournal(UserStats stats) {
    return Consumer(
      builder: (context, ref, child) {
        final entriesAsync = ref.watch(journalEntriesProvider);

        return entriesAsync.when(
          data: (entries) {
            final hasEntries = entries.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Journal',
                      style: TypographyTokens.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (hasEntries)
                      Text(
                        'View All',
                        style: TypographyTokens.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: SpacingTokens.md),
                if (!hasEntries)
                  _buildEmptyState(
                    icon: Icons.book_outlined,
                    message:
                        'No journal entries yet.\nStart writing about your sessions!',
                  )
                else
                  ...entries
                      .take(3)
                      .map(
                        (e) => _buildJournalCard(
                          _JournalEntry(
                            e.formattedDate,
                            e.displayTitle,
                            e.preview,
                          ),
                        ),
                      ),
              ],
            );
          },
          loading: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journal',
                style: TypographyTokens.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: SpacingTokens.md),
              _buildEmptyState(
                icon: Icons.book_outlined,
                message: 'Loading journal entries...',
              ),
            ],
          ),
          error: (_, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journal',
                style: TypographyTokens.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: SpacingTokens.md),
              _buildEmptyState(
                icon: Icons.error_outline,
                message: 'Could not load journal entries.',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJournalCard(_JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: SpacingTokens.sm),
      padding: const EdgeInsets.all(SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.date,
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.primary,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.title,
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            entry.body,
            style: TypographyTokens.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatData {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final String description;
  const _StatData(
    this.icon,
    this.label,
    this.value,
    this.unit,
    this.description,
  );
}

class _JournalEntry {
  final String date;
  final String title;
  final String body;
  const _JournalEntry(this.date, this.title, this.body);
}
