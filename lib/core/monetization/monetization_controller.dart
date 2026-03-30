import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/storage_service.dart';

part 'monetization_controller.g.dart';

@riverpod
class MonetizationController extends _$MonetizationController {
  static const String boxName = 'stats';

  @override
  bool build() {
    _init();
    return false;
  }

  Future<void> _init() async {
    final storage = ref.read(storageServiceProvider);
    final sessionCount =
        await storage.get<int>(boxName, 'sessionCount', defaultValue: 0) ?? 0;
    final totalMinutes =
        await storage.get<int>(boxName, 'totalMinutes', defaultValue: 0) ?? 0;

    state = sessionCount >= 5 || totalMinutes >= 30;
  }

  Future<void> recordSession(int durationSeconds) async {
    final storage = ref.read(storageServiceProvider);

    final currentSessions =
        await storage.get<int>(boxName, 'sessionCount', defaultValue: 0) ?? 0;
    final currentMinutes =
        await storage.get<int>(boxName, 'totalMinutes', defaultValue: 0) ?? 0;

    final newSessions = currentSessions + 1;
    final newMinutes = currentMinutes + (durationSeconds ~/ 60);

    await storage.put(boxName, 'sessionCount', newSessions);
    await storage.put(boxName, 'totalMinutes', newMinutes);

    state = newSessions >= 5 || newMinutes >= 30;
  }
}
