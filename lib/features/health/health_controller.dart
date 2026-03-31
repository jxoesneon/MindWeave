import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/health/health_service.dart';

/// Provider for health data and HealthKit integration.
final healthControllerProvider =
    AsyncNotifierProvider<HealthController, HealthState>(
  HealthController.new,
);

class HealthController extends AsyncNotifier<HealthState> {
  final _service = HealthService();

  @override
  Future<HealthState> build() async {
    // Return initial state, user must request sync
    return const HealthState();
  }

  /// Request health permissions.
  Future<bool> requestPermissions() async {
    return await _service.requestPermissions();
  }

  /// Sync sleep data from HealthKit.
  Future<void> syncSleepData() async {
    state = const AsyncValue.loading();

    final hasPermission = await _service.requestReadPermissions();
    if (!hasPermission) {
      state = AsyncValue.error(
        const HealthState(error: 'Health permission denied'),
        StackTrace.current,
      );
      return;
    }

    final data = await _service.getSleepData();
    final score = _service.calculateSleepQualityScore(data);
    final mindfulMinutes = await _service.getTodayMindfulMinutes();

    state = AsyncValue.data(
      HealthState(sleepScore: score, todayMindfulMinutes: mindfulMinutes),
    );
  }

  /// Log a completed binaural session to HealthKit.
  ///
  /// Call this when a session ends to record mindful minutes.
  Future<bool> logSession({
    required DateTime startTime,
    required Duration duration,
    String? presetName,
    double? beatFrequency,
  }) async {
    final success = await _service.logBinauralSession(
      startTime: startTime,
      duration: duration,
      presetName: presetName,
      beatFrequency: beatFrequency,
    );

    // Refresh mindful minutes count
    await syncSleepData();

    return success;
  }

  /// Get today's mindful minutes.
  Future<int> getTodayMindfulMinutes() async {
    return await _service.getTodayMindfulMinutes();
  }
}

/// State for health data.
class HealthState {
  final double? sleepScore;
  final int? todayMindfulMinutes;
  final String? error;

  const HealthState({this.sleepScore, this.todayMindfulMinutes, this.error});

  HealthState copyWith({
    double? sleepScore,
    int? todayMindfulMinutes,
    String? error,
  }) {
    return HealthState(
      sleepScore: sleepScore ?? this.sleepScore,
      todayMindfulMinutes: todayMindfulMinutes ?? this.todayMindfulMinutes,
      error: error ?? this.error,
    );
  }
}
