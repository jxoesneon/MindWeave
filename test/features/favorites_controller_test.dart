import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/features/favorites/favorites_controller.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:mindweave/core/models/user_preset.dart';
import '../mocks.dart';

void main() {
  late ProviderContainer container;
  late MockFavoritesRepository mockRepository;

  setUp(() {
    registerTestFallbacks();

    mockRepository = MockFavoritesRepository();
    setupMockFavoritesRepository(mockRepository);

    container = ProviderContainer(
      overrides: [
        favoritesRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('FavoritesController Tests', () {
    test(
      'initial state should be loading then empty list',
      () async {
        // The initial state is AsyncLoading, then transitions to data
        final state = container.read(favoritesControllerProvider);
        expect(state.isLoading, true);

        // Wait for the build to complete
        await container.read(favoritesControllerProvider.future);

        final finalState = container.read(favoritesControllerProvider);
        expect(finalState.value, []);
      },
    );

    test(
      'saveCurrentPreset should call repository and refresh state',
      () async {
        final preset = UserPreset(
          id: 'test-1',
          userId: 'user-1',
          name: 'Test Preset',
          carrierFrequency: 200.0,
          beatFrequency: 10.0,
          createdAt: DateTime.now(),
        );

        when(() => mockRepository.addFavorite(any())).thenAnswer((_) async => preset);
        when(() => mockRepository.getFavorites()).thenAnswer((_) async => [preset]);

        final controller = container.read(favoritesControllerProvider.notifier);
        await controller.saveCurrentPreset('Test Preset');

        verify(() => mockRepository.addFavorite(any())).called(1);
        verify(() => mockRepository.getFavorites()).called(1);
      },
    );

    test(
      'deleteFavorite should call repository and refresh state',
      () async {
        final preset = UserPreset(
          id: 'test-1',
          userId: 'user-1',
          name: 'Test Preset',
          carrierFrequency: 200.0,
          beatFrequency: 10.0,
          createdAt: DateTime.now(),
        );

        when(() => mockRepository.getFavorites()).thenAnswer((_) async => [preset]);
        await container.read(favoritesControllerProvider.future);

        when(() => mockRepository.deleteFavorite('test-1')).thenAnswer((_) async {});
        when(() => mockRepository.getFavorites()).thenAnswer((_) async => []);

        final controller = container.read(favoritesControllerProvider.notifier);
        await controller.deleteFavorite('test-1');

        verify(() => mockRepository.deleteFavorite('test-1')).called(1);
        verify(() => mockRepository.getFavorites()).called(1);
      },
    );

    test(
      'togglePublic should update preset visibility',
      () async {
        final preset = UserPreset(
          id: 'test-1',
          userId: 'user-1',
          name: 'Test Preset',
          carrierFrequency: 200.0,
          beatFrequency: 10.0,
          isPublic: false,
          createdAt: DateTime.now(),
        );

        final updatedPreset = preset.copyWith(isPublic: true);

        when(() => mockRepository.addFavorite(any())).thenAnswer((_) async => updatedPreset);
        when(() => mockRepository.getFavorites()).thenAnswer((_) async => [updatedPreset]);

        final controller = container.read(favoritesControllerProvider.notifier);
        await controller.togglePublic(preset);

        verify(() => mockRepository.addFavorite(any())).called(1);
      },
    );

    test(
      'state should reflect repository errors',
      () async {
        when(() => mockRepository.getFavorites()).thenThrow(Exception('Network error'));

        final state = container.read(favoritesControllerProvider);
        expect(state.hasError, false);

        // Wait for the build to complete
        try {
          await container.read(favoritesControllerProvider.future);
        } catch (_) {
          // Expected to throw
        }

        final finalState = container.read(favoritesControllerProvider);
        expect(finalState.hasError, true);
      },
    );

    test(
      'getFavorites should return favorites from repository',
      () async {
        final presets = [
          UserPreset(
            id: 'test-1',
            userId: 'user-1',
            name: 'Preset 1',
            carrierFrequency: 200.0,
            beatFrequency: 10.0,
            createdAt: DateTime.now(),
          ),
          UserPreset(
            id: 'test-2',
            userId: 'user-1',
            name: 'Preset 2',
            carrierFrequency: 300.0,
            beatFrequency: 20.0,
            createdAt: DateTime.now(),
          ),
        ];

        when(() => mockRepository.getFavorites()).thenAnswer((_) async => presets);

        final result = await container.read(favoritesControllerProvider.future);
        expect(result.length, 2);
        expect(result[0].name, 'Preset 1');
        expect(result[1].name, 'Preset 2');
      },
    );
  });
}
