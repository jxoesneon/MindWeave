import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audio_service/audio_service.dart';

part 'notification_service.g.dart';

/// Service for managing background playback notifications and media controls.
///
/// Provides:
/// - Background audio playback notification
/// - Play/Pause/Stop controls in notification
/// - Integration with Control Center (iOS) and Media Session (Android)
class AudioNotificationService {
  final FlutterLocalNotificationsPlugin _notifications;

  static const String _channelId = 'mindweave_audio_channel';
  static const String _channelName = 'Audio Playback';
  static const String _channelDescription =
      'Controls for binaural beats playback';

  bool _isInitialized = false;
  String? _currentPresetName;
  double _currentBeatFrequency = 10.0;
  bool _isPlaying = false;

  // Callbacks for control actions
  VoidCallback? onPlay;
  VoidCallback? onPause;
  VoidCallback? onStop;

  AudioNotificationService({FlutterLocalNotificationsPlugin? notifications})
    : _notifications = notifications ?? FlutterLocalNotificationsPlugin();

  /// Initialize the notification service.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
      );
      const windowsSettings = WindowsInitializationSettings(
        appName: 'MindWeave',
        appUserModelId: 'com.mindweave.app',
        guid: 'a8c22b55-9f00-4c3b-9a2f-1234567890ab',
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
        windows: windowsSettings,
      );

      await _notifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );

      // Create Android notification channel
      const androidChannel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
        showBadge: false,
      );

      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(androidChannel);

      _isInitialized = true;
      debugPrint('AudioNotificationService initialized');
    } catch (e) {
      debugPrint('AudioNotificationService initialization failed: $e');
      // Don't crash - notifications are not critical
    }
  }

  /// Show playback notification with current session info.
  Future<void> showPlaybackNotification({
    required String presetName,
    required double beatFrequency,
    required bool isPlaying,
  }) async {
    if (!_isInitialized) await initialize();

    _currentPresetName = presetName;
    _currentBeatFrequency = beatFrequency;
    _isPlaying = isPlaying;

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      playSound: false,
      enableVibration: false,
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.transport,
      actions: [
        if (isPlaying)
          const AndroidNotificationAction(
            'pause',
            'Pause',
            showsUserInterface: false,
          )
        else
          const AndroidNotificationAction(
            'play',
            'Play',
            showsUserInterface: false,
          ),
        const AndroidNotificationAction(
          'stop',
          'Stop',
          showsUserInterface: false,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _notifications.show(
      id: 1, // notification id
      title: presetName,
      body: '${beatFrequency.toStringAsFixed(1)} Hz Binaural Beats',
      notificationDetails: details,
      payload: 'playback_controls',
    );
  }

  /// Update notification when playback state changes.
  Future<void> updatePlaybackState({
    String? presetName,
    double? beatFrequency,
    bool? isPlaying,
  }) async {
    if (presetName != null) _currentPresetName = presetName;
    if (beatFrequency != null) _currentBeatFrequency = beatFrequency;
    if (isPlaying != null) _isPlaying = isPlaying;

    if (_currentPresetName != null) {
      await showPlaybackNotification(
        presetName: _currentPresetName!,
        beatFrequency: _currentBeatFrequency,
        isPlaying: _isPlaying,
      );
    }
  }

  /// Cancel the playback notification.
  Future<void> hideNotification() async {
    await _notifications.cancel(id: 1);
  }

  /// Handle notification action responses.
  void _onNotificationResponse(NotificationResponse response) {
    debugPrint('Notification action: ${response.actionId}');

    switch (response.actionId) {
      case 'play':
        onPlay?.call();
        break;
      case 'pause':
        onPause?.call();
        break;
      case 'stop':
        onStop?.call();
        break;
    }
  }

  /// Dispose resources.
  Future<void> dispose() async {
    await hideNotification();
  }
}

/// Extension to integrate with AudioService for background playback.
///
/// This class implements the AudioHandler interface for proper
/// integration with Control Center (iOS) and Media Session (Android).
class MindWeaveAudioHandler extends BaseAudioHandler {
  VoidCallback? onPlay;
  VoidCallback? onPause;
  VoidCallback? onStop;

  MindWeaveAudioHandler() {
    // Set up initial playback state
    playbackState.add(PlaybackState());
  }

  /// Update media item information.
  void setMediaItem({
    required String title,
    required String artist,
    Duration? duration,
  }) {
    mediaItem.add(
      MediaItem(
        id: 'mindweave_session',
        title: title,
        artist: artist,
        duration: duration,
        artUri: null,
        playable: true,
      ),
    );
  }

  /// Update playback state.
  void setPlaybackState({
    required bool isPlaying,
    required Duration position,
    Duration? bufferedPosition,
    double speed = 1.0,
  }) {
    playbackState.add(
      PlaybackState(
        playing: isPlaying,
        updatePosition: position,
        bufferedPosition: bufferedPosition ?? position,
        speed: speed,
        controls: [
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: {MediaAction.play, MediaAction.pause, MediaAction.stop},
      ),
    );
  }

  @override
  Future<void> play() async {
    onPlay?.call();
  }

  @override
  Future<void> pause() async {
    onPause?.call();
  }

  @override
  Future<void> stop() async {
    onStop?.call();
    await super.stop();
  }
}
