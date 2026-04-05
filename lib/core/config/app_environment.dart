import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration for MindWeave
/// Loads and provides access to environment variables from .env file
class AppEnvironment {
  static final AppEnvironment _instance = AppEnvironment._internal();
  factory AppEnvironment() => _instance;
  AppEnvironment._internal();

  bool _initialized = false;

  /// Initialize the environment by loading .env file
  /// Call this before accessing any environment variables
  Future<void> initialize() async {
    if (_initialized) return;
    await dotenv.load(fileName: '.env');
    _initialized = true;
  }

  /// Get a string value from environment variables
  String get(String key, {String fallback = ''}) {
    return dotenv.env[key] ?? fallback;
  }

  /// Get a boolean value from environment variables
  bool getBool(String key, {bool fallback = false}) {
    final value = dotenv.env[key]?.toLowerCase();
    if (value == null) return fallback;
    return value == 'true' || value == '1' || value == 'yes';
  }

  // ============================================
  // Supabase Configuration
  // ============================================
  String get supabaseUrl => get('SUPABASE_URL');
  String get supabaseAnonKey => get('SUPABASE_ANON_KEY');

  // ============================================
  // hCaptcha Configuration
  // ============================================
  String get hcaptchaSiteKey => get('HCAPTCHA_SITE_KEY');

  // ============================================
  // Google Sign-In Configuration
  // ============================================
  String get googleWebClientId => get('GOOGLE_WEB_CLIENT_ID');
  String get googleIosClientId => get('GOOGLE_IOS_CLIENT_ID');

  // ============================================
  // Feature Flags
  // ============================================
  bool get isCaptchaEnabled => getBool('ENABLE_CAPTCHA', fallback: true);
  bool get isGoogleSignInEnabled => getBool('ENABLE_GOOGLE_SIGNIN', fallback: true);
  bool get isDevMode => getBool('DEV_MODE', fallback: false);

  // ============================================
  // Payment Configuration (Optional)
  // ============================================
  String? get revenueCatApiKey {
    final key = get('REVENUECAT_API_KEY');
    return key.isNotEmpty ? key : null;
  }

  /// Check if all required secrets are configured
  List<String> validateRequiredSecrets() {
    final missing = <String>[];

    if (supabaseUrl.isEmpty || supabaseUrl.contains('your-project')) {
      missing.add('SUPABASE_URL');
    }
    if (supabaseAnonKey.isEmpty || supabaseAnonKey.contains('your-anon-key')) {
      missing.add('SUPABASE_ANON_KEY');
    }
    if (hcaptchaSiteKey.isEmpty || hcaptchaSiteKey.contains('your-hcaptcha')) {
      missing.add('HCAPTCHA_SITE_KEY');
    }

    return missing;
  }

  /// Check if environment is properly initialized
  bool get isInitialized => _initialized;
}

/// Global instance for easy access
final appEnv = AppEnvironment();
