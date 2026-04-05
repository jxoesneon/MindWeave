import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/atoms/atoms.dart';

/// Notifications Screen — matches Stitch design: 06_notifications_center.png
///
/// Features:
/// - TEMPORAL AWARENESS subtitle + Notifications title
/// - Filter chips: All, Community, Frequencies, System
/// - Notification cards with colored left accent borders
/// - Right sidebar: Resonance Stats + Community Echoes
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Community',
    'Frequencies',
    'System',
  ];

  final List<_NotificationItem> _notifications = const [
    _NotificationItem(
      type: _NotifType.frequency,
      title: '"Solar Flare - Gamma Resonance" is now available.',
      body:
          'Experience the peak cognitive enhancement of Gamma waves synchronized with celestial solar activity data.',
      timestamp: '3h ago',
      label: 'NEW FREQUENCY DROP',
    ),
    _NotificationItem(
      type: _NotifType.community,
      title: '"Void_Navigator" replied to your post in the Community Hub.',
      body:
          '"The Alpha transition at minute 12 is profound. Have you tried embedding the left box breathing?"',
      timestamp: '45m ago',
      label: 'COMMUNITY RESONANCE',
    ),
    _NotificationItem(
      type: _NotifType.system,
      title: '7 Day Streak achievement unlocked.',
      body:
          'Consistency is the bridge to clarity. Your cognitive patterns are showing 15% increased coherence.',
      timestamp: '1h ago',
      label: 'FLOW STREAK',
    ),
    _NotificationItem(
      type: _NotifType.system,
      title: 'New version v2.5 with spatial audio is live.',
      body:
          "We've enhanced the binaural rendering engine for deeper immersion.",
      timestamp: 'Yesterday',
      label: 'SYSTEM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isDesktop
            ? _buildDesktopLayout(hPad)
            : _buildMobileLayout(hPad),
      ),
    );
  }

  Widget _buildDesktopLayout(double hPad) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main content
        Expanded(
          flex: 3,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(hPad)),
              SliverToBoxAdapter(child: _buildFilterChips(hPad)),
              const SliverToBoxAdapter(
                  child: SizedBox(height: SpacingTokens.lg)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: _buildNotificationCard(_notifications[index]),
                  ),
                  childCount: _notifications.length,
                ),
              ),
              const SliverToBoxAdapter(
                  child: SizedBox(height: SpacingTokens.xxl)),
            ],
          ),
        ),
        // Right sidebar
        Container(
          width: 300,
          padding: const EdgeInsets.all(SpacingTokens.lg),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: AppColors.outlineVariant.withAlpha(38)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: SpacingTokens.xl),
              _buildResonanceStats(),
              const SizedBox(height: SpacingTokens.xl),
              _buildCommunityEchoes(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(double hPad) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(hPad)),
        SliverToBoxAdapter(child: _buildFilterChips(hPad)),
        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.lg)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: _buildNotificationCard(_notifications[index]),
            ),
            childCount: _notifications.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: SpacingTokens.xxl)),
      ],
    );
  }

  Widget _buildHeader(double hPad) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(hPad, SpacingTokens.lg, hPad, SpacingTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TEMPORAL AWARENESS',
            style: TypographyTokens.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Notifications',
            style: TypographyTokens.headlineLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(double hPad) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: hPad),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: SpacingTokens.sm),
            child: MwChip(
              label: filter,
              isSelected: isSelected,
              onTap: () => setState(() => _selectedFilter = filter),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(_NotificationItem notif) {
    final accentColor = switch (notif.type) {
      _NotifType.frequency => AppColors.primary,
      _NotifType.community => AppColors.secondary,
      _NotifType.system => AppColors.tertiary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: SpacingTokens.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadiusTokens.card,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent border
          Container(
            width: 4,
            height: 100,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(BorderRadiusTokens.lg),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(SpacingTokens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notif.label,
                        style: TypographyTokens.labelSmall.copyWith(
                          color: accentColor,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        notif.timestamp,
                        style: TypographyTokens.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  Text(
                    notif.title,
                    style: TypographyTokens.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(
                    notif.body,
                    style: TypographyTokens.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResonanceStats() {
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
            'Resonance Stats',
            style: TypographyTokens.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          _statRow(Icons.headphones, '14.2 hrs', 'WEEKLY FOCUS'),
          const SizedBox(height: SpacingTokens.sm),
          _statRow(Icons.auto_awesome, '88%', 'COHERENCE SCORE'),
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: SpacingTokens.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TypographyTokens.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TypographyTokens.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommunityEchoes() {
    final users = [
      ('Astral_Key', 'Started the Delta Healings...'),
      ('Zenith_Mind', 'Shared a new system Pres...'),
      ('Orion_Pulse', 'Underscored: Deep Resona...'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community Echoes',
          style: TypographyTokens.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: SpacingTokens.md),
        ...users.map(
          (u) => Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  child: Icon(Icons.person, size: 14,
                      color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(width: SpacingTokens.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u.$1,
                        style: TypographyTokens.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        u.$2,
                        style: TypographyTokens.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: SpacingTokens.sm),
        Text(
          'VIEW COMMUNITY HUB',
          style: TypographyTokens.labelSmall.copyWith(
            color: AppColors.primary,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

enum _NotifType { frequency, community, system }

class _NotificationItem {
  final _NotifType type;
  final String title;
  final String body;
  final String timestamp;
  final String label;

  const _NotificationItem({
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.label,
  });
}
