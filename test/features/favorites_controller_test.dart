import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/features/favorites/favorites_controller.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:mindweave/core/models/user_preset.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mocks.dart';

void main() {
  group('FavoritesController Tests', () {
    late MockFavoritesRepository mockRepository;
    late MockAudioService mockAudioService;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockFavoritesRepository();
      mockAudioService = MockAudioService();
      registerTestFallbacks();

      when(() => mockAudioService.init()).thenAnswer((_) async {});
      when(() => mockRepository.getFavorites()).thenAnswer((_) async => []);
      when(() => mockRepository.addFavorite(any())).thenAnswer((_) async => null);
      when(() => mockRepository.deleteFavorite(any())).thenAnswer((_) async => Future.value());

      container = ProviderContainer(
        overrides: [
          favoritesRepositoryProvider.overrideWithValue(mockRepository),
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
      );
    });

    test('initial state should be loading then empty list', () async {
      final listener = container.read(favoritesControllerProvider);
      expect(listener, const AsyncValue<List<UserPreset>>.loading());
      
      await container.read(favoritesControllerProvider.future);
      expect(container.read(favoritesControllerProvider).value, isEmpty);
    });

    test('addFavorite (saveCurrentPreset) should call repository and refresh state', () async {
      final preset = UserPreset(id: '1', userId: '', name: 'Focus', carrierFrequency: 200, beatFrequency: 10, createdAt: DateTime.now());
      
      // Keep provider alive
      final sub = container.listen(favoritesControllerProvider, (p, n) {});
      
      // Setup repo to return the preset after save
      when(() => mockRepository.addFavorite(any())).thenAnswer((_) async => preset);
      when(() => mockRepository.getFavorites()).thenAnswer((_) async => [preset]);

      await container.read(favoritesControllerProvider.notifier).saveCurrentPreset('Focus');
      
      verify(() => mockRepository.addFavorite(any())).called(1);
      final state = container.read(favoritesControllerProvider);
      expect(state.value, contains(preset));
      
      sub.close();
    });

    test('removeFavorite should call repository and refresh state', () async {
      final preset = UserPreset(id: '1', userId: '', name: 'Focus', carrierFrequency: 200, beatFrequency: 10, createdAt: DateTime.now());
      
      // Setup initial state with one preset
      when(() => mockRepository.getFavorites()).thenAnswer((_) async => [preset]);
      await container.read(favoritesControllerProvider.future);
      
      // After removal, repo returns empty
      when(() => mockRepository.getFavorites()).thenAnswer((_) async => []);

      await container.read(favoritesControllerProvider.notifier).deleteFavorite('1');
      
      verify(() => mockRepository.deleteFavorite('1')).called(1);
      expect(container.read(favoritesControllerProvider).value, isEmpty);
    });
  });
}
