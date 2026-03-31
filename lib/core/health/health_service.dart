import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

/// Health service for integrating with Apple HealthKit and Google Fit.
///
/// Supports:
/// - Reading sleep data
/// - Writing mindful minutes (meditation sessions)
class HealthService {
  final Health _health;

  HealthService({Health? health}) : _health = health ?? Health();

  /// Request permissions for all health data types we need.
  ///
  /// Returns true if all permissions granted.
  Future<bool> requestPermissions() async {
    final types = [HealthDataType.SLEEP_ASLEEP, HealthDataType.MINDFULNESS];
    final permissions = [HealthDataAccess.READ, HealthDataAccess.READ_WRITE];

    // Check if permissions already granted
    bool? hasPermissions = await _health.hasPermissions(
      types,
      permissions: permissions,
    );
    if (hasPermissions == true) return true;

    // Request using standard plugin
    return await _health.requestAuthorization(types, permissions: permissions);
  }

  /// Request read-only permissions for sleep data.
  Future<bool> requestReadPermissions() async {
    final types = [HealthDataType.SLEEP_ASLEEP];
    final permissions = [HealthDataAccess.READ];

    bool? hasPermissions = await _health.hasPermissions(
      types,
      permissions: permissions,
    );
    if (hasPermissions == true) return true;

    return await _health.requestAuthorization(types, permissions: permissions);
  }

  /// Write a mindful minutes session to HealthKit.
  ///
  /// [startTime] - when the session started
  /// [duration] - session duration
  /// [notes] - optional notes about the session
  ///
  /// Returns true if successfully written.
  Future<bool> writeMindfulMinutes({
    required DateTime startTime,
    required Duration duration,
    String? notes,
  }) async {
    try {
      final endTime = startTime.add(duration);

      final success = await _health.writeHealthData(
        value: duration.inMinutes.toDouble(),
        type: HealthDataType.MINDFULNESS,
        startTime: startTime,
        endTime: endTime,
      );

      debugPrint('Mindful minutes written: $success');
      return success;
    } catch (e) {
      debugPrint('Error writing mindful minutes: $e');
      return false;
    }
  }

  /// Log a complete binaural session to HealthKit.
  ///
  /// Writes mindful minutes for the session.
  Future<bool> logBinauralSession({
    required DateTime startTime,
    required Duration duration,
    String? presetName,
    double? beatFrequency,
  }) async {
    // Only log sessions longer than 1 minute
    if (duration.inMinutes < 1) {
      debugPrint(
        'Session too short to log to HealthKit: ${duration.inSeconds}s',
      );
      return false;
    }

    final success = await writeMindfulMinutes(
      startTime: startTime,
      duration: duration,
      notes: presetName != null
          ? 'MindWeave: $presetName${beatFrequency != null ? ' (${beatFrequency}Hz)' : ''}'
          : 'MindWeave binaural beats session',
    );

    return success;
  }

  /// Get sleep data from the last 24 hours.
  Future<List<HealthDataPoint>> getSleepData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    try {
      return await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [HealthDataType.SLEEP_ASLEEP],
      );
    } catch (e) {
      debugPrint('Error fetching sleep data: $e');
      return [];
    }
  }

  /// Calculate a simple sleep quality score (0.0 - 1.0).
  ///
  /// Based on total sleep duration vs. 8 hours target.
  double calculateSleepQualityScore(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0.0;

    double totalMinutes = 0;
    for (var point in data) {
      final duration = point.dateTo.difference(point.dateFrom);
      totalMinutes += duration.inMinutes;
    }

    final score = totalMinutes / (8 * 60);
    return score.clamp(0.0, 1.0);
  }

  /// Get total mindful minutes for today.
  Future<int> getTodayMindfulMinutes() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    try {
      final data = await _health.getHealthDataFromTypes(
        startTime: startOfDay,
        endTime: now,
        types: [HealthDataType.MINDFULNESS],
      );

      int totalMinutes = 0;
      for (var point in data) {
        if (point.value is NumericHealthValue) {
          totalMinutes += (point.value as NumericHealthValue).numericValue
              .toInt();
        }
      }
      return totalMinutes;
    } catch (e) {
      debugPrint('Error fetching mindful minutes: $e');
      return 0;
    }
  }
}
