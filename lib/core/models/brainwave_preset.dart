import 'package:freezed_annotation/freezed_annotation.dart';

part 'brainwave_preset.freezed.dart';
part 'brainwave_preset.g.dart';

@freezed
abstract class BrainwavePreset with _$BrainwavePreset {
  const factory BrainwavePreset({
    required String id,
    required String name,
    required String description,
    required BrainwaveBand band,
    required double beatFrequency,
    @Default(250.0) double defaultCarrierFrequency,
    @Default(100.0) double minCarrierFrequency,
    @Default(500.0) double maxCarrierFrequency,
    required String iconPath,
    required int accentColorValue,
    @Default([]) List<String> tags,
  }) = _BrainwavePreset;

  factory BrainwavePreset.fromJson(Map<String, dynamic> json) =>
      _$BrainwavePresetFromJson(json);

  static const deepSleep = BrainwavePreset(
    id: 'deep_sleep',
    name: 'Deep Sleep',
    description: 'Perfect for falling into a deep, restful slumber.',
    band: BrainwaveBand.delta,
    beatFrequency: 2.5,
    defaultCarrierFrequency: 150.0,
    iconPath: 'assets/icons/sleep.png',
    accentColorValue: 0xFF1A237E,
    tags: ['sleep', 'rest', 'delta'],
  );

  static const meditation = BrainwavePreset(
    id: 'meditation',
    name: 'Meditation',
    description: 'Deep relaxation and creative visualization.',
    band: BrainwaveBand.theta,
    beatFrequency: 6.0,
    defaultCarrierFrequency: 200.0,
    iconPath: 'assets/icons/meditate.png',
    accentColorValue: 0xFF4A148C,
    tags: ['meditation', 'theta', 'relaxed'],
  );

  static const focus = BrainwavePreset(
    id: 'focus',
    name: 'Focus',
    description: 'Enhance concentration and cognitive performance.',
    band: BrainwaveBand.beta,
    beatFrequency: 15.0,
    defaultCarrierFrequency: 250.0,
    iconPath: 'assets/icons/focus.png',
    accentColorValue: 0xFF004D40,
    tags: ['focus', 'beta', 'work'],
  );
}

enum BrainwaveBand {
  delta(0.5, 4.0, 'Deep Sleep'),
  theta(4.0, 8.0, 'Meditation'),
  alpha(8.0, 12.0, 'Relaxation'),
  beta(12.0, 30.0, 'Focus'),
  gamma(30.0, 100.0, 'Cognition');

  final double minFreq;
  final double maxFreq;
  final String description;

  const BrainwaveBand(this.minFreq, this.maxFreq, this.description);
}
