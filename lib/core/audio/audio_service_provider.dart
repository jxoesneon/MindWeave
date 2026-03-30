import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'audio_service.dart';

part 'audio_service_provider.g.dart';

@riverpod
AudioService audioService(Ref ref) {
  final service = AudioService();
  ref.onDispose(() {
    service.stop();
    service.dispose();
  });
  return service;
}
