import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'core/config/env_config.dart';
import 'core/services/analytics_service.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_navigation.dart';
import 'features/navigation/app_routes.dart';
import 'features/settings/theme_controller.dart';

import 'core/services/crash_reporting_service.dart';
import 'core/error/error_boundaries.dart';
import 'features/auth/auth_flow_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Declare supabaseClient at top scope for use throughout main()
  late final SupabaseClient supabaseClient;

  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.level.name}] ${record.time}: ${record.message}');
  });
  final log = Logger('main');
  log.info('🚀 MindWeave starting...');

  // Initialize Hive
  log.info('📦 Initializing Hive...');
  await Hive.initFlutter('mindweave_data');
  await Hive.openBox('stats');
  log.info('✅ Hive initialized successfully');

  // Initialize environment configuration
  // Dev: Loads from .env file
  // Prod: Uses compile-time --dart-define variables
  try {
    await EnvConfig().initialize();
  } catch (e) {
    debugPrint('Environment config initialization failed: $e');
  }

  // Initialize Firebase (required for Remote Config, Analytics, etc.)
  log.info('🔥 Initializing Firebase...');
  try {
    await Firebase.initializeApp();
    log.info('✅ Firebase initialized successfully');
  } catch (e) {
    log.severe('❌ Firebase initialization failed: $e');
  }

  // Initialize Supabase
  log.info('🌐 Initializing Supabase...');
  try {
    await Supabase.initialize(
      url: EnvConfig().supabaseUrl,
      anonKey: EnvConfig().supabaseAnonKey,
    );
    supabaseClient = Supabase.instance.client;
    final authUser = supabaseClient.auth.currentUser;
    log.info(
      '✅ Supabase initialized successfully (user: ${authUser?.id ?? 'none'})',
    );
  } catch (e) {
    log.severe('❌ Supabase initialization failed: $e');
  }

  // Note: Anonymous sign-in with hCaptcha is now handled by AuthGate widget
  final hasSession = supabaseClient.auth.currentSession != null;
  if (hasSession) {
    log.info(
      '✅ Existing session found (user: ${supabaseClient.auth.currentUser?.id})',
    );
  } else {
    log.info('👤 No session - hCaptcha verification will be required');
  }

  // Initialize Remote Config (non-blocking — falls back to defaults on failure)
  log.info('⚙️ Initializing Remote Config...');
  try {
    await RemoteConfigService().initialize();
    log.info('✅ Remote Config initialized successfully');
  } catch (e) {
    log.warning('⚠️ Remote config initialization failed, using defaults: $e');
  }

  // Initialize PostHog Analytics (non-blocking — disabled if no API key)
  log.info('📊 Initializing Analytics...');
  try {
    await AnalyticsService().initialize();
    // Identify anonymous user if available
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId != null) {
      await AnalyticsService().identify(userId);
      log.info('✅ Analytics initialized and user identified');
    } else {
      log.info('✅ Analytics initialized (no user to identify)');
    }
  } catch (e) {
    log.warning('⚠️ Analytics initialization failed: $e');
  }

  // Initialize Deep Link Service
  log.info('🔗 Initializing Deep Link Service...');
  final deepLinkService = DeepLinkService();
  try {
    await deepLinkService.initialize();
    log.info('✅ Deep Link Service initialized successfully');
  } catch (e) {
    log.warning('⚠️ Deep link service initialization failed: $e');
  }

  // Initialize Crash Reporting
  log.info('🛡️ Initializing Crash Reporting...');
  try {
    await CrashReportingService().initialize();
    log.info('✅ Crash Reporting initialized successfully');
  } catch (e) {
    log.warning('⚠️ Crash Reporting initialization failed: $e');
  }

  log.info('🎉 MindWeave initialization complete!');

  runApp(
    ProviderScope(
      child: ErrorBoundary(
        child: MyApp(
          deepLinkService: deepLinkService,
          needsAuth: supabaseClient.auth.currentSession == null,
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final DeepLinkService? deepLinkService;
  final bool needsAuth;

  const MyApp({super.key, this.deepLinkService, this.needsAuth = false});

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
      routes: AppRoutes.routes,
      home: needsAuth
          ? const AuthFlowScreen()
          : MainNavigation(deepLinkService: deepLinkService),
    );
  }
}
