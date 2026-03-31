import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final Logger _logger = Logger('RemoteConfigService');

  bool _isInitialized = false;
  Timer? _refreshTimer;

  // Feature flags
  bool get showDonationBanner =>
      _getBool('show_donation_banner', defaultValue: true);
  bool get enablePremiumFeatures =>
      _getBool('enable_premium_features', defaultValue: false);
  bool get showAds => _getBool('show_ads', defaultValue: false);
  bool get enableHealthIntegration =>
      _getBool('enable_health_integration', defaultValue: true);
  bool get enableMusicMixing =>
      _getBool('enable_music_mixing', defaultValue: true);
  bool get enableSessionHistory =>
      _getBool('enable_session_history', defaultValue: true);
  bool get enableCustomPresets =>
      _getBool('enable_custom_presets', defaultValue: false);
  bool get enableAnalytics => _getBool('enable_analytics', defaultValue: true);

  // App configuration
  int get maxFreeSessionsPerDay =>
      _getInt('max_free_sessions_per_day', defaultValue: 5);
  int get sessionDurationLimit =>
      _getInt('session_duration_limit', defaultValue: 60); // minutes
  double get donationGoalAmount =>
      _getDouble('donation_goal_amount', defaultValue: 500.0);
  String get currentVersion =>
      _getString('current_version', defaultValue: '1.0.0');
  String get minSupportedVersion =>
      _getString('min_supported_version', defaultValue: '1.0.0');

  // Content configuration
  List<String> get featuredPresetIds =>
      _getStringList('featured_preset_ids', defaultValue: []);
  String get motivationalQuote =>
      _getString('motivational_quote', defaultValue: '');
  String get updateMessage => _getString('update_message', defaultValue: '');

  // Monetization
  double get supporterPrice => _getDouble('supporter_price', defaultValue: 5.0);
  double get advocatePrice => _getDouble('advocate_price', defaultValue: 15.0);
  double get championPrice => _getDouble('champion_price', defaultValue: 25.0);
  List<String> get donationAmounts =>
      _getStringList('donation_amounts', defaultValue: ['3', '5', '10', '25']);

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase if not already done
      await Firebase.initializeApp();

      // Set default values
      await _setDefaults();

      // Configure Remote Config
      await _configureRemoteConfig();

      // Fetch and activate
      await _fetchAndActivate();

      // Start periodic refresh
      _startPeriodicRefresh();

      _isInitialized = true;
      _logger.info('RemoteConfig initialized successfully');
    } catch (e) {
      _logger.severe('Failed to initialize RemoteConfig: $e');
      // Continue with default values
      await _setDefaults();
      _isInitialized = true;
    }
  }

  Future<void> _setDefaults() async {
    await _remoteConfig.setDefaults({
      // Feature flags
      'show_donation_banner': true,
      'enable_premium_features': false,
      'show_ads': false,
      'enable_health_integration': true,
      'enable_music_mixing': true,
      'enable_session_history': true,
      'enable_custom_presets': false,
      'enable_analytics': true,

      // App configuration
      'max_free_sessions_per_day': 5,
      'session_duration_limit': 60,
      'donation_goal_amount': 500.0,
      'current_version': '1.0.0',
      'min_supported_version': '1.0.0',

      // Content configuration
      'featured_preset_ids': [
        'delta_deep_sleep',
        'theta_meditation',
        'alpha_relaxation'
      ],
      'motivational_quote':
          'Take a deep breath and begin your journey to inner peace.',
      'update_message': '',

      // Monetization
      'supporter_price': 5.0,
      'advocate_price': 15.0,
      'champion_price': 25.0,
      'donation_amounts': ['3', '5', '10', '25'],
    });
  }

  Future<void> _configureRemoteConfig() async {
    if (kDebugMode) {
      // Debug mode: short fetch intervals
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 1),
      ));
    } else {
      // Release mode: longer fetch intervals
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 12),
      ));
    }
  }

  Future<void> _fetchAndActivate() async {
    try {
      await _remoteConfig.fetch();
      await _remoteConfig.activate();
      _logger.info('Remote config fetched and activated');
    } catch (e) {
      _logger.warning('Failed to fetch remote config: $e');
    }
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(hours: 6), (timer) {
      _fetchAndActivate();
    });
  }

  Future<void> refresh() async {
    await _fetchAndActivate();
  }

  // Type-safe getters
  bool _getBool(String key, {required bool defaultValue}) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      _logger.warning('Failed to get bool for key $key: $e');
      return defaultValue;
    }
  }

  int _getInt(String key, {required int defaultValue}) {
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      _logger.warning('Failed to get int for key $key: $e');
      return defaultValue;
    }
  }

  double _getDouble(String key, {required double defaultValue}) {
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      _logger.warning('Failed to get double for key $key: $e');
      return defaultValue;
    }
  }

  String _getString(String key, {required String defaultValue}) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      _logger.warning('Failed to get string for key $key: $e');
      return defaultValue;
    }
  }

  List<String> _getStringList(String key,
      {required List<String> defaultValue}) {
    try {
      final value = _remoteConfig.getString(key);
      if (value.isEmpty) return defaultValue;
      return value.split(',').map((e) => e.trim()).toList();
    } catch (e) {
      _logger.warning('Failed to get string list for key $key: $e');
      return defaultValue;
    }
  }

  // Feature flag checks
  bool isFeatureEnabled(String featureName) {
    return _getBool('enable_$featureName', defaultValue: false);
  }

  // A/B testing
  String getExperimentGroup(String experimentName) {
    return _getString('${experimentName}_group', defaultValue: 'control');
  }

  bool isInExperimentGroup(String experimentName, String group) {
    return getExperimentGroup(experimentName) == group;
  }

  // Remote configuration for specific user segments
  double getConfigForUser(String configKey, String userId) {
    // Simple user segmentation based on user ID hash
    final userHash = userId.hashCode.abs();
    final segment = userHash % 3;

    switch (segment) {
      case 0:
        return _getDouble('${configKey}_segment_a',
            defaultValue: _getDouble(configKey, defaultValue: 0.0));
      case 1:
        return _getDouble('${configKey}_segment_b',
            defaultValue: _getDouble(configKey, defaultValue: 0.0));
      case 2:
        return _getDouble('${configKey}_segment_c',
            defaultValue: _getDouble(configKey, defaultValue: 0.0));
      default:
        return _getDouble(configKey, defaultValue: 0.0);
    }
  }

  // Force refresh specific keys
  Future<void> refreshKeys(List<String> keys) async {
    try {
      await _remoteConfig.fetchAndActivate();
      _logger.info('Refreshed specific keys: $keys');
    } catch (e) {
      _logger.warning('Failed to refresh keys: $e');
    }
  }

  // Debug methods
  Map<String, dynamic> getAllSettings() {
    return {
      'show_donation_banner': showDonationBanner,
      'enable_premium_features': enablePremiumFeatures,
      'show_ads': showAds,
      'enable_health_integration': enableHealthIntegration,
      'enable_music_mixing': enableMusicMixing,
      'enable_session_history': enableSessionHistory,
      'enable_custom_presets': enableCustomPresets,
      'enable_analytics': enableAnalytics,
      'max_free_sessions_per_day': maxFreeSessionsPerDay,
      'session_duration_limit': sessionDurationLimit,
      'donation_goal_amount': donationGoalAmount,
      'current_version': currentVersion,
      'min_supported_version': minSupportedVersion,
      'featured_preset_ids': featuredPresetIds,
      'motivational_quote': motivationalQuote,
      'update_message': updateMessage,
      'supporter_price': supporterPrice,
      'advocate_price': advocatePrice,
      'champion_price': championPrice,
      'donation_amounts': donationAmounts,
    };
  }

  void dispose() {
    _refreshTimer?.cancel();
  }
}
