import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/features/favorites/library_screen.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:mindweave/core/supabase/supabase_client_provider.dart';
import 'package:mindweave/core/storage/storage_service.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:mindweave/core/models/presets_provider.dart';
import 'package:mindweave/core/models/user_preset.dart';
import '../mocks.dart';

void main() {
  late MockFavoritesRepository mockFavoritesRepository;
  late MockAudioService mockAudioService;
  late MockSupabaseClient mockSupabaseClient;
  late MockStorageService mockStorageService;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    mockAudioService = MockAudioService();
    mockSupabaseClient = MockSupabaseClient();
    mockStorageService = MockStorageService();

    // Stubbing basic repository calls
    when(
      () => mockFavoritesRepository.getFavorites(),
    ).thenAnswer((_) async => []);
    when(() => mockAudioService.init()).thenAnswer((_) async => {});

    // Stubbing StorageService for MonetizationController
    when(
      () => mockStorageService.get<int>(
        any(),
        any(),
        defaultValue: any(named: 'defaultValue'),
      ),
    ).thenAnswer((_) async => 0);

    // Stubbing Supabase for CommunityPresetsController
    final mockQueryBuilder = MockPostgrestQueryBuilder();
    final mockFilterBuilder = MockPostgrestFilterBuilder();
    when(
      () => mockSupabaseClient.from(any()),
    ).thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.select()).thenAnswer((_) => mockFilterBuilder);
    when(
      () => mockFilterBuilder.eq(any(), any()),
    ).thenAnswer((_) => mockFilterBuilder);
    when(
      () => mockFilterBuilder.order(any(), ascending: any(named: 'ascending')),
    ).thenAnswer((_) => mockFilterBuilder);
    when(() => mockFilterBuilder.limit(any())).thenAnswer(
      (_) => FakePostgrestBuilder<List<Map<String, dynamic>>>(
        <Map<String, dynamic>>[],
      ),
    );
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        favoritesRepositoryProvider.overrideWithValue(mockFavoritesRepository),
        audioServiceProvider.overrideWithValue(mockAudioService),
        supabaseClientProvider.overrideWithValue(mockSupabaseClient),
        storageServiceProvider.overrideWithValue(mockStorageService),
        presetsProvider.overrideWith((ref) async => []),
      ],
      child: const MaterialApp(home: Scaffold(body: LibraryScreen())),
    );
  }

  testWidgets('LibraryScreen renders correctly with tabs', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text('My Library'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
  });

  testWidgets('LibraryScreen shows favorite preset when it exists', (
    tester,
  ) async {
    final presets = [
      UserPreset(
        id: '1',
        userId: 'u1',
        name: 'Focus High',
        carrierFrequency: 220,
        beatFrequency: 14,
        createdAt: DateTime.now(),
      ),
    ];

    when(
      () => mockFavoritesRepository.getFavorites(),
    ).thenAnswer((_) async => presets);

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Focus High'), findsOneWidget);
  });
}
