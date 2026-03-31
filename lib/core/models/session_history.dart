import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_history.freezed.dart';
part 'session_history.g.dart';

/// Model for tracking binaural beat sessions.
///
/// Stored in Supabase for persistence across devices.
@freezed
abstract class SessionHistory with _$SessionHistory {
  const factory SessionHistory({
    required String id,
    required String userId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    String? presetId,
    String? presetName,
    required double beatFrequency,
    required double carrierFrequency,
    required double volumeLevel,
    @Default(true) bool completed,
    DateTime? createdAt,
  }) = _SessionHistory;

  const SessionHistory._();

  factory SessionHistory.fromJson(Map<String, dynamic> json) =>
      _$SessionHistoryFromJson(json);

  /// Calculate formatted duration string (e.g., "15 min" or "1h 30m")
  String get formattedDuration {
    final minutes = (durationSeconds / 60).floor();
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    }
    return '$minutes min';
  }
}

/// Filter options for session history queries
enum SessionFilter {
  all('All'),
  today('Today'),
  week('This Week'),
  month('This Month');

  final String label;
  const SessionFilter(this.label);
}

/// Statistics for session history
@freezed
abstract class SessionStatistics with _$SessionStatistics {
  const factory SessionStatistics({
    required int totalSessions,
    required int totalMinutes,
    required double averageSessionMinutes,
    String? mostUsedPreset,
    required Map<String, int> presetUsageCounts,
  }) = _SessionStatistics;

  factory SessionStatistics.fromSessions(List<SessionHistory> sessions) {
    if (sessions.isEmpty) {
      return const SessionStatistics(
        totalSessions: 0,
        totalMinutes: 0,
        averageSessionMinutes: 0,
        presetUsageCounts: {},
      );
    }

    final totalMinutes = sessions.fold<int>(
      0,
      (sum, s) => sum + (s.durationSeconds ~/ 60),
    );

    final presetCounts = <String, int>{};
    for (final session in sessions) {
      final name = session.presetName ?? 'Custom';
      presetCounts[name] = (presetCounts[name] ?? 0) + 1;
    }

    final mostUsed = presetCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return SessionStatistics(
      totalSessions: sessions.length,
      totalMinutes: totalMinutes,
      averageSessionMinutes: totalMinutes / sessions.length,
      mostUsedPreset: mostUsed,
      presetUsageCounts: presetCounts,
    );
  }
}
