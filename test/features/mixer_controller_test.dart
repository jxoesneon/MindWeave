import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/core/audio/mixer_controller.dart';
import 'package:mindweave/core/audio/mixer_state.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mocks.dart';

void main() {
  group('MixerController Tests', () {
    late MockAudioService mockAudioService;
    late ProviderContainer container;

    setUp(() {
      mockAudioService = MockAudioService();
      registerTestFallbacks();

      when(() => mockAudioService.init()).thenAnswer((_) async => Future.value());
      when(() => mockAudioService.startBackgroundNoise(any(), volume: any(named: 'volume'))).thenAnswer((_) async => Future.value());
      when(() => mockAudioService.setBackgroundVolume(any())).thenReturn(null);

      container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
      );
    });

    test('initial state should have default volume and no noise', () {
      final state = container.read(mixerControllerProvider);
      expect(state.backgroundVolume, 0.2);
      expect(state.noiseType, NoiseType.none);
    });

    test('setNoiseType should update state and call service for white noise', () async {
      await container.read(mixerControllerProvider.notifier).setNoiseType(NoiseType.white);
      
      final state = container.read(mixerControllerProvider);
      expect(state.noiseType, NoiseType.white);
      verify(() => mockAudioService.startBackgroundNoise(any(), volume: 0.2)).called(1);
    });

    test('updateBackgroundVolume should update state and volume in service', () {
      container.read(mixerControllerProvider.notifier).updateBackgroundVolume(0.5);
      
      final state = container.read(mixerControllerProvider);
      expect(state.backgroundVolume, 0.5);
      verify(() => mockAudioService.setBackgroundVolume(0.5)).called(1);
    });
  });
}
