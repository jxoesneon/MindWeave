import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindweave/core/audio/audio_controller.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';

import '../test/mocks.dart';

/// Integration tests for AudioController
/// These tests require the flutter_soloud audio engine to be initialized
/// Run with: flutter test integration_test/audio_controller_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AudioController Integration Tests', () {
    late ProviderContainer container;
    late MockAudioService mockAudioService;

    setUpAll(() {
      registerTestFallbacks();
    });

    setUp(() {
      mockAudioService = MockAudioService();

      container = ProviderContainer(
        overrides: [audioServiceProvider.overrideWithValue(mockAudioService)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('AudioController initializes with default state', (
      WidgetTester tester,
    ) async {
      final state = container.read(audioControllerProvider);

      expect(state.isPlaying, false);
      expect(state.carrierFrequency, 250.0);
      expect(state.beatFrequency, 10.0);
      expect(state.selectedPreset, isNull);
    });

    testWidgets('selectPreset updates frequencies and selectedPreset', (
      WidgetTester tester,
    ) async {
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

    testWidgets('togglePlay should start playing when not playing', (
      WidgetTester tester,
    ) async {
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

    testWidgets('togglePlay should stop playing when already playing', (
      WidgetTester tester,
    ) async {
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

    testWidgets('updateCarrierFreq should update carrier frequency', (
      WidgetTester tester,
    ) async {
      final controller = container.read(audioControllerProvider.notifier);

      controller.updateCarrierFreq(300.0);

      final state = container.read(audioControllerProvider);
      expect(state.carrierFrequency, 300.0);
    });

    testWidgets('updateBeatFreq should update beat frequency', (
      WidgetTester tester,
    ) async {
      final controller = container.read(audioControllerProvider.notifier);

      controller.updateBeatFrequency(15.0);

      final state = container.read(audioControllerProvider);
      expect(state.beatFrequency, 15.0);
    });

    testWidgets('setVolume should update volume level', (
      WidgetTester tester,
    ) async {
      final controller = container.read(audioControllerProvider.notifier);

      controller.updateVolume(0.5);

      final state = container.read(audioControllerProvider);
      expect(state.volume, 0.5);
    });

    testWidgets('setTimer should update timer duration', (
      WidgetTester tester,
    ) async {
      final controller = container.read(audioControllerProvider.notifier);

      controller.setTimer(const Duration(minutes: 30));

      final state = container.read(audioControllerProvider);
      expect(state.timerDuration, const Duration(minutes: 30));
    });
  });
}
