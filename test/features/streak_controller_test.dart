import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/features/streaks/streak_controller.dart';
import 'package:mindweave/core/repository/session_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mocks.dart';

void main() {
  group('StreakController Tests', () {
    late MockSessionRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockSessionRepository();
      registerTestFallbacks();

      when(() => mockRepository.calculateCurrentStreak()).thenAnswer((_) async => 5);

      container = ProviderContainer(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    test('initial state should fetch streak from repository', () async {
      final streak = await container.read(streakControllerProvider.future);
      expect(streak, 5);
      verify(() => mockRepository.calculateCurrentStreak()).called(1);
    });

    test('refreshStreak should update state with new streak', () async {
      // Setup initial fetch
      await container.read(streakControllerProvider.future);
      
      // Update repo value
      when(() => mockRepository.calculateCurrentStreak()).thenAnswer((_) async => 6);
      
      await container.read(streakControllerProvider.notifier).refreshStreak();
      
      final streak = container.read(streakControllerProvider).value;
      expect(streak, 6);
    });
  });
}
