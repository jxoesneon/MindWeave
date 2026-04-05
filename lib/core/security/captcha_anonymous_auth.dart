import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env_config.dart';
import 'hcaptcha_drawer.dart';

/// Service for handling anonymous authentication with hCaptcha protection.
class CaptchaAnonymousAuth {
  final _log = Logger('CaptchaAnonymousAuth');
  final _env = EnvConfig();
  static const _hasVerifiedKey = 'has_captcha_verified';

  /// Get hCaptcha site key from environment
  String get _siteKey => _env.hcaptchaSiteKey;

  /// Check if user has already verified captcha in this session
  Future<bool> hasVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasVerifiedKey) ?? false;
  }

  /// Mark captcha as verified
  Future<void> markVerified() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasVerifiedKey, true);
  }

  /// Clear verification status (for testing)
  Future<void> clearVerification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasVerifiedKey);
  }

  /// Get device ID for identifying unique devices
  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ??
            'ios-unknown-${DateTime.now().millisecondsSinceEpoch}';
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        return macInfo.systemGUID ??
            'macos-unknown-${DateTime.now().millisecondsSinceEpoch}';
      } else if (Platform.isWindows) {
        final winInfo = await deviceInfo.windowsInfo;
        return winInfo.deviceId;
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        return linuxInfo.machineId ??
            'linux-unknown-${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      _log.warning('Failed to get device ID: $e');
    }

    return 'unknown-${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Sign in anonymously with hCaptcha verification.
  /// Shows the hCaptcha drawer if not already verified.
  Future<AuthResponse> signInAnonymously(
    BuildContext context, {
    bool forceCaptcha = false,
  }) async {
    _log.info('Starting anonymous sign-in with captcha...');

    // Check if already verified
    if (!forceCaptcha && await hasVerified()) {
      _log.info('Using existing captcha verification');
      return _performAnonymousSignIn();
    }

    // Show hCaptcha drawer
    _log.info('Showing hCaptcha verification drawer');
    final token = await HCaptchaDrawer.show(
      context,
      siteKey: _siteKey,
      isDarkMode: true,
    );

    if (token == null) {
      _log.warning('hCaptcha verification cancelled or failed');
      throw Exception('CAPTCHA verification required to continue');
    }

    _log.info('hCaptcha token received, proceeding with sign-in');

    // Perform sign-in with captcha token
    final response = await _performAnonymousSignIn(captchaToken: token);

    // Mark as verified on success
    await markVerified();

    return response;
  }

  /// Perform the actual anonymous sign-in
  Future<AuthResponse> _performAnonymousSignIn({String? captchaToken}) async {
    final deviceId = await getDeviceId();
    _log.info('Signing in anonymously for device: $deviceId');

    final data = <String, dynamic>{
      'device_id': deviceId,
      'platform': Platform.operatingSystem,
    };

    final response = await Supabase.instance.client.auth.signInAnonymously(
      data: data,
      captchaToken: captchaToken,
    );

    if (response.user != null) {
      _log.info('✅ Anonymous sign-in successful: ${response.user!.id}');
    } else if (response.session != null) {
      _log.info('✅ Anonymous session created');
    } else {
      throw Exception('Anonymous sign-in failed: no user or session returned');
    }

    return response;
  }

  /// Sign out and clear verification
  Future<void> signOut() async {
    _log.info('Signing out...');
    await Supabase.instance.client.auth.signOut();
    await clearVerification();
  }
}
