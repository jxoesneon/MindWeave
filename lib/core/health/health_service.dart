import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class HealthService {
  final Health _health;

  HealthService({Health? health}) : _health = health ?? Health();

  Future<bool> requestPermissions() async {
    final types = [HealthDataType.SLEEP_SESSION];
    final permissions = [HealthDataAccess.READ];
    
    // Check if permissions already granted
    bool? hasPermissions = await _health.hasPermissions(types, permissions: permissions);
    if (hasPermissions == true) return true;

    // Request using standard plugin
    return await _health.requestAuthorization(types, permissions: permissions);
  }

  Future<List<HealthDataPoint>> getSleepData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    try {
      return await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [HealthDataType.SLEEP_SESSION],
      );
    } catch (e) {
      debugPrint('Error fetching sleep data: $e');
      return [];
    }
  }

  double calculateSleepQualityScore(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0.0;
    
    // Simple logic: total hours / 8.0
    double totalMinutes = 0;
    for (var point in data) {
      if (point.value is NumericHealthValue) {
        // This depends on the platform, usually SLEEP_SESSION value is in minutes or hours
        // For simplicity, let's assume we can get duration
        final duration = point.dateTo.difference(point.dateFrom);
        totalMinutes += duration.inMinutes;
      }
    }
    
    final score = totalMinutes / (8 * 60);
    return score.clamp(0.0, 1.0);
  }
}
