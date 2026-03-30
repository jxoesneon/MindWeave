import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:uuid/uuid.dart';
import '../../core/audio/audio_controller.dart';
import '../../core/audio/mixer_controller.dart';
import '../../core/models/user_preset.dart';

part 'favorites_controller.g.dart';

@riverpod
class FavoritesController extends _$FavoritesController {
  FavoritesRepository get _repository => ref.read(favoritesRepositoryProvider);

  @override
  FutureOr<List<UserPreset>> build() async {
    return _repository.getFavorites();
  }

  Future<void> saveCurrentPreset(String name) async {
    final mixerState = ref.read(mixerControllerProvider);
    final audioState = ref.read(audioControllerProvider);

    final preset = UserPreset(
      id: const Uuid().v4(),
      userId: '', // Will be set by repository
      name: name,
      carrierFrequency: audioState.carrierFrequency,
      beatFrequency: audioState.beatFrequency,
      noiseType: mixerState.noiseType,
      noiseVolume: mixerState.backgroundVolume,
      binauralVolume: audioState.volume,
      createdAt: DateTime.now(),
    );

    state = const AsyncValue.loading();
    final saved = await _repository.addFavorite(preset);
    
    if (saved != null) {
      final currentList = await _repository.getFavorites();
      state = AsyncValue.data(currentList);
    } else {
      state = AsyncValue.error('Failed to save preset', StackTrace.current);
    }
  }

  Future<void> deleteFavorite(String id) async {
    state = const AsyncValue.loading();
    await _repository.deleteFavorite(id);
    final currentList = await _repository.getFavorites();
    state = AsyncValue.data(currentList);
  }

  Future<void> togglePublic(UserPreset preset) async {
    final updated = preset.copyWith(isPublic: !preset.isPublic);
    state = const AsyncValue.loading();
    
    // We reuse the existing updateFavorite logic implicitly through addFavorite which handles upserts in Supabase
    final saved = await _repository.addFavorite(updated);
    
    if (saved != null) {
      final currentList = await _repository.getFavorites();
      state = AsyncValue.data(currentList);
    } else {
      state = AsyncValue.error('Failed to toggle visibility', StackTrace.current);
    }
  }

  Future<void> loadPreset(UserPreset preset) async {
    // Update audio controller with custom favorite
    await ref.read(audioControllerProvider.notifier).loadUserPreset(preset);
    
    // Also update background mixer from preset
    ref.read(mixerControllerProvider.notifier).setNoiseType(preset.noiseType);
    ref.read(audioControllerProvider.notifier).updateVolume(preset.binauralVolume);
  }
}
