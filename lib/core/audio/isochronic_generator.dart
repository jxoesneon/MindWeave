import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Isochronic tone generator for alternative brainwave entrainment.
///
/// Unlike binaural beats which require headphones, isochronic tones
/// work by modulating a single tone's amplitude at the target frequency.
/// This makes them effective even without headphones.
///
/// Mathematical foundation:
/// - Base frequency: carrier tone (e.g., 200 Hz)
/// - Beat frequency: target brainwave frequency (e.g., 10 Hz alpha)
/// - Modulation: amplitude varies at beat frequency (0 to max)
/// - Duty cycle: typically 50% on, 50% off for cleaner entrainment
///
/// Implementation uses SoLoud's waveshaper for amplitude modulation.
class IsochronicToneGenerator {
  final SoLoud _soloud = SoLoud.instance;

  // Default parameters
  static const double defaultCarrierFrequency = 200.0;
  static const double defaultBeatFrequency = 10.0;
  static const double defaultVolume = 0.5;
  static const double defaultDutyCycle = 0.5; // 50% on, 50% off

  AudioSource? _currentSource;
  SoundHandle? _currentHandle;
  bool _isPlaying = false;

  double _carrierFrequency = defaultCarrierFrequency;
  double _beatFrequency = defaultBeatFrequency;
  double _volume = defaultVolume;
  double _dutyCycle = defaultDutyCycle;

  // Getters
  bool get isPlaying => _isPlaying;
  double get carrierFrequency => _carrierFrequency;
  double get beatFrequency => _beatFrequency;
  double get volume => _volume;

  /// Generate isochronic tone parameters for a given carrier and beat frequency.
  ///
  /// Returns a map with the parameters needed for amplitude modulation.
  Map<String, dynamic> calculateIsochronicParams({
    required double carrierFreq,
    required double beatFreq,
    double dutyCycle = defaultDutyCycle,
  }) {
    // Validate inputs
    final clampedCarrier = carrierFreq.clamp(100.0, 1000.0);
    final clampedBeat = beatFreq.clamp(0.5, 100.0);
    final clampedDuty = dutyCycle.clamp(0.1, 0.9);

    // Calculate modulation parameters
    final periodMs = 1000.0 / clampedBeat; // Period in milliseconds
    final onTimeMs = periodMs * clampedDuty;
    final offTimeMs = periodMs * (1.0 - clampedDuty);

    return {
      'carrierFrequency': clampedCarrier,
      'beatFrequency': clampedBeat,
      'dutyCycle': clampedDuty,
      'periodMs': periodMs,
      'onTimeMs': onTimeMs,
      'offTimeMs': offTimeMs,
    };
  }

  /// Start playing isochronic tones.
  ///
  /// Creates a waveform that alternates between full volume and silence
  /// at the target beat frequency.
  Future<bool> start({
    double? carrierFrequency,
    double? beatFrequency,
    double? volume,
    double? dutyCycle,
  }) async {
    try {
      // Stop any existing playback
      await stop();

      // Update parameters
      _carrierFrequency = carrierFrequency ?? _carrierFrequency;
      _beatFrequency = beatFrequency ?? _beatFrequency;
      _volume = volume ?? _volume;
      _dutyCycle = dutyCycle ?? _dutyCycle;

      // Calculate parameters
      final params = calculateIsochronicParams(
        carrierFreq: _carrierFrequency,
        beatFreq: _beatFrequency,
        dutyCycle: _dutyCycle,
      );

      // Create the base tone using a sine wave
      // We'll use pulse waves for the isochronic effect
      _currentSource = await _createIsochronicSource(params);

      if (_currentSource == null) {
        return false;
      }

      // Play the tone
      _currentHandle = await _soloud.play(
        _currentSource!,
        volume: _volume,
        looping: true,
        pan: 0.0, // Mono - isochronic tones don't need stereo separation
      );

      _isPlaying = true;
      return true;
    } catch (e) {
      debugPrint('Error starting isochronic tone: $e');
      return false;
    }
  }

