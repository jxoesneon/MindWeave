import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/core/audio/audio_controller.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mocks.dart';

void main() {
  group('AudioController Tests', () {
    late MockAudioService mockAudioService;
    late ProviderContainer container;

    setUp(() {
      mockAudioService = MockAudioService();
      registerTestFallbacks();

      // Mock AudioService methods
      when(() => mockAudioService.init()).thenAnswer((_) async => Future.value());
      when(() => mockAudioService.startBinaural(
            leftFreq: any(named: 'leftFreq'),
            rightFreq: any(named: 'rightFreq'),
            volume: any(named: 'volume'),
          )).thenAnswer((_) async => Future.value());
      when(() => mockAudioService.stop()).thenAnswer((_) async => Future.value());
      when(() => mockAudioService.setVolume(any())).thenReturn(null);
      when(() => mockAudioService.updateFrequencies(any(), any())).thenReturn(null);

      container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
      );
    });

    test('initial state should be non-playing with default frequencies', () {
      final state = container.read(audioControllerProvider);
      expect(state.isPlaying, false);
      expect(state.carrierFrequency, 200.0);
      expect(state.beatFrequency, 10.0);
    });

    test('selectPreset should update frequencies and selectedPreset', () async {
      await container.read(audioControllerProvider.notifier).selectPreset(BrainwavePreset.deepSleep);
      final state = container.read(audioControllerProvider);
      
      expect(state.selectedPreset, BrainwavePreset.deepSleep);
      expect(state.carrierFrequency, BrainwavePreset.deepSleep.defaultCarrierFrequency);
      expect(state.beatFrequency, BrainwavePreset.deepSleep.beatFrequency);
    });

    test('togglePlay should call startBinaural when starting', () async {
      await container.read(audioControllerProvider.notifier).togglePlay();
      
      verify(() => mockAudioService.startBinaural(
            leftFreq: any(named: 'leftFreq'),
            rightFreq: any(named: 'rightFreq'),
            volume: any(named: 'volume'),
          )).called(1);
      
      expect(container.read(audioControllerProvider).isPlaying, true);
    });

    test('updateCarrierFreq should update state and call service if playing', () async {
      final notifier = container.read(audioControllerProvider.notifier);
      await notifier.togglePlay(); // start playing
      
      notifier.updateCarrierFreq(300.0);
      
      expect(container.read(audioControllerProvider).carrierFrequency, 300.0);
      verify(() => mockAudioService.updateFrequencies(any(), any())).called(1);
    });

    test('setTimer should update state with remaining time', () {
      const duration = Duration(minutes: 5);
      container.read(audioControllerProvider.notifier).setTimer(duration);
      
      final state = container.read(audioControllerProvider);
      expect(state.timerDuration, duration);
      expect(state.remainingTime, duration);
    });
  });
}
