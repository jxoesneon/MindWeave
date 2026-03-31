import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/audio/fft_visualization.dart';

void main() {
  group('FFTVisualizationProcessor Tests', () {
    late FFTVisualizationProcessor processor;

    setUp(() {
      processor = FFTVisualizationProcessor();
    });

    test('constructor creates processor with default FFT size', () {
      expect(processor, isNotNull);
    });

    test('constructor allows custom FFT size', () {
      final customProcessor = FFTVisualizationProcessor(fftSize: 512);
      expect(customProcessor, isNotNull);
    });

    test('processSamples returns 8 frequency bands', () {
      final samples = Float32List(256);
      for (var i = 0; i < samples.length; i++) {
        samples[i] = 0.5;
      }

      final bands = processor.processSamples(samples);

      expect(bands.length, 8);
    });
  });

  group('FFTVisualizationProcessor static methods', () {
    test('generateSimulatedSamples creates valid samples', () {
      final samples = FFTVisualizationProcessor.generateSimulatedSamples(
        sampleCount: 256,
        baseFrequency: 440.0,
      );

      expect(samples.length, 256);
      expect(samples.every((s) => s >= -1.0 && s <= 1.0), true);
    });

    test('normalizeBands converts dB values to 0-1 range', () {
      final bands = [-60.0, -30.0, 0.0];
      final normalized = FFTVisualizationProcessor.normalizeBands(bands);

      expect(normalized.length, 3);
      expect(normalized[0], closeTo(0.0, 0.01)); // -60dB -> 0.0
      expect(normalized[2], closeTo(1.0, 0.01)); // 0dB -> 1.0
    });

    test('normalizeBands clamps values outside range', () {
      final bands = [-80.0, 10.0]; // Outside minDb/maxDb
      final normalized = FFTVisualizationProcessor.normalizeBands(bands);

      expect(normalized[0], 0.0); // Clamped to min
      expect(normalized[1], 1.0); // Clamped to max
    });
  });
}
