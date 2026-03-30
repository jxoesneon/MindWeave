import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/features/home/player_screen.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:mindweave/core/supabase/supabase_client_provider.dart';
import 'package:mindweave/core/storage/storage_service.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:mindweave/core/repository/session_repository.dart';
import 'package:mindweave/core/models/presets_provider.dart';
import '../mocks.dart';

void main() {
  late MockAudioService mockAudioService;
  late MockSupabaseClient mockSupabaseClient;
  late MockStorageService mockStorageService;
  late MockFavoritesRepository mockFavoritesRepository;
  late MockSessionRepository mockSessionRepository;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockAudioService = MockAudioService();
    mockSupabaseClient = MockSupabaseClient();
    mockStorageService = MockStorageService();
    mockFavoritesRepository = MockFavoritesRepository();
    mockSessionRepository = MockSessionRepository();

    // Mocking essential methods
    when(() => mockAudioService.init()).thenAnswer((_) async => {});
    when(() => mockAudioService.stop()).thenAnswer((_) async => {});
    when(() => mockAudioService.setVolume(any())).thenReturn(null);
    when(
      () => mockStorageService.get<int>(
        any(),
        any(),
        defaultValue: any(named: 'defaultValue'),
      ),
    ).thenAnswer((_) async => 0);
    when(
      () => mockFavoritesRepository.getFavorites(),
    ).thenAnswer((_) async => []);
    when(() => mockSessionRepository.getSessions()).thenAnswer((_) async => []);

    // Auth stubbing
    final mockAuth = MockGoTrueClient();
    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(null);

    // Supabase stubs for queries
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

  Widget createPlayerScreen() {
    return ProviderScope(
      overrides: [
        audioServiceProvider.overrideWithValue(mockAudioService),
        supabaseClientProvider.overrideWithValue(mockSupabaseClient),
        storageServiceProvider.overrideWithValue(mockStorageService),
        favoritesRepositoryProvider.overrideWithValue(mockFavoritesRepository),
        sessionRepositoryProvider.overrideWithValue(mockSessionRepository),
        presetsProvider.overrideWith((ref) async => []),
      ],
      child: const MaterialApp(home: PlayerScreen()),
    );
  }

  testWidgets('PlayerScreen renders correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createPlayerScreen());
    await tester.pump();

    expect(find.text('MindWeave'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });

  testWidgets('Tapping play toggles audio state', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    when(
      () => mockAudioService.startBinaural(
        leftFreq: any(named: 'leftFreq'),
        rightFreq: any(named: 'rightFreq'),
        volume: any(named: 'volume'),
      ),
    ).thenAnswer((_) async => {});

    await tester.pumpWidget(createPlayerScreen());
    await tester.pump();

    final playButton = find.byIcon(Icons.play_arrow_rounded);
    await tester.tap(playButton);
    await tester.pump();

    verify(
      () => mockAudioService.startBinaural(
        leftFreq: any(named: 'leftFreq'),
        rightFreq: any(named: 'rightFreq'),
        volume: any(named: 'volume'),
      ),
    ).called(1);

    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
  });
}
