import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/env_config.dart';
import 'core/theme/app_theme.dart';
import 'features/home/player_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter('mindweave_data');
  await Hive.openBox('stats');

  // Initialize environment configuration
  // Dev: Loads from .env file
  // Prod: Uses compile-time --dart-define variables
  await EnvConfig().initialize();

  // Initialize Supabase
  await Supabase.initialize(
    url: EnvConfig().supabaseUrl,
    anonKey: EnvConfig().supabaseAnonKey,
  );

  // Sign in anonymously if no session exists
  final supabase = Supabase.instance.client;
  if (supabase.auth.currentSession == null) {
    try {
      await supabase.auth.signInAnonymously();
    } catch (e) {
      debugPrint('Anonymous sign-in failed: $e');
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindWeave',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const PlayerScreen(),
    );
  }
}
