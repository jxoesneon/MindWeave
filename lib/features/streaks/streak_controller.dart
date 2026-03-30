import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/repository/session_repository.dart';

part 'streak_controller.g.dart';

@riverpod
class StreakController extends _$StreakController {
  late final SessionRepositoryImpl _repository;

  @override
  FutureOr<int> build() async {
    _repository = ref.read(sessionRepositoryProvider);
    return await _repository.calculateCurrentStreak();
  }

  Future<void> refreshStreak() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.calculateCurrentStreak());
  }
}
