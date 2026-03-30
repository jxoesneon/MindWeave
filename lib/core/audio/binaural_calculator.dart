/// Core mathematical logic for binaural beat generation.
///
/// The binaural beat is the perceived difference between two frequencies
/// presented independently to each ear.
class BinauralFrequencyCalculator {
  /// Calculates left and right channel frequencies.
  BinauralResult calculate({
    required double carrierFreq,
    required double beatFreq,
  }) {
    final halfBeat = beatFreq / 2;
    return BinauralResult(
      leftFreq: carrierFreq - halfBeat,
      rightFreq: carrierFreq + halfBeat,
    );
  }

  /// Calculates left and right channel frequencies (Static version).
  static (double, double) calculateFrequencies({
    required double beatFrequency,
    required double carrierFrequency,
  }) {
    // We center the carrier and offset by half the beat frequency
    final halfBeat = beatFrequency / 2;

    final leftFreq = carrierFrequency - halfBeat;
    final rightFreq = carrierFrequency + halfBeat;

    return (leftFreq, rightFreq);
  }

  /// Validates frequency parameters.
  static bool validateFrequencies({
    required double beatFrequency,
    required double carrierFrequency,
  }) {
    // Beat frequency must be within brainwave ranges
    if (beatFrequency < 0.5 || beatFrequency > 100) return false;

    // Carrier must be audible and within optimal range
    if (carrierFrequency < 100 || carrierFrequency > 1000) return false;

    // Resulting frequencies must be positive
    final (left, right) = calculateFrequencies(
      beatFrequency: beatFrequency,
      carrierFrequency: carrierFrequency,
    );

    return left > 0 && right > 0;
  }
}

/// Represents the calculated frequencies for binaural beats.
class BinauralResult {
  /// The frequency for the left channel.
  final double leftFreq;

  /// The frequency for the right channel.
  final double rightFreq;

  /// Creates a [BinauralResult] with given frequencies.
  BinauralResult({
    required this.leftFreq,
    required this.rightFreq,
  });
}
