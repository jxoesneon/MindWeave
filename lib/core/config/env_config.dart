import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration helper
///
/// Supports two modes:
/// 1. Development: Loads from .env file via flutter_dotenv
/// 2. Production: Uses compile-time environment variables (--dart-define)
///
/// For production builds, use: `flutter build <platform> --dart-define=SUPABASE_URL=url --dart-define=SUPABASE_ANON_KEY=key`
class EnvConfig {
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;
  EnvConfig._internal();

  bool _initialized = false;

  /// Initialize environment configuration
  /// Call this in main() before accessing any environment variables
  Future<void> initialize() async {
    if (_initialized) return;

    // Try to load .env file for development
    // If it fails (production build), we'll use dart-define values
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      // .env not found - using compile-time environment variables
    }

    _initialized = true;
  }

  /// Get Supabase URL
  ///
  /// Priority:
  /// 1. Compile-time variable (--dart-define) for production
  /// 2. .env file value for development
  String get supabaseUrl {
    // Check compile-time environment first (production)
    const compileTimeValue = String.fromEnvironment('SUPABASE_URL');
    if (compileTimeValue.isNotEmpty) {
      return compileTimeValue;
    }

    // Fall back to .env file (development)
    return dotenv.get('SUPABASE_URL', fallback: '');
  }

  /// Get Supabase Anon Key
  ///
  /// Priority:
  /// 1. Compile-time variable (--dart-define) for production
  /// 2. .env file value for development
  String get supabaseAnonKey {
    // Check compile-time environment first (production)
    const compileTimeValue = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (compileTimeValue.isNotEmpty) {
      return compileTimeValue;
    }

    // Fall back to .env file (development)
    return dotenv.get('SUPABASE_ANON_KEY', fallback: '');
  }

  /// Get PostHog API Key
  String get posthogApiKey {
    const compileTimeValue = String.fromEnvironment('POSTHOG_API_KEY');
    if (compileTimeValue.isNotEmpty) return compileTimeValue;
    return dotenv.get('POSTHOG_API_KEY', fallback: '');
  }

  /// Get PostHog Host (defaults to PostHog Cloud US)
  String get posthogHost {
    const compileTimeValue = String.fromEnvironment('POSTHOG_HOST');
    if (compileTimeValue.isNotEmpty) return compileTimeValue;
    return dotenv.get('POSTHOG_HOST', fallback: 'https://us.i.posthog.com');
  }

  /// Get hCaptcha Site Key
  String get hcaptchaSiteKey {
    const compileTimeValue = String.fromEnvironment('HCAPTCHA_SITE_KEY');
    if (compileTimeValue.isNotEmpty) return compileTimeValue;
    return dotenv.get('HCAPTCHA_SITE_KEY', fallback: '');
  }

  /// Get Google Web Client ID
  String get googleWebClientId {
    const compileTimeValue = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
    if (compileTimeValue.isNotEmpty) return compileTimeValue;
    return dotenv.get('GOOGLE_WEB_CLIENT_ID', fallback: '');
  }

  /// Get Google iOS/macOS Client ID
  String get googleIosClientId {
    const compileTimeValue = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
    if (compileTimeValue.isNotEmpty) return compileTimeValue;
    return dotenv.get('GOOGLE_IOS_CLIENT_ID', fallback: '');
  }

  /// Check if hCaptcha is enabled
  bool get isCaptchaEnabled {
    const compileTimeValue = String.fromEnvironment('ENABLE_CAPTCHA');
    if (compileTimeValue.isNotEmpty) {
      return compileTimeValue.toLowerCase() == 'true';
    }
    final value = dotenv.get('ENABLE_CAPTCHA', fallback: 'true');
    return value.toLowerCase() == 'true';
  }

  /// Check if Google Sign-In is enabled
  bool get isGoogleSignInEnabled {
    const compileTimeValue = String.fromEnvironment('ENABLE_GOOGLE_SIGNIN');
    if (compileTimeValue.isNotEmpty) {
      return compileTimeValue.toLowerCase() == 'true';
    }
    final value = dotenv.get('ENABLE_GOOGLE_SIGNIN', fallback: 'true');
    return value.toLowerCase() == 'true';
  }

  /// Check if running in production mode (compile-time vars present)
  bool get isProduction {
    const url = String.fromEnvironment('SUPABASE_URL');
    return url.isNotEmpty;
  }
}
