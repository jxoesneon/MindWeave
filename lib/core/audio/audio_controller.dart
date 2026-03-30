import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'audio_service.dart';
import 'audio_service_provider.dart';
import 'audio_state.dart';
import 'binaural_calculator.dart';
import '../models/brainwave_preset.dart';
import '../models/user_preset.dart';

part 'audio_controller.g.dart';

@riverpod
class AudioController extends _$AudioController {
  late final AudioService _audioService;
  final _calculator = BinauralFrequencyCalculator();
  Timer? _timer;
  double _initialVolume = 0.5;

  @override
  AudioState build() {
    _audioService = ref.read(audioServiceProvider);
    _initialVolume = 0.5;

    _audioService.init();

    ref.onDispose(() {
      _timer?.cancel();
    });

    return const AudioState(
      isPlaying: false,
      carrierFrequency: 200.0,
      beatFrequency: 10.0,
      volume: 0.5,
    );
  }

  void setTimer(Duration duration) {
    state = state.copyWith(timerDuration: duration, remainingTime: duration);
  }

  Future<void> selectPreset(BrainwavePreset preset) async {
    state = state.copyWith(
      selectedPreset: preset,
      carrierFrequency: preset.defaultCarrierFrequency,
      beatFrequency: preset.beatFrequency,
    );

    if (state.isPlaying) {
      await _play();
    }
  }

  Future<void> loadUserPreset(UserPreset preset) async {
    state = state.copyWith(
      carrierFrequency: preset.carrierFrequency,
      beatFrequency: preset.beatFrequency,
      // We don't set selectedPreset as it's a UserPreset, not a BrainwavePreset
      // but we could set it to null or a special value if needed.
      selectedPreset: null,
    );

    if (state.isPlaying) {
      await _play();
    }
  }

  Future<void> togglePlay() async {
    if (state.isPlaying) {
      await _stop();
    } else {
      await _start();
    }
  }

  Future<void> _start() async {
    _initialVolume = state.volume;
    await _play();
    state = state.copyWith(isPlaying: true);

    // Start countdown if timer is set
    if (state.remainingTime != null && state.remainingTime! > Duration.zero) {
      _startCountdown();
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    await _audioService.stop();
    state = state.copyWith(
      isPlaying: false,
      // Reset remaining time only if it hit zero
      remainingTime: (state.remainingTime?.inSeconds ?? 0) <= 0
          ? state.timerDuration
          : state.remainingTime,
    );
    // Reset volume to initial if it was faded
    _audioService.setVolume(_initialVolume);
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.remainingTime?.inSeconds ?? 0;

      if (remaining <= 0) {
        timer.cancel();
        _stop();
        return;
      }

      final newRemaining = Duration(seconds: remaining - 1);
      state = state.copyWith(remainingTime: newRemaining);

      // Handle Fade-out (last 30 seconds)
      if (newRemaining.inSeconds <= 30) {
        final fadeProgress = newRemaining.inSeconds / 30.0;
        final fadedVolume = _initialVolume * fadeProgress;
        _audioService.setVolume(fadedVolume);
      }
    });
  }

  Future<void> _play() async {
    // Ensure audio service is initialized before playing
    if (!_audioService.isInitialized) {
      await _audioService.init();
    }

    final result = _calculator.calculate(
      carrierFreq: state.carrierFrequency,
      beatFreq: state.beatFrequency,
    );

    await _audioService.startBinaural(
      leftFreq: result.leftFreq,
      rightFreq: result.rightFreq,
      volume: state.volume,
    );
  }

  void updateCarrierFreq(double freq) {
    state = state.copyWith(carrierFrequency: freq);
    if (state.isPlaying) {
      final result = _calculator.calculate(
        carrierFreq: state.carrierFrequency,
        beatFreq: state.beatFrequency,
      );
      _audioService.updateFrequencies(result.leftFreq, result.rightFreq);
    }
  }

  void updateVolume(double volume) {
    _initialVolume = volume;
    state = state.copyWith(volume: volume);
    if (state.isPlaying) {
      _audioService.setVolume(volume);
    }
  }
}
