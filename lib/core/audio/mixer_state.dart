import 'package:freezed_annotation/freezed_annotation.dart';

part 'mixer_state.freezed.dart';

@freezed
abstract class MixerState with _$MixerState {
  const factory MixerState({
    @Default(0.2) double backgroundVolume,
    @Default(NoiseType.none) NoiseType noiseType,
  }) = _MixerState;
}

enum NoiseType { none, white, pink, brown }
