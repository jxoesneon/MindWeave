import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';

void main() {
  group('BrainwavePreset Tests', () {
    test('allPresets returns all 7 built-in presets', () {
      final presets = BrainwavePreset.allPresets;

      expect(presets.length, 7);
      expect(
        presets.map((p) => p.id),
        containsAll([
          'deep_sleep',
          'meditation',
          'relaxation',
          'focus',
          'cognition',
          'lucid_dream',
          'energy_boost',
        ]),
      );
    });

    test('getByBand returns correct presets', () {
      final deltaPresets = BrainwavePreset.getByBand(BrainwaveBand.delta);
      expect(deltaPresets.map((p) => p.id), contains('deep_sleep'));

      final thetaPresets = BrainwavePreset.getByBand(BrainwaveBand.theta);
      expect(thetaPresets.map((p) => p.id), contains('meditation'));

      final alphaPresets = BrainwavePreset.getByBand(BrainwaveBand.alpha);
      expect(alphaPresets.map((p) => p.id), contains('relaxation'));

      final betaPresets = BrainwavePreset.getByBand(BrainwaveBand.beta);
      expect(
        betaPresets.map((p) => p.id),
        containsAll(['focus', 'energy_boost']),
      );

      final gammaPresets = BrainwavePreset.getByBand(BrainwaveBand.gamma);
      expect(gammaPresets.map((p) => p.id), contains('cognition'));
    });

    test('getById returns correct preset', () {
      final deepSleep = BrainwavePreset.getById('deep_sleep');
      expect(deepSleep, isNotNull);
      expect(deepSleep?.name, 'Deep Sleep');

      final meditation = BrainwavePreset.getById('meditation');
      expect(meditation, isNotNull);
      expect(meditation?.name, 'Meditation');
    });

    test('getById returns null for invalid id', () {
      final result = BrainwavePreset.getById('invalid_id');
      expect(result, isNull);
    });

    test('freePresets returns only non-premium presets', () {
      final freePresets = BrainwavePreset.freePresets;
      expect(freePresets.every((p) => !p.isPremium), true);
    });

    test('premiumPresets returns only premium presets', () {
      final premiumPresets = BrainwavePreset.premiumPresets;
      expect(premiumPresets.every((p) => p.isPremium), true);
    });

    test('preset properties are correct', () {
      final deepSleep = BrainwavePreset.deepSleep;

      expect(deepSleep.id, 'deep_sleep');
      expect(deepSleep.name, 'Deep Sleep');
      expect(deepSleep.band, BrainwaveBand.delta);
      expect(deepSleep.beatFrequency, 2.5);
      expect(deepSleep.defaultCarrierFrequency, 150.0);
      expect(deepSleep.isPremium, false);
    });

    test('meditation preset has correct properties', () {
      final meditation = BrainwavePreset.meditation;

      expect(meditation.id, 'meditation');
      expect(meditation.name, 'Meditation');
      expect(meditation.band, BrainwaveBand.theta);
      expect(meditation.beatFrequency, 6.0);
    });

    test('relaxation preset has correct properties', () {
      final relaxation = BrainwavePreset.relaxation;

      expect(relaxation.id, 'relaxation');
      expect(relaxation.name, 'Relaxation');
      expect(relaxation.band, BrainwaveBand.alpha);
      expect(relaxation.beatFrequency, 10.0);
    });

    test('focus preset has correct properties', () {
      final focus = BrainwavePreset.focus;

      expect(focus.id, 'focus');
      expect(focus.name, 'Focus');
      expect(focus.band, BrainwaveBand.beta);
      expect(focus.beatFrequency, 15.0);
    });

    test('cognition preset has correct properties', () {
      final cognition = BrainwavePreset.cognition;

      expect(cognition.id, 'cognition');
      expect(cognition.name, 'Cognition');
      expect(cognition.band, BrainwaveBand.gamma);
      expect(cognition.beatFrequency, 40.0);
    });

    test('energyBoost preset has correct properties', () {
      final energyBoost = BrainwavePreset.energyBoost;

      expect(energyBoost.id, 'energy_boost');
      expect(energyBoost.name, 'Energy Boost');
      expect(energyBoost.band, BrainwaveBand.beta);
      expect(energyBoost.beatFrequency, 18.0);
      expect(energyBoost.isPremium, true);
    });

    test('lucidDream preset has correct properties', () {
      final lucidDream = BrainwavePreset.lucidDream;

      expect(lucidDream.id, 'lucid_dream');
      expect(lucidDream.name, 'Lucid Dream');
      expect(lucidDream.band, BrainwaveBand.theta);
    });

    test('formattedBeatFrequency returns correct string', () {
      final preset = BrainwavePreset.deepSleep;
      expect(preset.formattedBeatFrequency, '2.5 Hz');
    });

    test('formattedCarrierFrequency returns correct string', () {
      final preset = BrainwavePreset.deepSleep;
      expect(preset.formattedCarrierFrequency, '150 Hz');
    });

    test('formattedDuration returns correct string', () {
      final preset = BrainwavePreset.deepSleep;
      expect(preset.formattedDuration, '30 min');
    });

    test('isValidBeatFrequency returns true for valid frequency', () {
      final preset = BrainwavePreset.deepSleep;
      expect(preset.isValidBeatFrequency, true);
    });

    test('isValidCarrierFrequency returns true for valid frequency', () {
      final preset = BrainwavePreset.deepSleep;
      expect(preset.isValidCarrierFrequency, true);
    });

    test('preset iconPath is not null', () {
      final preset = BrainwavePreset.deepSleep;
      expect(preset.iconPath, isNotNull);
      expect(preset.iconPath.isNotEmpty, true);
    });

    test('preset accentColorValue is not null', () {
      final preset = BrainwavePreset.deepSleep;
      expect(preset.accentColorValue, isNotNull);
    });

    test('BrainwaveBand enum values are correct', () {
      expect(BrainwaveBand.delta.minFreq, 0.5);
      expect(BrainwaveBand.delta.maxFreq, 4.0);
      expect(BrainwaveBand.delta.description, 'Deep Sleep');

      expect(BrainwaveBand.theta.minFreq, 4.0);
      expect(BrainwaveBand.theta.maxFreq, 8.0);
      expect(BrainwaveBand.theta.description, 'Meditation');

      expect(BrainwaveBand.alpha.minFreq, 8.0);
      expect(BrainwaveBand.alpha.maxFreq, 12.0);
      expect(BrainwaveBand.alpha.description, 'Relaxation');

      expect(BrainwaveBand.beta.minFreq, 12.0);
      expect(BrainwaveBand.beta.maxFreq, 30.0);
      expect(BrainwaveBand.beta.description, 'Focus');

      expect(BrainwaveBand.gamma.minFreq, 30.0);
      expect(BrainwaveBand.gamma.maxFreq, 100.0);
      expect(BrainwaveBand.gamma.description, 'Cognition');
    });
  });
}
