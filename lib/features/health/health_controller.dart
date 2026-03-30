import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/health/health_service.dart';

part 'health_controller.g.dart';

@riverpod
class HealthController extends _$HealthController {
  final _service = HealthService();

  @override
  FutureOr<double?> build() async {
    // Return null initially, user must request sync
    return null;
  }

  Future<void> syncSleepData() async {
    state = const AsyncValue.loading();
    
    final hasPermission = await _service.requestPermissions();
    if (!hasPermission) {
      state = AsyncValue.error('Health permission denied', StackTrace.current);
      return;
    }

    final data = await _service.getSleepData();
    final score = _service.calculateSleepQualityScore(data);
    state = AsyncValue.data(score);
  }
}
