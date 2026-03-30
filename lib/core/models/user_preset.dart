import 'package:freezed_annotation/freezed_annotation.dart';
import '../audio/mixer_state.dart';

part 'user_preset.freezed.dart';
part 'user_preset.g.dart';

@Freezed(toJson: true)
abstract class UserPreset with _$UserPreset {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserPreset({
    required String id,
    required String userId,
    required String name,
    required double carrierFrequency,
    required double beatFrequency,
    @Default(NoiseType.none) NoiseType noiseType,
    @Default(0.2) double noiseVolume,
    @Default(1.0) double binauralVolume,
    @Default(false) bool isPublic,
    required DateTime createdAt,
  }) = _UserPreset;

  factory UserPreset.fromJson(Map<String, dynamic> json) =>
      _$UserPresetFromJson(json);
}
