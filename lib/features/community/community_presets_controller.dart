import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/user_preset.dart';
import '../../core/audio/audio_controller.dart';
import '../../core/audio/mixer_controller.dart';

import '../../core/supabase/supabase_client_provider.dart';

part 'community_presets_controller.g.dart';

@riverpod
class CommunityPresetsController extends _$CommunityPresetsController {
  SupabaseClient get _supabase => ref.read(supabaseClientProvider);

  @override
  FutureOr<List<UserPreset>> build() async {
    final response = await _supabase
        .from('user_favorites')
        .select()
        .eq('is_public', true)
        .order('created_at', ascending: false)
        .limit(20);
    
    return (response as List).map((json) => UserPreset.fromJson(json)).toList();
  }

  Future<void> loadCommunityPreset(UserPreset preset) async {
    // 1. Update Binaural Frequencies
    await ref.read(audioControllerProvider.notifier).loadUserPreset(preset);
    
    // 2. Update Background Mixer
    ref.read(mixerControllerProvider.notifier).setNoiseType(preset.noiseType);
    ref.read(mixerControllerProvider.notifier).updateBackgroundVolume(preset.noiseVolume);
    ref.read(audioControllerProvider.notifier).updateVolume(preset.binauralVolume);
  }
}
