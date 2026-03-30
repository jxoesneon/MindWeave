import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'brainwave_preset.dart';

import '../supabase/supabase_client_provider.dart';

part 'presets_provider.g.dart';

@riverpod
Future<List<BrainwavePreset>> presets(Ref ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('brainwave_presets')
      .select()
      .order('beat_frequency', ascending: true);

  return (response as List)
      .map((json) => BrainwavePreset.fromJson(json))
      .toList();
}
