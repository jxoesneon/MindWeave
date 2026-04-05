import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:mindweave/core/models/user_preset.dart';
import '../mocks.dart';

void main() {
  late FavoritesRepository repository;
  late MockSupabaseClient mockSupabase;
  late MockStorageService mockStorageService;
  late MockGoTrueClient mockAuth;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockStorageService = MockStorageService();
    mockAuth = MockGoTrueClient();

    repository = FavoritesRepository(
      supabase: mockSupabase,
      storageService: mockStorageService,
    );

    // Setup auth mock
    when(() => mockSupabase.auth).thenReturn(mockAuth);
  });

  group('FavoritesRepository Tests', () {
    test(
      'getFavorites returns local favorites when user is logged out',
      () async {
        // Arrange: No authenticated user
        when(() => mockAuth.currentUser).thenReturn(null);
        when(
          () => mockStorageService.get(
            'favorites_box',
            'presets',
            defaultValue: [],
          ),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repository.getFavorites();

        // Assert
        expect(result, isEmpty);
        verify(
          () => mockStorageService.get(
            'favorites_box',
            'presets',
            defaultValue: [],
          ),
        ).called(1);
        verifyNever(() => mockSupabase.from('user_favorites'));
      },
    );

    test(
      'getFavorites returns remote favorites when user is logged in',
      () async {
        // Arrange
        final mockUser = User(
          id: 'test-user-id',
          email: 'test@example.com',
          createdAt: DateTime.now().toIso8601String(),
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
        );
        final mockFavorites = [
          {
            'id': 'preset-1',
            'user_id': 'test-user-id',
            'name': 'Test Preset',
            'carrier_frequency': 200.0,
            'beat_frequency': 10.0,
            'created_at': DateTime.now().toIso8601String(),
          },
        ];

        when(() => mockAuth.currentUser).thenReturn(mockUser);
        final mockQueryBuilder = MockPostgrestQueryBuilder();
        when(
          () => mockSupabase.from('user_favorites'),
        ).thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select()).thenReturn(
          FakePostgrestBuilder<List<Map<String, dynamic>>>(mockFavorites),
        );
        when(
          () => mockStorageService.put(any(), any(), any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.getFavorites();

        // Assert
        expect(result, hasLength(1));
        expect(result.first.id, 'preset-1');
        expect(result.first.name, 'Test Preset');
      },
    );

    test(
      'getFavorites falls back to local favorites on Supabase error',
      () async {
        // Arrange
        final mockUser = User(
          id: 'test-user-id',
          email: 'test@example.com',
          createdAt: DateTime.now().toIso8601String(),
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
        );
        final localFavorites = [
          {
            'id': 'local-preset',
            'user_id': 'test-user-id',
            'name': 'Local Preset',
            'carrier_frequency': 200.0,
            'beat_frequency': 10.0,
            'created_at': DateTime.now().toIso8601String(),
          },
        ];

        when(() => mockAuth.currentUser).thenReturn(mockUser);
        when(
          () => mockSupabase.from('user_favorites'),
        ).thenThrow(Exception('Network error'));
        when(
          () => mockStorageService.get(
            'favorites_box',
            'presets',
            defaultValue: [],
          ),
        ).thenAnswer((_) async => localFavorites);

        // Act
        final result = await repository.getFavorites();

        // Assert
        expect(result, hasLength(1));
        expect(result.first.id, 'local-preset');
      },
    );

    test('addFavorite returns null when user is logged out', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      final preset = UserPreset(
        id: 'test-id',
        userId: 'test-user-id',
        name: 'Test Preset',
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await repository.addFavorite(preset);

      // Assert
      expect(result, isNull);
      verifyNever(() => mockSupabase.from('user_favorites'));
    });

    test(
      'addFavorite inserts into Supabase and saves locally when user is logged in',
      () async {
        // Arrange
        final mockUser = User(
          id: 'test-user-id',
          email: 'test@example.com',
          createdAt: DateTime.now().toIso8601String(),
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
        );
        final savedPreset = {
          'id': 'new-preset-id',
          'user_id': 'test-user-id',
          'name': 'New Preset',
          'carrier_frequency': 250.0,
          'beat_frequency': 12.0,
          'created_at': DateTime.now().toIso8601String(),
        };

        when(() => mockAuth.currentUser).thenReturn(mockUser);
        final mockQueryBuilder = MockPostgrestQueryBuilder();
        when(
          () => mockSupabase.from('user_favorites'),
        ).thenReturn(mockQueryBuilder);
        when(
          () => mockQueryBuilder.insert(any()),
        ).thenReturn(FakePostgrestBuilder<Map<String, dynamic>>(savedPreset));
        when(() => mockQueryBuilder.select()).thenReturn(
          FakePostgrestBuilder<List<Map<String, dynamic>>>([savedPreset]),
        );
        when(
          () => mockStorageService.get(
            any(),
            any(),
            defaultValue: any(named: 'defaultValue'),
          ),
        ).thenAnswer((_) async => []);
        when(
          () => mockStorageService.put(any(), any(), any()),
        ).thenAnswer((_) async {});

        final preset = UserPreset(
          id: 'temp-id',
          userId: 'test-user-id',
          name: 'New Preset',
          carrierFrequency: 250.0,
          beatFrequency: 12.0,
          createdAt: DateTime.now(),
        );

        // Act
        final result = await repository.addFavorite(preset);

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 'new-preset-id');
        expect(result.userId, 'test-user-id');
      },
    );

    test('addFavorite returns null on Supabase error', () async {
      // Arrange
      final mockUser = User(
        id: 'test-user-id',
        email: 'test@example.com',
        createdAt: DateTime.now().toIso8601String(),
        appMetadata: {},
        userMetadata: {},
        aud: 'authenticated',
      );

      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(
        () => mockSupabase.from('user_favorites'),
      ).thenThrow(Exception('Insert failed'));

      final preset = UserPreset(
        id: 'test-id',
        userId: 'test-user-id',
        name: 'Test Preset',
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        createdAt: DateTime.now(),
      );

      // Act
      final result = await repository.addFavorite(preset);

      // Assert
      expect(result, isNull);
    });

    test('deleteFavorite deletes from Supabase and removes locally', () async {
      // Arrange
      final mockUser = User(
        id: 'test-user-id',
        email: 'test@example.com',
        createdAt: DateTime.now().toIso8601String(),
        appMetadata: {},
        userMetadata: {},
        aud: 'authenticated',
      );
      final existingFavorites = [
        {
          'id': 'preset-1',
          'user_id': 'test-user-id',
          'name': 'Preset 1',
          'carrier_frequency': 200.0,
          'beat_frequency': 10.0,
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 'preset-2',
          'user_id': 'test-user-id',
          'name': 'Preset 2',
          'carrier_frequency': 250.0,
          'beat_frequency': 15.0,
          'created_at': DateTime.now().toIso8601String(),
        },
      ];

      when(() => mockAuth.currentUser).thenReturn(mockUser);
      final mockQueryBuilder = MockPostgrestQueryBuilder();
      when(
        () => mockSupabase.from('user_favorites'),
      ).thenReturn(mockQueryBuilder);
      when(
        () => mockQueryBuilder.delete(),
      ).thenReturn(FakePostgrestBuilder<List<Map<String, dynamic>>>([]));
      when(
        () => mockStorageService.get(
          'favorites_box',
          'presets',
          defaultValue: [],
        ),
      ).thenAnswer((_) async => existingFavorites);
      when(
        () => mockStorageService.put(any(), any(), any()),
      ).thenAnswer((_) async {});

      // Act
      await repository.deleteFavorite('preset-1');

      // Assert
      verify(() => mockSupabase.from('user_favorites')).called(1);
      verify(
        () => mockStorageService.put('favorites_box', 'presets', any()),
      ).called(1);
    });

    test('deleteFavorite handles error gracefully', () async {
      // Arrange
      when(
        () => mockSupabase.from('user_favorites'),
      ).thenThrow(Exception('Delete failed'));

      // Act & Assert - should not throw
      expect(
        () async => await repository.deleteFavorite('preset-id'),
        returnsNormally,
      );
    });
  });
}
