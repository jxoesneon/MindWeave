import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'audio_service.dart';
import 'audio_service_provider.dart';
import 'audio_state.dart';
import 'binaural_calculator.dart';
import 'notification_service.dart';
import '../models/brainwave_preset.dart';
import '../models/user_preset.dart';
import '../../core/services/session_history_service.dart';
import '../../core/services/analytics_service.dart';
import '../../features/health/health_controller.dart';

part 'audio_controller.g.dart';

@riverpod
class AudioController extends _$AudioController {
  late final AudioService _audioService;
  late final SessionHistoryService _sessionHistoryService;
  late final AudioNotificationService _notificationService;
  late final AnalyticsService _analyticsService;

  final _calculator = BinauralFrequencyCalculator();
  Timer? _timer;
  double _initialVolume = 0.5;
  String? _currentSessionId;
  DateTime? _sessionStartTime;

  @override
  AudioState build() {
    _audioService = ref.read(audioServiceProvider);
    _sessionHistoryService = ref.read(sessionHistoryServiceProvider);
    _notificationService = ref.read(audioNotificationServiceProvider);
    _analyticsService = ref.read(analyticsServiceProvider);

    _initialVolume = 0.5;

    // Initialize services with error handling - don't crash if they fail
    _initServices();

    // Wire notification callbacks
    _notificationService.onPlay = () => togglePlay();
    _notificationService.onPause = () => togglePlay();
    _notificationService.onStop = () {
      if (state.isPlaying) _stop();
    };

    ref.onDispose(() {
      _timer?.cancel();
      _notificationService.dispose();
    });

    return const AudioState(
      isPlaying: false,
      carrierFrequency: 200.0,
      beatFrequency: 10.0,
      volume: 0.5,
    );
  }

  Future<void> _initServices() async {
    try {
      await _audioService.init();
    } catch (e) {
      debugPrint('AudioService initialization failed: $e');
    }

    try {
      await _sessionHistoryService.initialize();
    } catch (e) {
      debugPrint('SessionHistoryService initialization failed: $e');
    }

    try {
      await _notificationService.initialize();
    } catch (e) {
      debugPrint('NotificationService initialization failed: $e');
    }
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
    _sessionStartTime = DateTime.now();

    // Start session tracking if we have a preset
    if (state.selectedPreset != null) {
      _currentSessionId = await _sessionHistoryService.startSession(
        preset: state.selectedPreset!,
        beatFrequency: state.beatFrequency,
        carrierFrequency: state.carrierFrequency,
        volume: state.volume,
        targetDuration: state.timerDuration ?? Duration.zero,
      );
    }

    // Track session start analytics
    _analyticsService.trackSessionStart(
      presetId: state.selectedPreset?.id ?? 'custom',
      band: state.selectedPreset?.band.name ?? 'unknown',
      beatFrequency: state.beatFrequency,
      carrierFrequency: state.carrierFrequency,
    );

    // Fade-in: start at 0 volume and ramp up over 3 seconds
    _audioService.setVolume(0.0);
    await _play();
    state = state.copyWith(isPlaying: true);
    _fadeIn();

    // Show playback notification
    final presetName = state.selectedPreset?.name ?? 'Custom Session';
    _notificationService.showPlaybackNotification(
      presetName: presetName,
      beatFrequency: state.beatFrequency,
      isPlaying: true,
    );

    // Start countdown if timer is set
    if (state.remainingTime != null && state.remainingTime! > Duration.zero) {
      _startCountdown();
    }
  }

  void _fadeIn() {
    const fadeSteps = 30; // 30 steps over ~3 seconds
    const stepDuration = Duration(milliseconds: 100);
    var step = 0;

    Timer.periodic(stepDuration, (timer) {
      step++;
      final progress = step / fadeSteps;
      final fadedVolume = _initialVolume * progress;
      _audioService.setVolume(fadedVolume.clamp(0.0, _initialVolume));

      if (step >= fadeSteps) {
        timer.cancel();
        _audioService.setVolume(_initialVolume);
      }
    });
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

    // Hide notification
    _notificationService.hideNotification();

    // Complete session tracking
    if (_currentSessionId != null && _sessionStartTime != null) {
      final duration = DateTime.now().difference(_sessionStartTime!);

      // Complete session in history
      await _sessionHistoryService.completeSession(
        sessionId: _currentSessionId!,
        actualDuration: duration,
      );

      // Log to HealthKit (mindful minutes)
      try {
        final healthController = ref.read(healthControllerProvider.notifier);
        await healthController.logSession(
          startTime: _sessionStartTime!,
          duration: duration,
          presetName: state.selectedPreset?.name,
          beatFrequency: state.beatFrequency,
        );
      } catch (e) {
        // HealthKit logging is optional, don't fail if it doesn't work
        debugPrint('HealthKit logging failed: $e');
      }

      // Track session stop analytics
      _analyticsService.trackSessionStop(
        presetId: state.selectedPreset?.id ?? 'custom',
        durationSeconds: duration.inSeconds,
        completed: (state.remainingTime?.inSeconds ?? 1) <= 0,
      );

      _currentSessionId = null;
      _sessionStartTime = null;
    }
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

  void updateBeatFrequency(double freq) {
    state = state.copyWith(beatFrequency: freq);
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

  /// Navigate to the next preset in the list
  void nextPreset() {
    final presets = BrainwavePreset.allPresets;
    if (presets.isEmpty) return;

    final currentIndex = presets.indexWhere(
      (p) => p.id == state.selectedPreset?.id,
    );
    final nextIndex = currentIndex == -1
        ? 0
        : (currentIndex + 1) % presets.length;

    final next = presets[nextIndex];
    selectPreset(next);
  }

  /// Navigate to the previous preset in the list
  void previousPreset() {
    final presets = BrainwavePreset.allPresets;
    if (presets.isEmpty) return;

    final currentIndex = presets.indexWhere(
      (p) => p.id == state.selectedPreset?.id,
    );
    final prevIndex = currentIndex == -1
        ? presets.length - 1
        : (currentIndex - 1 + presets.length) % presets.length;

    final prev = presets[prevIndex];
    selectPreset(prev);
  }
}
