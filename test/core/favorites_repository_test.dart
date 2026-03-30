import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:mindweave/core/models/user_preset.dart';
import 'package:mindweave/core/audio/mixer_state.dart';
import '../mocks.dart';

void main() {
  late FavoritesRepository repository;
  late MockStorageService mockStorage;
  late CustomMockSupabaseClient mockSupabase;
  late FakeGoTrueClient fakeAuth;
  late MockPostgrestQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockStorage = MockStorageService();
    fakeAuth = FakeGoTrueClient();
    mockSupabase = CustomMockSupabaseClient(fakeAuth);
    mockQueryBuilder = MockPostgrestQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();

    when(() => mockSupabase.from(any())).thenReturn(mockQueryBuilder);

    repository = FavoritesRepository(
      supabase: mockSupabase,
      storageService: mockStorage,
    );
  });

  group('FavoritesRepository Tests', () {
    final preset = UserPreset(
      id: '1',
      name: 'Focus',
      noiseType: NoiseType.white,
      noiseVolume: 0.5,
      userId: 'user1',
      carrierFrequency: 200,
      beatFrequency: 10,
      createdAt: DateTime.now(),
    );

    test(
      'getFavorites returns remote favorites when user is logged in',
      () async {
        fakeAuth.currentUser = FakeUser();

        when(
          () => mockQueryBuilder.select(),
        ).thenAnswer((_) => mockFilterBuilder);
        when(
          () => mockFilterBuilder.eq(any(), any()),
        ).thenAnswer((_) => mockFilterBuilder);
        when(
          () => mockFilterBuilder.order(
            any(),
            ascending: any(named: 'ascending'),
          ),
        ).thenReturn(
          FakePostgrestBuilder<List<Map<String, dynamic>>>([
            preset.toJson(),
          ]),
        );
        when(
          () => mockStorage.put<List<Map<String, dynamic>>>(any(), any(), any()),
        ).thenAnswer((_) async => {});

        final result = await repository.getFavorites();

        expect(result.length, 1);
        expect(result.first.name, 'Focus');
        verify(() => mockStorage.put<List<Map<String, dynamic>>>(any(), 'presets', any())).called(1);
      },
    );

    test(
      'getFavorites returns local favorites when user is logged out',
      () async {
        fakeAuth.currentUser = null;
        when(
          () => mockStorage.get<List<dynamic>>(
            any(),
            'presets',
            defaultValue: any(named: 'defaultValue'),
          ),
        ).thenAnswer((_) async => [preset.toJson()]);

        final result = await repository.getFavorites();

        expect(result.length, 1);
        expect(result.first.name, 'Focus');
        verify(
          () => mockStorage.get<List<dynamic>>(any(), 'presets', defaultValue: any(named: 'defaultValue')),
        ).called(1);
      },
    );

    test('addFavorite inserts into Supabase and saves locally', () async {
      fakeAuth.currentUser = FakeUser();

      when(
        () => mockQueryBuilder.insert(any()),
      ).thenAnswer((_) => mockFilterBuilder);
      when(
        () => mockFilterBuilder.select(),
      ).thenAnswer((_) => mockFilterBuilder);
      when(() => mockFilterBuilder.single()).thenReturn(
        FakePostgrestBuilder<Map<String, dynamic>>(preset.toJson()),
      );

      when(
        () => mockStorage.get<List<dynamic>>(
          any(),
          'presets',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenAnswer((_) async => []);
      when(
        () => mockStorage.put<List<Map<String, dynamic>>>(any(), any(), any()),
      ).thenAnswer((_) async => {});

      final result = await repository.addFavorite(preset);

      expect(result, isNotNull);
      expect(result!.name, 'Focus');
      verify(() => mockStorage.put<List<Map<String, dynamic>>>(any(), 'presets', any())).called(1);
    });

    test('deleteFavorite deletes from Supabase and removes locally', () async {
      when(
        () => mockQueryBuilder.delete(),
      ).thenAnswer((_) => mockFilterBuilder);
      // Wait, mocktail might have issue if we chain stub so let's simplify!
      when(
        () => mockFilterBuilder.eq(any(), any()),
      ).thenReturn(FakePostgrestBuilder<List<Map<String, dynamic>>>([]));

      when(
        () => mockStorage.get<List<dynamic>>(
          any(),
          'presets',
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenAnswer((_) async => [preset.toJson()]);
      when(
        () => mockStorage.put<List<Map<String, dynamic>>>(any(), any(), any()),
      ).thenAnswer((_) async => {});

      await repository.deleteFavorite('1');

      verify(() => mockQueryBuilder.delete()).called(1);
      verify(() => mockStorage.put<List<Map<String, dynamic>>>(any(), 'presets', any())).called(1);
    });
  });
}
