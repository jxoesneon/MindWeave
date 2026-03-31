import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/audio/binaural_calculator.dart';

void main() {
  group('BinauralFrequencyCalculator Tests', () {
    late BinauralFrequencyCalculator calculator;

    setUp(() {
      calculator = BinauralFrequencyCalculator();
    });

    test('calculate returns correct left and right frequencies', () {
      final result = calculator.calculate(
        carrierFreq: 200.0,
        beatFreq: 10.0,
      );

      expect(result.leftFreq, closeTo(195.0, 0.001));
      expect(result.rightFreq, closeTo(205.0, 0.001));
    });

    test('calculate with zero beat returns same frequency for both channels', () {
      final result = calculator.calculate(
        carrierFreq: 200.0,
        beatFreq: 0.0,
      );

      expect(result.leftFreq, 200.0);
      expect(result.rightFreq, 200.0);
    });

    test('calculateFrequencies static method returns correct tuple', () {
      final (left, right) = BinauralFrequencyCalculator.calculateFrequencies(
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
      );

      expect(left, closeTo(195.0, 0.001));
      expect(right, closeTo(205.0, 0.001));
    });

    test('validateFrequencies returns true for valid frequencies', () {
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 200.0,
          beatFrequency: 10.0,
        ),
        true,
      );
    });

    test('validateFrequencies returns false for invalid beat frequency', () {
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 200.0,
          beatFrequency: 0.0,
        ),
        false,
      );
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 200.0,
          beatFrequency: 101.0,
        ),
        false,
      );
    });

    test('validateFrequencies returns false for invalid carrier frequency', () {
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 99.0,
          beatFrequency: 10.0,
        ),
        false,
      );
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 1001.0,
          beatFrequency: 10.0,
        ),
        false,
      );
    });

    test('validateFrequencies returns false if resulting frequencies are negative', () {
      expect(
        BinauralFrequencyCalculator.validateFrequencies(
          carrierFrequency: 10.0,
          beatFrequency: 50.0,
        ),
        false,
      );
    });

    test('BinauralResult stores frequencies correctly', () {
      final result = BinauralResult(leftFreq: 195.0, rightFreq: 205.0);
      expect(result.leftFreq, 195.0);
      expect(result.rightFreq, 205.0);
    });
  });
}
