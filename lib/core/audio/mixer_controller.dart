import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'audio_service.dart';
import 'audio_service_provider.dart';
import 'mixer_state.dart';
import 'noise_generator.dart';
import 'dart:async';

part 'mixer_controller.g.dart';

@riverpod
class MixerController extends _$MixerController {
  late final AudioService _audioService;

  @override
  MixerState build() {
    _audioService = ref.read(audioServiceProvider);
    return const MixerState(backgroundVolume: 0.2, noiseType: NoiseType.none);
  }

  Future<void> setNoiseType(NoiseType type) async {
    if (state.noiseType == type) return;

    state = state.copyWith(noiseType: type);

    if (type == NoiseType.none) {
      // In a real separate service, we might need a central AudioService instance.
      // For now, let's assume MixerController can stop noise via its own service instance
      // Or we should make AudioService a singleton/provider.
    } else {
      final wavData = switch (type) {
        NoiseType.white => NoiseGenerator.generateWhiteNoise(
          const Duration(seconds: 2),
        ),
        NoiseType.pink => NoiseGenerator.generatePinkNoise(
          const Duration(seconds: 2),
        ),
        _ => null,
      };

      if (wavData != null) {
        await _audioService.startBackgroundNoise(
          wavData,
          volume: state.backgroundVolume,
        );
      }
    }
  }

  void updateBackgroundVolume(double volume) {
    state = state.copyWith(backgroundVolume: volume);
    _audioService.setBackgroundVolume(volume);
  }
}
