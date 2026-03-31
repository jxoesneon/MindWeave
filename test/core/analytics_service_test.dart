import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/services/analytics_service.dart';

void main() {
  group('AnalyticsService', () {
    test('is a singleton', () {
      final a = AnalyticsService();
      final b = AnalyticsService();
      expect(identical(a, b), isTrue);
    });

    test('isEnabled returns false before initialization', () {
      final service = AnalyticsService();
      expect(service.isEnabled, isFalse);
    });

    test('trackSessionStart does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(
        service.trackSessionStart(
          presetId: 'test',
          band: 'alpha',
          beatFrequency: 10.0,
          carrierFrequency: 200.0,
        ),
        completes,
      );
    });

    test('trackSessionStop does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(
        service.trackSessionStop(
          presetId: 'test',
          durationSeconds: 300,
          completed: true,
        ),
        completes,
      );
    });

    test('capture does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(
        service.capture('test_event', properties: {'key': 'value'}),
        completes,
      );
    });

    test('screen does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(service.screen('TestScreen'), completes);
    });

    test('identify does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(service.identify('user123'), completes);
    });

    test('reset does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(service.reset(), completes);
    });

    test('trackPresetSelected does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(
        service.trackPresetSelected(presetId: 'alpha_relaxation'),
        completes,
      );
    });

    test('trackFavoriteToggled does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(
        service.trackFavoriteToggled(presetId: 'test', isFavorite: true),
        completes,
      );
    });

    test('trackThemeChanged does not throw when not initialized', () async {
      final service = AnalyticsService();
      await expectLater(
        service.trackThemeChanged(themeMode: 'dark'),
        completes,
      );
    });

    test(
      'trackHealthSyncToggled does not throw when not initialized',
      () async {
        final service = AnalyticsService();
        await expectLater(
          service.trackHealthSyncToggled(enabled: true),
          completes,
        );
      },
    );

    test(
      'trackDonationInteraction does not throw when not initialized',
      () async {
        final service = AnalyticsService();
        await expectLater(
          service.trackDonationInteraction(tier: 'supporter'),
          completes,
        );
      },
    );
  });
}
