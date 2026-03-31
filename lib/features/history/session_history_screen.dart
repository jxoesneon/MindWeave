import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repository/session_repository.dart';
import '../../core/models/user_session.dart';

class SessionHistoryScreen extends ConsumerWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final repo = ref.watch(sessionRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop ? null : _buildMobileAppBar(context),
      body: FutureBuilder<List<UserSession>>(
        future: repo.getSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final sessions = snapshot.data ?? [];

          if (isDesktop) {
            return _buildDesktopLayout(context, sessions);
          }
          return _buildMobileLayout(context, sessions);
        },
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      title: const Text(
        'Session History',
        style: TextStyle(
          color: AppColors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<UserSession> sessions) {
    if (sessions.isEmpty) {
      return _buildEmptyState();
    }

    final stats = _computeStats(sessions);

    return Column(
      children: [
        // Stats summary
        _StatsSummaryBar(stats: stats),
        const SizedBox(height: 8),
        // Session list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              return _SessionListTile(session: sessions[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<UserSession> sessions) {
    final stats = _computeStats(sessions);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 12),
              const Text(
                'Session History',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Stats cards row
          _DesktopStatsRow(stats: stats),
          const SizedBox(height: 24),
          // Session table
          Expanded(
            child: sessions.isEmpty
                ? _buildEmptyState()
                : Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer.withAlpha(102),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.outlineVariant.withAlpha(51),
                      ),
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: sessions.length,
                      separatorBuilder: (_, _) => Divider(
                        color: AppColors.outlineVariant.withAlpha(51),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        return _SessionListTile(session: sessions[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.onSurfaceVariant.withAlpha(77),
          ),
          const SizedBox(height: 16),
          const Text(
            'No sessions yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a meditation to see your history here',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  _SessionStats _computeStats(List<UserSession> sessions) {
    final totalSessions = sessions.length;
    final totalSeconds = sessions.fold<int>(
      0,
      (sum, s) => sum + s.durationSeconds,
    );
    final totalMinutes = totalSeconds ~/ 60;
    final avgMinutes = totalSessions > 0
        ? (totalMinutes / totalSessions).round()
        : 0;

    // Most used preset
    final presetCounts = <String, int>{};
    for (final s in sessions) {
      presetCounts[s.presetId] = (presetCounts[s.presetId] ?? 0) + 1;
    }
    String? topPreset;
    if (presetCounts.isNotEmpty) {
      topPreset = presetCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    return _SessionStats(
      totalSessions: totalSessions,
      totalMinutes: totalMinutes,
      avgMinutes: avgMinutes,
      topPreset: topPreset,
    );
  }
}

class _SessionStats {
  final int totalSessions;
  final int totalMinutes;
  final int avgMinutes;
  final String? topPreset;

  const _SessionStats({
    required this.totalSessions,
    required this.totalMinutes,
    required this.avgMinutes,
    this.topPreset,
  });
}

class _StatsSummaryBar extends StatelessWidget {
  final _SessionStats stats;

  const _StatsSummaryBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    final hours = stats.totalMinutes ~/ 60;
    final mins = stats.totalMinutes % 60;
    final timeLabel = hours > 0
        ? '${hours}h ${mins}m'
        : '${stats.totalMinutes}m';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withAlpha(102),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MiniStat(value: '${stats.totalSessions}', label: 'Sessions'),
          _MiniStat(value: timeLabel, label: 'Total'),
          _MiniStat(value: '${stats.avgMinutes}m', label: 'Avg'),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;

  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Space Grotesk',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DesktopStatsRow extends StatelessWidget {
  final _SessionStats stats;

  const _DesktopStatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final hours = stats.totalMinutes ~/ 60;
    final mins = stats.totalMinutes % 60;
    final timeLabel = hours > 0
        ? '${hours}h ${mins}m'
        : '${stats.totalMinutes}m';

    return Row(
      children: [
        _DesktopStatBox(
          icon: Icons.play_circle_outline,
          value: '${stats.totalSessions}',
          label: 'Total Sessions',
          color: AppColors.primary,
        ),
        const SizedBox(width: 16),
        _DesktopStatBox(
          icon: Icons.timer_outlined,
          value: timeLabel,
          label: 'Total Time',
          color: AppColors.secondary,
        ),
        const SizedBox(width: 16),
        _DesktopStatBox(
          icon: Icons.trending_up,
          value: '${stats.avgMinutes}m',
          label: 'Avg Session',
          color: AppColors.tertiary,
        ),
        const SizedBox(width: 16),
        _DesktopStatBox(
          icon: Icons.star_outline,
          value: stats.topPreset ?? '-',
          label: 'Most Used',
          color: AppColors.alpha,
        ),
      ],
    );
  }
}

class _DesktopStatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _DesktopStatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer.withAlpha(102),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionListTile extends StatelessWidget {
  final UserSession session;

  const _SessionListTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final duration = session.durationSeconds;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final durationLabel = minutes > 0
        ? '${minutes}m ${seconds}s'
        : '${seconds}s';

    final date = session.startedAt;
    final dateLabel = '${date.day}/${date.month}/${date.year}';
    final timeLabel =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          // Preset icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.waves, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.presetId.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dateLabel at $timeLabel',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Duration
          Text(
            durationLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
              fontFamily: 'Space Grotesk',
            ),
          ),
        ],
      ),
    );
  }
}
