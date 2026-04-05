import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindweave/core/audio/audio_controller.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';
import 'package:mindweave/core/models/user_preset.dart';
import 'package:mindweave/core/services/session_history_service.dart';
import 'package:mindweave/core/services/analytics_service.dart';
import '../mocks.dart';

void main() {
  late ProviderContainer container;
  late FakeAudioService fakeAudioService;
  late MockSessionHistoryService mockSessionHistoryService;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    registerTestFallbacks();

    fakeAudioService = FakeAudioService();
    mockSessionHistoryService = MockSessionHistoryService();
    mockAnalyticsService = MockAnalyticsService();

    setupMockSessionHistoryService(mockSessionHistoryService);
    setupMockAnalyticsService(mockAnalyticsService);

    container = ProviderContainer(
      overrides: [
        audioServiceProvider.overrideWithValue(fakeAudioService),
        sessionHistoryServiceProvider.overrideWithValue(
          mockSessionHistoryService,
        ),
        analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AudioController Tests', () {
    test('initial state should be non-playing with default frequencies', () {
      final state = container.read(audioControllerProvider);

      expect(state.isPlaying, false);
      expect(state.carrierFrequency, 200.0);
      expect(state.beatFrequency, 10.0);
      expect(state.volume, 0.5);
      expect(state.selectedPreset, null);
      expect(state.timerDuration, null);
      expect(state.remainingTime, null);
    });

    test('selectPreset should update frequencies and selectedPreset', () async {
      final controller = container.read(audioControllerProvider.notifier);
      final preset = const BrainwavePreset(
        id: 'alpha',
        name: 'Alpha Relaxation',
        band: BrainwaveBand.alpha,
        beatFrequency: 10.0,
        defaultCarrierFrequency: 200.0,
        description: 'Relaxing alpha waves',
        iconPath: 'assets/icons/test.png',
        accentColorValue: 0xFF000000,
      );

      await controller.selectPreset(preset);

      final state = container.read(audioControllerProvider);
      expect(state.selectedPreset, preset);
      expect(state.carrierFrequency, 200.0);
      expect(state.beatFrequency, 10.0);
    });

    test('togglePlay should start playing when not playing', () async {
      final controller = container.read(audioControllerProvider.notifier);
      final preset = const BrainwavePreset(
        id: 'alpha',
        name: 'Alpha Relaxation',
        band: BrainwaveBand.alpha,
        beatFrequency: 10.0,
        defaultCarrierFrequency: 200.0,
        description: 'Relaxing alpha waves',
        iconPath: 'assets/icons/test.png',
        accentColorValue: 0xFF000000,
      );

      await controller.selectPreset(preset);
      await controller.togglePlay();

      final state = container.read(audioControllerProvider);
      expect(state.isPlaying, true);
    });

    test('togglePlay should stop playing when already playing', () async {
      final controller = container.read(audioControllerProvider.notifier);
      final preset = const BrainwavePreset(
        id: 'alpha',
        name: 'Alpha Relaxation',
        band: BrainwaveBand.alpha,
        beatFrequency: 10.0,
        defaultCarrierFrequency: 200.0,
        description: 'Relaxing alpha waves',
        iconPath: 'assets/icons/test.png',
        accentColorValue: 0xFF000000,
      );

      await controller.selectPreset(preset);
      await controller.togglePlay();
      await controller.togglePlay();

      final state = container.read(audioControllerProvider);
      expect(state.isPlaying, false);
    });

    test('updateCarrierFreq should update state', () {
      final controller = container.read(audioControllerProvider.notifier);

      controller.updateCarrierFreq(250.0);

      final state = container.read(audioControllerProvider);
      expect(state.carrierFrequency, 250.0);
    });

    test('updateBeatFrequency should update state', () {
      final controller = container.read(audioControllerProvider.notifier);

      controller.updateBeatFrequency(15.0);

      final state = container.read(audioControllerProvider);
      expect(state.beatFrequency, 15.0);
    });

    test('setTimer should update state with remaining time', () {
      final controller = container.read(audioControllerProvider.notifier);
      const duration = Duration(minutes: 10);

      controller.setTimer(duration);

      final state = container.read(audioControllerProvider);
      expect(state.timerDuration, duration);
      expect(state.remainingTime, duration);
    });

    test('loadUserPreset should update frequencies from user preset', () async {
      final controller = container.read(audioControllerProvider.notifier);
      final userPreset = UserPreset(
        id: 'custom-1',
        userId: 'user-1',
        name: 'My Custom',
        carrierFrequency: 300.0,
        beatFrequency: 20.0,
        binauralVolume: 0.7,
        createdAt: DateTime.now(),
      );

      await controller.loadUserPreset(userPreset);

      final state = container.read(audioControllerProvider);
      expect(state.carrierFrequency, 300.0);
      expect(state.beatFrequency, 20.0);
    });
  });
}
