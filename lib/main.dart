import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/env_config.dart';
import 'core/services/analytics_service.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/theme/app_theme.dart';
import 'features/home/player_screen.dart';
import 'features/settings/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter('mindweave_data');
  await Hive.openBox('stats');

  // Initialize environment configuration
  // Dev: Loads from .env file
  // Prod: Uses compile-time --dart-define variables
  try {
    await EnvConfig().initialize();
  } catch (e) {
    debugPrint('Environment config initialization failed: $e');
  }

  // Initialize Firebase (required for Remote Config, Analytics, etc.)
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: EnvConfig().supabaseUrl,
      anonKey: EnvConfig().supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }

  // Sign in anonymously if no session exists
  final supabase = Supabase.instance.client;
  if (supabase.auth.currentSession == null) {
    try {
      await supabase.auth.signInAnonymously();
    } catch (e) {
      debugPrint('Anonymous sign-in failed: $e');
    }
  }

  // Initialize Remote Config (non-blocking — falls back to defaults on failure)
  try {
    await RemoteConfigService().initialize();
  } catch (e) {
    debugPrint('Remote config initialization failed, using defaults: $e');
  }

  // Initialize PostHog Analytics (non-blocking — disabled if no API key)
  try {
    await AnalyticsService().initialize();
    // Identify anonymous user if available
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await AnalyticsService().identify(userId);
    }
  } catch (e) {
    debugPrint('Analytics initialization failed: $e');
  }

  // Initialize Deep Link Service
  final deepLinkService = DeepLinkService();
  try {
    await deepLinkService.initialize();
  } catch (e) {
    debugPrint('Deep link service initialization failed: $e');
  }

  runApp(ProviderScope(child: MyApp(deepLinkService: deepLinkService)));
}

class MyApp extends ConsumerWidget {
  final DeepLinkService? deepLinkService;

  const MyApp({super.key, this.deepLinkService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'MindWeave',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.when(
        data: (mode) => mode,
        loading: () => ThemeMode.system,
        error: (_, _) => ThemeMode.dark,
      ),
      home: PlayerScreen(deepLinkService: deepLinkService),
    );
  }
}
