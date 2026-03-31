import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final Logger _log = Logger('AudioService');

  final SoLoud _soloud;
  final AudioSession? _injectedAudioSession;

  AudioService({SoLoud? soloud, AudioSession? audioSession})
    : _soloud = soloud ?? SoLoud.instance,
      _injectedAudioSession = audioSession;

  AudioSource? _leftSource;
  AudioSource? _rightSource;
  AudioSource? _noiseSource;

  SoundHandle? _leftHandle;
  SoundHandle? _rightHandle;
  SoundHandle? _noiseHandle;

  bool get isInitialized => _soloud.isInitialized;

  Future<void> init() async {
    try {
      await _soloud.init();
      _log.info('SoLoud initialized');

      final session = _injectedAudioSession ?? await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.mixWithOthers,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.music,
            usage: AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType:
              AndroidAudioFocusGainType.gainTransientMayDuck,
        ),
      );

      _log.info('AudioSession configured for mixing');
    } catch (e) {
      _log.severe('Failed to initialize AudioService: $e');
    }
  }

  Future<void> startBinaural({
    required double leftFreq,
    required double rightFreq,
    double volume = 0.5,
  }) async {
    // Stop existing sounds if any
    await stop();

    // Create waveform sources
    _leftSource = await _soloud.loadWaveform(WaveForm.sin, false, 1.0, 0.0);
    if (_leftSource != null) {
      _soloud.setWaveformFreq(_leftSource!, leftFreq);
    }

    _rightSource = await _soloud.loadWaveform(WaveForm.sin, false, 1.0, 0.0);
    if (_rightSource != null) {
      _soloud.setWaveformFreq(_rightSource!, rightFreq);
    }

    if (_leftSource != null && _rightSource != null) {
      // Activate session before playing
      final session = _injectedAudioSession ?? await AudioSession.instance;
      if (await session.setActive(true)) {
        // Play sounds with looping enabled for gapless playback (AU-007)
        _leftHandle = await _soloud.play(_leftSource!, looping: true);
        _rightHandle = await _soloud.play(_rightSource!, looping: true);

        if (_leftHandle != null && _rightHandle != null) {
          // Pan hard left/right
          _soloud.setPan(_leftHandle!, -1.0);
          _soloud.setPan(_rightHandle!, 1.0);

          // Set volume
          _soloud.setVolume(_leftHandle!, volume);
          _soloud.setVolume(_rightHandle!, volume);

          // Store initial frequencies for relative speed calculations
          _leftBaseFreq = leftFreq;
          _rightBaseFreq = rightFreq;

          _log.info('Started binaural: $leftFreq Hz (L) / $rightFreq Hz (R)');
        }
      } else {
        _log.warning('Could not activate AudioSession');
      }
    }
  }

  double _leftBaseFreq = 200.0;
  double _rightBaseFreq = 210.0;

  void updateFrequencies(double leftFreq, double rightFreq) {
    if (_leftHandle != null && _rightHandle != null) {
      // Use relative play speed based on the actual base frequency, not 440Hz
      if (_leftBaseFreq > 0 && _rightBaseFreq > 0) {
        _soloud.setRelativePlaySpeed(_leftHandle!, leftFreq / _leftBaseFreq);
        _soloud.setRelativePlaySpeed(_rightHandle!, rightFreq / _rightBaseFreq);
      }
    }
  }

  Future<void> startBackgroundNoise(
    Uint8List wavData, {
    double volume = 0.2,
  }) async {
    // Guard against uninitialized SoLoud
    if (!_soloud.isInitialized) {
      _log.warning('SoLoud not initialized yet, skipping background noise');
      return;
    }
    if (_noiseHandle != null) {
      await _soloud.stop(_noiseHandle!);
      _noiseHandle = null;
    }
    if (_noiseSource != null) {
      await _soloud.disposeSource(_noiseSource!);
      _noiseSource = null;
    }

    _noiseSource = await _soloud.loadMem('background_noise.wav', wavData);
    if (_noiseSource != null) {
      _noiseHandle = await _soloud.play(
        _noiseSource!,
        volume: volume,
        looping: true,
      );
      _log.info('Started background noise');
    }
  }

  void setBackgroundVolume(double volume) {
    if (_noiseHandle != null) {
      _soloud.setVolume(_noiseHandle!, volume);
    }
  }

  Future<void> stop() async {
    if (_leftHandle != null) {
      await _soloud.stop(_leftHandle!);
      _leftHandle = null;
    }
    if (_rightHandle != null) {
      await _soloud.stop(_rightHandle!);
      _rightHandle = null;
    }
    if (_noiseHandle != null) {
      await _soloud.stop(_noiseHandle!);
      _noiseHandle = null;
    }

    if (_leftSource != null) {
      await _soloud.disposeSource(_leftSource!);
      _leftSource = null;
    }
    if (_rightSource != null) {
      await _soloud.disposeSource(_rightSource!);
      _rightSource = null;
    }
    if (_noiseSource != null) {
      await _soloud.disposeSource(_noiseSource!);
      _noiseSource = null;
    }

    _log.info('Stopped audio engine');
    final session = _injectedAudioSession ?? await AudioSession.instance;
    await session.setActive(false);
  }

  void setVolume(double volume) {
    if (_leftHandle != null) {
      _soloud.setVolume(_leftHandle!, volume);
    }
    if (_rightHandle != null) {
      _soloud.setVolume(_rightHandle!, volume);
    }
  }

  void dispose() {
    _soloud.deinit();
  }
}
