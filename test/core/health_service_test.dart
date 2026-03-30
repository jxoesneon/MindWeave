import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:health/health.dart';
import 'package:mindweave/core/health/health_service.dart';

class MockHealth extends Mock implements Health {}
class MockHealthDataPoint extends Mock implements HealthDataPoint {}

void main() {
  late MockHealth mockHealth;
  late HealthService healthService;

  setUp(() {
    mockHealth = MockHealth();
    healthService = HealthService(health: mockHealth);
  });

  group('HealthService', () {
    test('requestPermissions() returns true if permissions already granted', () async {
      when(() => mockHealth.hasPermissions(any(), permissions: any(named: 'permissions')))
          .thenAnswer((_) async => true);

      final result = await healthService.requestPermissions();

      expect(result, isTrue);
      verify(() => mockHealth.hasPermissions(any(), permissions: any(named: 'permissions'))).called(1);
    });

    test('requestPermissions() requests authorization if not granted', () async {
      when(() => mockHealth.hasPermissions(any(), permissions: any(named: 'permissions')))
          .thenAnswer((_) async => false);
      when(() => mockHealth.requestAuthorization(any(), permissions: any(named: 'permissions')))
          .thenAnswer((_) async => true);

      final result = await healthService.requestPermissions();

      expect(result, isTrue);
      verify(() => mockHealth.requestAuthorization(any(), permissions: any(named: 'permissions'))).called(1);
    });

    test('getSleepData() fetches data from health plugin', () async {
      final mockData = [MockHealthDataPoint()];
      when(() => mockHealth.getHealthDataFromTypes(
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            types: any(named: 'types'),
          )).thenAnswer((_) async => mockData);

      final result = await healthService.getSleepData();

      expect(result, equals(mockData));
    });

    test('getSleepData() returns empty list on exception', () async {
      when(() => mockHealth.getHealthDataFromTypes(
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            types: any(named: 'types'),
          )).thenThrow(Exception('failure'));

      final result = await healthService.getSleepData();

      expect(result, isEmpty);
    });

    test('calculateSleepQualityScore() returns correct clamped score', () {
      final now = DateTime.now();
      final p1 = MockHealthDataPoint();
      final p2 = MockHealthDataPoint();
      
      when(() => p1.value).thenReturn(NumericHealthValue(numericValue: 120)); // Dummy as it uses date diff
      when(() => p1.dateFrom).thenReturn(now.subtract(const Duration(hours: 4)));
      when(() => p1.dateTo).thenReturn(now);
      when(() => p1.value).thenReturn(NumericHealthValue(numericValue: 240)); 
      
      when(() => p2.dateFrom).thenReturn(now.subtract(const Duration(hours: 6)));
      when(() => p2.dateTo).thenReturn(now.subtract(const Duration(hours: 4)));
      when(() => p2.value).thenReturn(NumericHealthValue(numericValue: 120));

      // Total 4 + 2 = 6 hours. Score = 6 / 8 = 0.75
      final score = healthService.calculateSleepQualityScore([p1, p2]);

      expect(score, closeTo(0.75, 0.01));
    });

    test('calculateSleepQualityScore() clamps to 1.0', () {
      final now = DateTime.now();
      final p = MockHealthDataPoint();
      
      when(() => p.dateFrom).thenReturn(now.subtract(const Duration(hours: 10)));
      when(() => p.dateTo).thenReturn(now);
      when(() => p.value).thenReturn(NumericHealthValue(numericValue: 600));

      final score = healthService.calculateSleepQualityScore([p]);

      expect(score, equals(1.0));
    });

    test('calculateSleepQualityScore() returns 0 for empty list', () {
      final score = healthService.calculateSleepQualityScore([]);
      expect(score, equals(0.0));
    });
  });
}
