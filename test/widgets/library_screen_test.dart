import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/features/favorites/library_screen.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:mindweave/core/services/session_history_service.dart';
import 'package:mindweave/core/services/analytics_service.dart';
import 'package:mindweave/core/repository/favorites_repository.dart';
import 'package:mindweave/core/models/user_preset.dart';
import '../mocks.dart';

void main() {
  late FakeAudioService fakeAudioService;
  late MockSessionHistoryService mockSessionHistoryService;
  late MockAnalyticsService mockAnalyticsService;
  late MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    registerTestFallbacks();

    fakeAudioService = FakeAudioService();
    mockSessionHistoryService = MockSessionHistoryService();
    mockAnalyticsService = MockAnalyticsService();
    mockFavoritesRepository = MockFavoritesRepository();

    setupMockSessionHistoryService(mockSessionHistoryService);
    setupMockAnalyticsService(mockAnalyticsService);
    setupMockFavoritesRepository(mockFavoritesRepository);
  });

  Widget createTestableWidget() {
    return ProviderScope(
      overrides: [
        audioServiceProvider.overrideWithValue(fakeAudioService),
        sessionHistoryServiceProvider.overrideWithValue(
          mockSessionHistoryService,
        ),
        analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
        favoritesRepositoryProvider.overrideWithValue(mockFavoritesRepository),
      ],
      child: const MaterialApp(home: Scaffold(body: LibraryScreen())),
    );
  }

  group('LibraryScreen Widget Tests', () {
    testWidgets('LibraryScreen renders correctly with tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      expect(find.byType(LibraryScreen), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
    }, skip: true);

    testWidgets('LibraryScreen shows My Library and Community tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      expect(find.text('My Library'), findsOneWidget);
      expect(find.text('Community'), findsOneWidget);
    }, skip: true);

    testWidgets('LibraryScreen has close button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      expect(find.byType(IconButton), findsWidgets);
    }, skip: true);

    testWidgets('LibraryScreen displays loading state initially', (
      WidgetTester tester,
    ) async {
      when(
        () => mockFavoritesRepository.getFavorites(),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      // Should show loading or empty state
      expect(find.byType(LibraryScreen), findsOneWidget);
    }, skip: true);

    testWidgets('LibraryScreen displays favorites when loaded', (
      WidgetTester tester,
    ) async {
      final presets = [
        UserPreset(
          id: 'test-1',
          userId: 'user-1',
          name: 'Test Preset 1',
          carrierFrequency: 200.0,
          beatFrequency: 10.0,
          createdAt: DateTime.now(),
        ),
      ];

      when(
        () => mockFavoritesRepository.getFavorites(),
      ).thenAnswer((_) async => presets);

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LibraryScreen), findsOneWidget);
    }, skip: true);

    testWidgets('LibraryScreen shows empty state when no favorites', (
      WidgetTester tester,
    ) async {
      when(
        () => mockFavoritesRepository.getFavorites(),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LibraryScreen), findsOneWidget);
    }, skip: true);

    testWidgets('LibraryScreen handles tab switching', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      // Tap on Community tab
      await tester.tap(find.text('Community'));
      await tester.pump();

      expect(find.byType(LibraryScreen), findsOneWidget);
    }, skip: true);

    testWidgets('LibraryScreen displays backdrop filter for glass effect', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      expect(find.byType(BackdropFilter), findsWidgets);
    }, skip: true);

    testWidgets('LibraryScreen displays drag handle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      // Look for the drag handle (small rectangle at top)
      expect(find.byType(Container), findsWidgets);
    }, skip: true);
  });
}
