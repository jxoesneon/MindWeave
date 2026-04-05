import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_preset.dart';
import '../storage/storage_service.dart';

import '../supabase/supabase_client_provider.dart';

part 'favorites_repository.g.dart';

@riverpod
FavoritesRepository favoritesRepository(Ref ref) {
  final storageService = ref.watch(storageServiceProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  return FavoritesRepository(
    storageService: storageService,
    supabase: supabaseClient,
  );
}

class FavoritesRepository {
  final SupabaseClient _supabase;
  final StorageService _storageService;
  static const String boxName = 'favorites_box';

  FavoritesRepository({
    required SupabaseClient supabase,
    required StorageService storageService,
  })  : _supabase = supabase,
        _storageService = storageService;

  Future<List<UserPreset>> getFavorites() async {
    // Check if Supabase is properly configured
    final supabaseUrl = _supabase.rest.url;
    if (supabaseUrl.contains('your_supabase') || supabaseUrl.isEmpty) {
      debugPrint('⚠️ Supabase not configured, returning local favorites only');
      return _getLocalFavorites();
    }

    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) return _getLocalFavorites();

    try {
      final response = await _supabase
          .from('user_favorites')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final remoteFavorites = (response as List)
          .map((json) => UserPreset.fromJson(json))
          .toList();

      // Sync to local
      await _saveLocalFavorites(remoteFavorites);
      return remoteFavorites;
    } catch (e) {
      debugPrint('Error fetching remote favorites: $e');
      return _getLocalFavorites();
    }
  }

  Future<UserPreset?> addFavorite(UserPreset preset) async {
    // Check if Supabase is properly configured
    final supabaseUrl = _supabase.rest.url;
    if (supabaseUrl.contains('your_supabase') || supabaseUrl.isEmpty) {
      debugPrint('⚠️ Supabase not configured, saving favorite locally only');
      await _addToLocal(preset);
      return preset;
    }

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final presetWithUser = preset.copyWith(userId: userId);

    try {
      final response = await _supabase
          .from('user_favorites')
          .insert(presetWithUser.toJson())
          .select()
          .single();

      final savedPreset = UserPreset.fromJson(response);
      await _addToLocal(savedPreset);
      return savedPreset;
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      return null;
    }
  }

  Future<void> deleteFavorite(String id) async {
    // Check if Supabase is properly configured
    final supabaseUrl = _supabase.rest.url;
    if (supabaseUrl.contains('your_supabase') || supabaseUrl.isEmpty) {
      debugPrint('⚠️ Supabase not configured, deleting favorite locally only');
      await _removeFromLocal(id);
      return;
    }

    try {
      await _supabase.from('user_favorites').delete().eq('id', id);
      await _removeFromLocal(id);
    } catch (e) {
      debugPrint('Error deleting favorite: $e');
    }
  }

  Future<List<UserPreset>> _getLocalFavorites() async {
    final raw = await _storageService.get(boxName, 'presets', defaultValue: []);
    final List<dynamic> rawList = raw is List ? raw : [];
    return rawList.map((item) => UserPreset.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  Future<void> _saveLocalFavorites(List<UserPreset> presets) async {
    await _storageService.put(boxName, 'presets', presets.map((p) => p.toJson()).toList());
  }

  Future<void> _addToLocal(UserPreset preset) async {
    final favorites = await _getLocalFavorites();
    favorites.add(preset);
    await _saveLocalFavorites(favorites);
  }

  Future<void> _removeFromLocal(String id) async {
    final favorites = await _getLocalFavorites();
    favorites.removeWhere((p) => p.id == id);
    await _saveLocalFavorites(favorites);
  }
}
