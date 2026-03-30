import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/brainwave_preset.dart';

part 'audio_state.freezed.dart';

@freezed
abstract class AudioState with _$AudioState {
  const factory AudioState({
    required bool isPlaying,
    required double carrierFrequency,
    required double beatFrequency,
    required double volume,
    BrainwavePreset? selectedPreset,
    Duration? timerDuration,
    Duration? remainingTime,
  }) = _AudioState;
}
