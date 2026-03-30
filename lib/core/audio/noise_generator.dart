import 'dart:math';
import 'dart:typed_data';

class NoiseGenerator {
  static const int sampleRate = 44100;
  static const int bitsPerSample = 16;
  static const int channels = 1;

  static Uint8List generateWhiteNoise(Duration duration) {
    final int numSamples = (sampleRate * duration.inMilliseconds) ~/ 1000;
    final Int16List samples = Int16List(numSamples);
    final Random random = Random();

    for (int i = 0; i < numSamples; i++) {
      // Random value between -32768 and 32767
      samples[i] = random.nextInt(65536) - 32768;
    }

    return _addWavHeader(samples.buffer.asUint8List());
  }

  static Uint8List generatePinkNoise(Duration duration) {
    // Voss-McCartney algorithm for pink noise
    final int numSamples = (sampleRate * duration.inMilliseconds) ~/ 1000;
    final Int16List samples = Int16List(numSamples);
    final Random random = Random();

    const int numRows = 12;
    final List<double> rows = List.filled(numRows, 0.0);
    double runningSum = 0.0;

    for (int i = 0; i < numSamples; i++) {
      int prevIndices = i;
      int nextIndices = i + 1;
      int changed = prevIndices ^ nextIndices;

      for (int j = 0; j < numRows; j++) {
        if ((changed & (1 << j)) != 0) {
          runningSum -= rows[j];
          rows[j] = random.nextDouble() * 2.0 - 1.0;
          runningSum += rows[j];
        }
      }

      double pinkValue =
          (runningSum + random.nextDouble() * 2.0 - 1.0) / (numRows + 1);
      samples[i] = (pinkValue * 32767).toInt().clamp(-32768, 32767);
    }

    return _addWavHeader(samples.buffer.asUint8List());
  }

  static Uint8List _addWavHeader(Uint8List pcmData) {
    final int dataSize = pcmData.length;
    final int fileSize = 36 + dataSize;
    final int byteRate = (sampleRate * channels * bitsPerSample) ~/ 8;
    final int blockAlign = (channels * bitsPerSample) ~/ 8;

    final ByteData header = ByteData(44);

    // RIFF
    header.setUint8(0, 0x52); // R
    header.setUint8(1, 0x49); // I
    header.setUint8(2, 0x46); // F
    header.setUint8(3, 0x46); // F
    header.setUint32(4, fileSize, Endian.little);

    // WAVE
    header.setUint8(8, 0x57); // W
    header.setUint8(9, 0x41); // A
    header.setUint8(10, 0x56); // V
    header.setUint8(11, 0x45); // E

    // fmt
    header.setUint8(12, 0x66); // f
    header.setUint8(13, 0x6d); // m
    header.setUint8(14, 0x74); // t
    header.setUint8(15, 0x20); // ' '
    header.setUint32(16, 16, Endian.little); // Subchunk1Size
    header.setUint16(20, 1, Endian.little); // AudioFormat (PCM)
    header.setUint16(22, channels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, bitsPerSample, Endian.little);

    // data
    header.setUint8(36, 0x64); // d
    header.setUint8(37, 0x61); // a
    header.setUint8(38, 0x74); // t
    header.setUint8(39, 0x61); // a
    header.setUint32(40, dataSize, Endian.little);

    final Uint8List fullWav = Uint8List(44 + dataSize);
    fullWav.setRange(0, 44, header.buffer.asUint8List());
    fullWav.setRange(44, 44 + dataSize, pcmData);

    return fullWav;
  }
}
