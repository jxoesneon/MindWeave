import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/audio/binaural_calculator.dart';

void main() {
  group('BinauralFrequencyCalculator Tests', () {
    final calculator = BinauralFrequencyCalculator();

    test('calculate should return correct left and right frequencies', () {
      const carrier = 200.0;
      const beat = 10.0;
      
      final result = calculator.calculate(
        carrierFreq: carrier,
        beatFreq: beat,
      );

      expect(result.leftFreq, 195.0);
      expect(result.rightFreq, 205.0);
    });

    test('static calculateFrequencies should return correct values', () {
      final (left, right) = BinauralFrequencyCalculator.calculateFrequencies(
        carrierFrequency: 440.0,
        beatFrequency: 4.0,
      );

      expect(left, 438.0);
      expect(right, 442.0);
    });

    test('validateFrequencies should return true for valid ranges', () {
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 200,
          beatFrequency: 10,
        ),
        true,
      );
    });

    test('validateFrequencies should return false for extreme beat frequencies', () {
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 200,
          beatFrequency: 0.1, // too low
        ),
        false,
      );
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 200,
          beatFrequency: 150, // too high
        ),
        false,
      );
    });

    test('validateFrequencies should return false for extreme carrier frequencies', () {
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 50, // too low
          beatFrequency: 10,
        ),
        false,
      );
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 2000, // too high
          beatFrequency: 10,
        ),
        false,
      );
    });
  });
}
