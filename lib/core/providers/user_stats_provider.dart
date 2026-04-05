import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/favorites_repository.dart';
import '../repository/journal_repository.dart';
import '../repository/session_repository.dart';

/// Daily resonance data for spectral chart
class DailyResonance {
  final String day;
  final double deepFlow; // 0.0 to 1.0
  final double gammaPeak; // 0.0 to 1.0
  final int totalMinutes;

  const DailyResonance({
    required this.day,
    this.deepFlow = 0.0,
    this.gammaPeak = 0.0,
    this.totalMinutes = 0,
  });
}

/// User statistics data model for profile screen
class UserStats {
  final String totalFocusTime;
  final String focusTimeUnit;
  final int currentStreak;
  final double averageCoherence;
  final int totalSessions;
  final int savedFrequenciesCount;
  final int journalEntriesCount;
  final bool hasData;
  final List<DailyResonance> weeklyResonance;

  const UserStats({
    this.totalFocusTime = '0h',
    this.focusTimeUnit = '00m',
    this.currentStreak = 0,
    this.averageCoherence = 0.0,
    this.totalSessions = 0,
    this.savedFrequenciesCount = 0,
    this.journalEntriesCount = 0,
    this.hasData = false,
    this.weeklyResonance = const [],
  });

  /// Empty stats for new users
  static const empty = UserStats();

  /// Get display value for cumulative stat
  String get cumulativeValue => hasData ? totalFocusTime : '0h';
  String get cumulativeUnit => hasData ? focusTimeUnit : '00m';

  /// Get display value for streak
  String get streakValue => hasData ? currentStreak.toString() : '0';

  /// Get display value for coherence
  String get coherenceValue =>
      hasData ? averageCoherence.toStringAsFixed(1) : '0.0';

  /// Get default weekly resonance for new users (all zeros)
  static List<DailyResonance> get defaultWeeklyResonance => [
    const DailyResonance(day: 'MON'),
    const DailyResonance(day: 'TUE'),
    const DailyResonance(day: 'WED'),
    const DailyResonance(day: 'THU'),
    const DailyResonance(day: 'FRI'),
    const DailyResonance(day: 'SAT'),
    const DailyResonance(day: 'SUN'),
  ];
}

/// Provider for user statistics that aggregates data from multiple repositories
final userStatsProvider = FutureProvider<UserStats>((ref) async {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final favoritesRepo = ref.watch(favoritesRepositoryProvider);
  final journalRepo = ref.watch(journalRepositoryProvider);

  try {
    // Fetch all data in parallel
    final results = await Future.wait([
      sessionRepo.getSessions(),
      sessionRepo.calculateCurrentStreak(),
      favoritesRepo.getFavorites(),
      journalRepo.getEntries(),
    ]);

    final sessions = results[0] as List<dynamic>;
    final streak = results[1] as int;
    final favorites = results[2] as List<dynamic>;
    final journalEntries = results[3] as List<dynamic>;

    // Calculate total focus time from sessions
    int totalMinutes = 0;
    for (final session in sessions) {
      // Safely access durationSeconds - may not exist for new users
      try {
        final dynamicSession = session as dynamic;
        final durationSeconds = (dynamicSession.durationSeconds as int?) ?? 0;
        totalMinutes += durationSeconds ~/ 60;
      } catch (_) {
        // Skip sessions with missing duration data
        continue;
      }
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    // Calculate average coherence (mock calculation for now - would need actual coherence data)
    final coherence = sessions.isNotEmpty
        ? 85.0 + (sessions.length * 0.5).clamp(0, 14)
        : 0.0;

    final hasData =
        sessions.isNotEmpty ||
        favorites.isNotEmpty ||
        journalEntries.isNotEmpty ||
        streak > 0;

    // Calculate weekly resonance from sessions
    final weeklyResonance = _calculateWeeklyResonance(sessions);

    return UserStats(
      totalFocusTime: '${hours}h',
      focusTimeUnit: '${minutes.toString().padLeft(2, '0')}m',
      currentStreak: streak,
      averageCoherence: coherence > 99.9 ? 99.9 : coherence,
      totalSessions: sessions.length,
      savedFrequenciesCount: favorites.length,
      journalEntriesCount: journalEntries.length,
      hasData: hasData,
      weeklyResonance: weeklyResonance,
    );
  } catch (e) {
    // Return empty stats on error (graceful fallback for new users)
    return UserStats(
      weeklyResonance: List.generate(
        7,
        (i) => DailyResonance(
          day: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][i],
        ),
      ),
    );
  }
});

/// Calculate weekly resonance data from sessions
List<DailyResonance> _calculateWeeklyResonance(List<dynamic> sessions) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday

  // Initialize all days with zero
  final dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  final dailyMinutes = List<int>.filled(7, 0);

  // Sum up minutes per day for the current week
  for (final session in sessions) {
    try {
      final dynamicSession = session as dynamic;
      final sessionDate = dynamicSession.startedAt as DateTime?;
      if (sessionDate == null) continue;

      // Only count sessions from current week
      if (sessionDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          sessionDate.isBefore(now.add(const Duration(days: 1)))) {
        final dayIndex = sessionDate.weekday - 1; // 0 = Monday
        if (dayIndex >= 0 && dayIndex < 7) {
          final durationSeconds = (dynamicSession.durationSeconds as int?) ?? 0;
          dailyMinutes[dayIndex] += durationSeconds ~/ 60;
        }
      }
    } catch (_) {
      // Skip sessions with missing data
      continue;
    }
  }

  // Find max for normalization (avoid division by zero)
  final maxMinutes = dailyMinutes.reduce((a, b) => a > b ? a : b);
  final maxValue = maxMinutes > 0 ? maxMinutes : 1;

  // Create resonance list with normalized values
  return List.generate(7, (index) {
    final normalizedValue = dailyMinutes[index] / maxValue;
    return DailyResonance(
      day: dayNames[index],
      deepFlow: normalizedValue * 0.8 + 0.1, // Min 0.1 for visibility
      gammaPeak: normalizedValue * 0.6 + 0.05, // Slightly lower
      totalMinutes: dailyMinutes[index],
    );
  });
}

/// Stream provider for real-time user stats updates
final userStatsStreamProvider = StreamProvider<UserStats>((ref) {
  // Re-fetch stats every 30 seconds for updates
  return Stream.periodic(
    const Duration(seconds: 30),
    (_) => ref.read(userStatsProvider.future),
  ).asyncMap((future) => future);
});
