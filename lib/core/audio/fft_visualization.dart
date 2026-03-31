import 'dart:math';
import 'dart:typed_data';

/// FFT (Fast Fourier Transform) audio visualization processor.
///
/// Performs real-time frequency analysis on audio samples to generate
/// visualization data for the audio visualizer widget.
///
/// Uses the Cooley-Tukey FFT algorithm for efficient computation.
class FFTVisualizationProcessor {
  static const int defaultFFTSize = 256;
  static const int numFrequencyBands = 8;

  final int fftSize;
  final List<double> _window;
  final List<double> _real;
  final List<double> _imag;

  FFTVisualizationProcessor({this.fftSize = defaultFFTSize})
    : _window = _generateHannWindow(fftSize),
      _real = List<double>.filled(fftSize, 0.0),
      _imag = List<double>.filled(fftSize, 0.0);

  /// Process audio samples and return frequency band magnitudes.
  ///
  /// Returns a list of 8 frequency band magnitudes (logarithmic scale):
  /// - Band 0: Sub-bass (20-60 Hz)
  /// - Band 1: Bass (60-250 Hz)
  /// - Band 2: Low-mids (250-500 Hz)
  /// - Band 3: Mids (500-2000 Hz)
  /// - Band 4: High-mids (2000-4000 Hz)
  /// - Band 5: Presence (4000-6000 Hz)
  /// - Band 6: Brilliance (6000-10000 Hz)
  /// - Band 7: Air (10000-20000 Hz)
  List<double> processSamples(Float32List samples) {
    // Apply window function and copy to real buffer
    final int copyLength = samples.length < fftSize ? samples.length : fftSize;
    for (var i = 0; i < fftSize; i++) {
      if (i < copyLength) {
        _real[i] = samples[i] * _window[i];
      } else {
        _real[i] = 0.0;
      }
      _imag[i] = 0.0;
    }

    // Perform FFT
    _fft(_real, _imag);

    // Calculate magnitude for each frequency bin
    final magnitudes = List<double>.filled(fftSize ~/ 2, 0.0);
    for (var i = 0; i < fftSize ~/ 2; i++) {
      magnitudes[i] = sqrt(_real[i] * _real[i] + _imag[i] * _imag[i]);
    }

    // Group into frequency bands
    return _groupIntoBands(magnitudes);
  }

  /// Group FFT bins into 8 frequency bands.
  List<double> _groupIntoBands(List<double> magnitudes) {
    final bands = List<double>.filled(numFrequencyBands, 0.0);
    final binsPerBand = magnitudes.length ~/ numFrequencyBands;

    for (var band = 0; band < numFrequencyBands; band++) {
      double sum = 0.0;
      final startBin = band * binsPerBand;
      final endBin = (band + 1) * binsPerBand;

      for (var bin = startBin; bin < endBin && bin < magnitudes.length; bin++) {
        sum += magnitudes[bin];
      }

      // Average and apply logarithmic scaling for better visualization
      bands[band] = _logScale(sum / binsPerBand);
    }

    return bands;
  }

  /// Apply logarithmic scaling to magnitude values.
  double _logScale(double magnitude) {
    // Avoid log(0)
    if (magnitude < 1e-10) return 0.0;
    return 20 * log(magnitude) / ln10; // Convert to dB
  }

  /// Perform in-place FFT using Cooley-Tukey algorithm.
  void _fft(List<double> real, List<double> imag) {
    final n = real.length;
    if (n <= 1) return;

    // Bit-reversal permutation
    var j = 0;
    for (var i = 0; i < n; i++) {
      if (i < j) {
        // Swap real values
        var temp = real[i];
        real[i] = real[j];
        real[j] = temp;
        // Swap imaginary values
        temp = imag[i];
        imag[i] = imag[j];
        imag[j] = temp;
      }

      var bit = n >> 1;
      while (j & bit != 0) {
        j &= ~bit;
        bit >>= 1;
      }
      j |= bit;
    }

    // Danielson-Lanczos section
    for (var len = 2; len <= n; len <<= 1) {
      final angle = -2 * pi / len;
      final wReal = cos(angle);
      final wImag = sin(angle);

      for (var i = 0; i < n; i += len) {
        var uReal = 1.0;
        var uImag = 0.0;

        for (var j = 0; j < len ~/ 2; j++) {
          final evenIndex = i + j;
          final oddIndex = i + j + len ~/ 2;

          final evenReal = real[evenIndex];
          final evenImag = imag[evenIndex];
          final oddReal = real[oddIndex] * uReal - imag[oddIndex] * uImag;
          final oddImag = real[oddIndex] * uImag + imag[oddIndex] * uReal;

          real[evenIndex] = evenReal + oddReal;
          imag[evenIndex] = evenImag + oddImag;
          real[oddIndex] = evenReal - oddReal;
          imag[oddIndex] = evenImag - oddImag;

          final nextReal = uReal * wReal - uImag * wImag;
          uImag = uReal * wImag + uImag * wReal;
          uReal = nextReal;
        }
      }
    }
  }

  /// Generate Hann window for reducing spectral leakage.
  static List<double> _generateHannWindow(int size) {
    return List<double>.generate(
      size,
      (i) => 0.5 * (1 - cos(2 * pi * i / (size - 1))),
    );
  }

  /// Generate simulated audio samples for testing/demo.
  static Float32List generateSimulatedSamples({
    int sampleCount = 256,
    double baseFrequency = 440.0,
    int sampleRate = 44100,
  }) {
    final samples = Float32List(sampleCount);
    for (var i = 0; i < sampleCount; i++) {
      final t = i / sampleRate;
      // Mix of sine waves to simulate complex audio
      samples[i] =
          (sin(2 * pi * baseFrequency * t) * 0.5 +
          sin(2 * pi * baseFrequency * 2 * t) * 0.3 +
          sin(2 * pi * baseFrequency * 0.5 * t) * 0.2);
    }
    return samples;
  }

  /// Normalize band values to 0.0-1.0 range for visualization.
  static List<double> normalizeBands(
    List<double> bands, {
    double minDb = -60.0,
    double maxDb = 0.0,
  }) {
    return bands.map((value) {
      // Clamp to range
      var clamped = value.clamp(minDb, maxDb);
      // Normalize to 0-1
      return (clamped - minDb) / (maxDb - minDb);
    }).toList();
  }
}
