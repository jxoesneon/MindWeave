import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/storage_service.dart';

/// Provider for the current theme mode
final themeModeProvider = AsyncNotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

/// Controller for managing theme preference
class ThemeController extends AsyncNotifier<ThemeMode> {
  final StorageService _storageService = StorageService();
  static const String _themeKey = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    // Load saved theme preference
    try {
      final box = await _storageService.openBox<dynamic>('settings');
      final savedTheme = box.get(_themeKey) as String?;

      if (savedTheme != null) {
        return ThemeMode.values.firstWhere(
          (mode) => mode.name == savedTheme,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }

    return ThemeMode.system;
  }

  /// Set theme mode and persist preference
  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncValue.data(mode);

    try {
      final box = await _storageService.openBox<dynamic>('settings');
      await box.put(_themeKey, mode.name);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final currentMode = state.value ?? ThemeMode.system;
    final newMode = currentMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Check if currently using dark mode
  bool get isDarkMode => state.value == ThemeMode.dark;

  /// Check if currently using light mode
  bool get isLightMode => state.value == ThemeMode.light;
}
