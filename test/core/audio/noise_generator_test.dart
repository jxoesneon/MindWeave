import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/audio/noise_generator.dart';
import 'dart:typed_data';

void main() {
  group('NoiseGenerator Tests', () {
    test('generateWhiteNoise creates a valid WAV file', () {
      final duration = const Duration(seconds: 1);
      final result = NoiseGenerator.generateWhiteNoise(duration);
      
      // WAV Header is 44 bytes
      // 44100 samples * 16 bits (2 bytes) = 88200 bytes
      // Total: 88244 bytes
      expect(result.length, 88244);
      
      // Check RIFF header
      expect(result[0], 0x52); // R
      expect(result[1], 0x49); // I
      expect(result[2], 0x46); // F
      expect(result[3], 0x46); // F
      
      // Check WAVE marker
      expect(result[8], 0x57); // W
      expect(result[9], 0x41); // A
      expect(result[10], 0x56); // V
      expect(result[11], 0x45); // E
    });

    test('generatePinkNoise creates a valid WAV file', () {
      final duration = const Duration(seconds: 1);
      final result = NoiseGenerator.generatePinkNoise(duration);
      
      expect(result.length, 88244);
      
      // Check fmt marker
      expect(result[12], 0x66); // f
      expect(result[13], 0x6d); // m
      expect(result[14], 0x74); // t
      
      // Check PCM format (1) at offset 20
      final byteData = ByteData.view(result.buffer);
      expect(byteData.getUint16(20, Endian.little), 1);
      
      // Check Sample Rate (44100) at offset 24
      expect(byteData.getUint32(24, Endian.little), 44100);
    });

    test('generateWhiteNoise produces non-zero data', () {
      final duration = const Duration(milliseconds: 100);
      final result = NoiseGenerator.generateWhiteNoise(duration);
      
      // Skip header and check if there's any variation
      final pcmData = result.sublist(44);
      final hasNonZero = pcmData.any((byte) => byte != 0);
      expect(hasNonZero, true);
    });
  });
}
