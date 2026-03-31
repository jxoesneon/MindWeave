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
    @Default(15) Duration defaultDuration, // minutes
    @Default(false) bool isPremium,
    @Default(0.8) double defaultVolume,
    Map<String, dynamic>? metadata,
  }) = _BrainwavePreset;

  factory BrainwavePreset.fromJson(Map<String, dynamic> json) =>
      _$BrainwavePresetFromJson(json);

  const BrainwavePreset._();

  // Built-in presets
  static const deepSleep = BrainwavePreset(
    id: 'deep_sleep',
    name: 'Deep Sleep',
    description: 'Perfect for falling into a deep, restful slumber.',
    band: BrainwaveBand.delta,
    beatFrequency: 2.5,
    defaultCarrierFrequency: 150.0,
    iconPath: 'assets/icons/sleep.png',
    accentColorValue: 0xFF4A90D9,
    tags: ['sleep', 'rest', 'delta'],
    defaultDuration: Duration(minutes: 30),
    isPremium: false,
  );

  static const meditation = BrainwavePreset(
    id: 'meditation',
    name: 'Meditation',
    description: 'Deep relaxation and creative visualization.',
    band: BrainwaveBand.theta,
    beatFrequency: 6.0,
    defaultCarrierFrequency: 200.0,
    iconPath: 'assets/icons/meditate.png',
    accentColorValue: 0xFF9B59B6,
    tags: ['meditation', 'theta', 'relaxed'],
    defaultDuration: Duration(minutes: 20),
    isPremium: false,
  );

  static const relaxation = BrainwavePreset(
    id: 'relaxation',
    name: 'Relaxation',
    description: 'Calm your mind and release stress.',
    band: BrainwaveBand.alpha,
    beatFrequency: 10.0,
    defaultCarrierFrequency: 250.0,
    iconPath: 'assets/icons/relax.png',
    accentColorValue: 0xFF7B68EE,
    tags: ['relaxation', 'alpha', 'calm'],
    defaultDuration: Duration(minutes: 15),
    isPremium: false,
  );

  static const focus = BrainwavePreset(
    id: 'focus',
    name: 'Focus',
    description: 'Enhance concentration and cognitive performance.',
    band: BrainwaveBand.beta,
    beatFrequency: 15.0,
    defaultCarrierFrequency: 250.0,
    iconPath: 'assets/icons/focus.png',
    accentColorValue: 0xFFE67E22,
    tags: ['focus', 'beta', 'work'],
    defaultDuration: Duration(minutes: 25),
    isPremium: false,
  );

  static const cognition = BrainwavePreset(
    id: 'cognition',
    name: 'Cognition',
    description: 'Heightened mental processing and problem-solving.',
    band: BrainwaveBand.gamma,
    beatFrequency: 40.0,
    defaultCarrierFrequency: 300.0,
    iconPath: 'assets/icons/brain.png',
    accentColorValue: 0xFFE74C3C,
    tags: ['cognition', 'gamma', 'learning'],
    defaultDuration: Duration(minutes: 20),
    isPremium: true,
  );

  static const lucidDream = BrainwavePreset(
    id: 'lucid_dream',
    name: 'Lucid Dream',
    description: 'Enhance dream awareness and control.',
    band: BrainwaveBand.theta,
    beatFrequency: 4.5,
    defaultCarrierFrequency: 180.0,
    iconPath: 'assets/icons/dream.png',
    accentColorValue: 0xFF9B59B6,
    tags: ['dreams', 'theta', 'lucid'],
    defaultDuration: Duration(minutes: 45),
    isPremium: true,
  );

  static const energyBoost = BrainwavePreset(
    id: 'energy_boost',
    name: 'Energy Boost',
    description: 'Natural energy enhancement without caffeine.',
    band: BrainwaveBand.beta,
    beatFrequency: 18.0,
    defaultCarrierFrequency: 280.0,
    iconPath: 'assets/icons/energy.png',
    accentColorValue: 0xFFE67E22,
    tags: ['energy', 'beta', 'vitality'],
    defaultDuration: Duration(minutes: 10),
    isPremium: true,
  );

  // Get all built-in presets
  static List<BrainwavePreset> get allPresets => [
    deepSleep,
    meditation,
    relaxation,
    focus,
    cognition,
    lucidDream,
    energyBoost,
  ];

  // Get free presets
  static List<BrainwavePreset> get freePresets =>
      allPresets.where((preset) => !preset.isPremium).toList();

  // Get premium presets
  static List<BrainwavePreset> get premiumPresets =>
      allPresets.where((preset) => preset.isPremium).toList();

  // Get preset by ID
  static BrainwavePreset? getById(String id) {
    try {
      return allPresets.firstWhere((preset) => preset.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get presets by brainwave band
  static List<BrainwavePreset> getByBand(BrainwaveBand band) {
    return allPresets.where((preset) => preset.band == band).toList();
  }

  // Helper methods
  String get formattedBeatFrequency => '${beatFrequency.toStringAsFixed(1)} Hz';
  String get formattedCarrierFrequency =>
      '${defaultCarrierFrequency.toStringAsFixed(0)} Hz';
  String get formattedDuration => '${defaultDuration.inMinutes} min';

  bool get isValidBeatFrequency =>
      beatFrequency >= band.minFreq && beatFrequency <= band.maxFreq;

  bool get isValidCarrierFrequency =>
      defaultCarrierFrequency >= minCarrierFrequency &&
      defaultCarrierFrequency <= maxCarrierFrequency;
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
