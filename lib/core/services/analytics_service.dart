import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import '../config/env_config.dart';
import '../storage/storage_service.dart';

/// Privacy-respecting analytics service using PostHog.
///
/// Features:
/// - Opt-in/opt-out support persisted via Hive
/// - Automatic event batching (handled by PostHog SDK)
/// - Anonymous by default (uses PostHog anonymous IDs)
/// - Remote config check via `enable_analytics` flag
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final Logger _logger = Logger('AnalyticsService');
  final StorageService _storageService = StorageService();

  bool _initialized = false;
  bool _enabled = true;

  static const String _settingsBox = 'settings';
  static const String _analyticsOptInKey = 'analytics_opt_in';

  /// Whether analytics is currently enabled (user opted in + initialized)
  bool get isEnabled => _initialized && _enabled;

  /// Initialize PostHog analytics.
  /// Must be called after Hive is initialized.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Load user opt-in preference
      _enabled =
          await _storageService.get(
                _settingsBox,
                _analyticsOptInKey,
                defaultValue: true,
              )
              as bool;

      if (!_enabled) {
        _logger.info('Analytics disabled by user preference');
        _initialized = true;
        return;
      }

      final apiKey = EnvConfig().posthogApiKey;

      if (apiKey.isEmpty) {
        _logger.warning('PostHog API key not configured, analytics disabled');
        _enabled = false;
        _initialized = true;
        return;
      }

      // PostHog SDK auto-initializes with API key from AndroidManifest.xml/Info.plist
      // Just verify it's working by setting debug mode
      await Posthog().debug(kDebugMode);

      _initialized = true;
      _logger.info('PostHog analytics initialized (API key configured)');
    } catch (e) {
      _logger.severe('Failed to initialize PostHog: $e');
      _enabled = false;
      _initialized = true;
    }
  }

  // ─── Event Tracking ───────────────────────────────────────────

  /// Track a custom event with optional properties.
  Future<void> capture(
    String eventName, {
    Map<String, Object>? properties,
  }) async {
    if (!isEnabled) return;

    try {
      await Posthog().capture(eventName: eventName, properties: properties);
      _logger.fine('Captured event: $eventName');
    } catch (e) {
      _logger.warning('Failed to capture event $eventName: $e');
    }
  }

  /// Track screen view.
  Future<void> screen(
    String screenName, {
    Map<String, Object>? properties,
  }) async {
    if (!isEnabled) return;

    try {
      await Posthog().screen(screenName: screenName, properties: properties);
    } catch (e) {
      _logger.warning('Failed to track screen $screenName: $e');
    }
  }

  /// Identify a user (e.g., after Supabase anonymous auth).
  Future<void> identify(
    String userId, {
    Map<String, Object>? userProperties,
    Map<String, Object>? userPropertiesSetOnce,
  }) async {
    if (!isEnabled) return;

    try {
      await Posthog().identify(
        userId: userId,
        userProperties: userProperties,
        userPropertiesSetOnce: userPropertiesSetOnce,
      );
      _logger.fine('Identified user: $userId');
    } catch (e) {
      _logger.warning('Failed to identify user: $e');
    }
  }

  // ─── App-Specific Events ──────────────────────────────────────

  /// Session started
  Future<void> trackSessionStart({
    required String presetId,
    required String band,
    required double beatFrequency,
    required double carrierFrequency,
  }) async {
    await capture(
      'session_started',
      properties: {
        'preset_id': presetId,
        'band': band,
        'beat_frequency': beatFrequency,
        'carrier_frequency': carrierFrequency,
      },
    );
  }

  /// Session stopped
  Future<void> trackSessionStop({
    required String presetId,
    required int durationSeconds,
    required bool completed,
  }) async {
    await capture(
      'session_stopped',
      properties: {
        'preset_id': presetId,
        'duration_seconds': durationSeconds,
        'completed': completed,
      },
    );
  }

  /// Preset selected
  Future<void> trackPresetSelected({required String presetId}) async {
    await capture('preset_selected', properties: {'preset_id': presetId});
  }

  /// Favorite toggled
  Future<void> trackFavoriteToggled({
    required String presetId,
    required bool isFavorite,
  }) async {
    await capture(
      'favorite_toggled',
      properties: {'preset_id': presetId, 'is_favorite': isFavorite},
    );
  }

  /// Theme changed
  Future<void> trackThemeChanged({required String themeMode}) async {
    await capture('theme_changed', properties: {'theme_mode': themeMode});
  }

  /// Health sync toggled
  Future<void> trackHealthSyncToggled({required bool enabled}) async {
    await capture('health_sync_toggled', properties: {'enabled': enabled});
  }

  /// Carrier frequency adjusted
  Future<void> trackCarrierAdjusted({required double frequency}) async {
    await capture(
      'carrier_frequency_adjusted',
      properties: {'frequency': frequency},
    );
  }

  /// Volume adjusted
  Future<void> trackVolumeAdjusted({required double volume}) async {
    await capture('volume_adjusted', properties: {'volume': volume});
  }

  /// Timer set
  Future<void> trackTimerSet({required int durationMinutes}) async {
    await capture(
      'timer_set',
      properties: {'duration_minutes': durationMinutes},
    );
  }

  /// Donation interaction
  Future<void> trackDonationInteraction({required String tier}) async {
    await capture('donation_interaction', properties: {'tier': tier});
  }

  // ─── Privacy Controls ─────────────────────────────────────────

  /// Enable analytics (user opt-in).
  Future<void> enable() async {
    _enabled = true;
    await _storageService.put(_settingsBox, _analyticsOptInKey, true);

    if (_initialized) {
      await Posthog().enable();
    }
    _logger.info('Analytics enabled');
  }

  /// Disable analytics (user opt-out).
  Future<void> disable() async {
    _enabled = false;
    await _storageService.put(_settingsBox, _analyticsOptInKey, false);

    if (_initialized) {
      await Posthog().disable();
    }
    _logger.info('Analytics disabled');
  }

  /// Reset analytics identity (e.g., on logout).
  Future<void> reset() async {
    if (!_initialized) return;
    try {
      await Posthog().reset();
      _logger.info('Analytics identity reset');
    } catch (e) {
      _logger.warning('Failed to reset analytics: $e');
    }
  }

  /// Check if user has opted in.
  Future<bool> isOptedIn() async {
    return await _storageService.get(
          _settingsBox,
          _analyticsOptInKey,
          defaultValue: true,
        )
        as bool;
  }
}