  /// Create an audio source for isochronic tones.
  ///
  /// Uses a pulse wave that creates the characteristic
  /// on/off pattern of isochronic tones.
  Future<AudioSource?> _createIsochronicSource(
    Map<String, dynamic> params,
  ) async {
    try {
      final carrierFreq = params['carrierFrequency'] as double;
      final beatFreq = params['beatFrequency'] as double;
      final dutyCycle = params['dutyCycle'] as double;

      // For isochronic tones, we use a square/pulse wave
      // The "beat" is created by the pulse width (duty cycle)
      // The pulse frequency is the beat frequency
      // The base frequency of the pulse is the carrier

      // Use SoLoud's pulse wave with frequency modulation
      // We need to create a custom waveform that pulses at the beat frequency

      // Alternative approach: Use a sine wave and apply amplitude modulation
      // via the volume parameter in a timer loop

      // For now, use a simple approach with periodic volume modulation
      // This creates the isochronic effect by rapidly changing volume

      final source = await _soloud.loadMem(
        'isochronic_tone',
        _generateIsochronicWaveform(
          carrierFreq: carrierFreq,
          beatFreq: beatFreq,
          dutyCycle: dutyCycle,
        ),
      );

      return source;
    } catch (e) {
      debugPrint('Error creating isochronic source: $e');
      return null;
    }
  }

  /// Generate PCM data for isochronic tone.
  ///
  /// Creates a buffer with the carrier tone modulated at the beat frequency.
  Uint8List _generateIsochronicWaveform({
    required double carrierFreq,
    required double beatFreq,
    required double dutyCycle,
    int sampleRate = 44100,
    double durationSeconds = 1.0,
  }) {
    final totalSamples = (sampleRate * durationSeconds).toInt();
    final bytes = BytesBuilder();

    final carrierPeriod = sampleRate / carrierFreq;
    final beatPeriod = sampleRate / beatFreq;
    final onSamples = (beatPeriod * dutyCycle).toInt();

    for (var i = 0; i < totalSamples; i++) {
      final beatPhase = i % beatPeriod.toInt();
      final isOn = beatPhase < onSamples;

      double sample;
      if (isOn) {
        // Generate carrier sine wave during "on" phase
        final carrierPhase =
            2 * pi * (i % carrierPeriod.toInt()) / carrierPeriod;
        sample = sin(carrierPhase);
      } else {
        // Silence during "off" phase
        sample = 0.0;
      }

      // Convert to 16-bit PCM
      final pcmValue = (sample * 32767).toInt().clamp(-32768, 32767);
      bytes.addByte(pcmValue & 0xFF);
      bytes.addByte((pcmValue >> 8) & 0xFF);
    }

    return bytes.toBytes();
  }

  /// Stop playing isochronic tones.
  Future<void> stop() async {
    try {
      if (_currentHandle != null) {
        await _soloud.stop(_currentHandle!);
        _currentHandle = null;
      }

      if (_currentSource != null) {
        await _soloud.disposeSource(_currentSource!);
        _currentSource = null;
      }

      _isPlaying = false;
    } catch (e) {
      debugPrint('Error stopping isochronic tone: $e');
    }
  }

  /// Update the carrier frequency in real-time.
  Future<void> updateCarrierFrequency(double frequency) async {
    _carrierFrequency = frequency.clamp(100.0, 1000.0);

    if (_isPlaying) {
      // Restart with new frequency
      await start();
    }
  }

  /// Update the beat frequency in real-time.
  Future<void> updateBeatFrequency(double frequency) async {
    _beatFrequency = frequency.clamp(0.5, 100.0);

    if (_isPlaying) {
      // Restart with new frequency
      await start();
    }
  }

  /// Update the volume.
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);

    if (_currentHandle != null) {
      _soloud.setVolume(_currentHandle!, _volume);
    }
  }

  /// Dispose resources.
  Future<void> dispose() async {
    await stop();
  }
}
