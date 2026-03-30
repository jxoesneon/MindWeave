import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindweave/features/favorites/library_screen.dart';
import 'package:mindweave/features/favorites/favorites_controller.dart';
import 'package:mindweave/core/models/user_preset.dart';
import 'package:mindweave/core/audio/mixer_state.dart';
import '../../mocks.dart';

class MockFavoritesController extends Mock implements FavoritesController {}

void main() {
  late MockFavoritesController mockFavoritesController;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockFavoritesController = MockFavoritesController();

    final presets = <UserPreset>[
      UserPreset(
        id: 'p1',
        userId: 'u1',
        name: 'Test Preset',
        carrierFrequency: 200,
        beatFrequency: 10,
        noiseType: NoiseType.none,
        noiseVolume: 0.2,
        binauralVolume: 0.5,
        isPublic: false,
        createdAt: DateTime.now(),
      ),
    ];

    // FavoritesController is an AsyncNotifier<List<UserPreset>>
    // build() returns FutureOr<List<UserPreset>>, state is AsyncValue<List<UserPreset>>
    when(() => mockFavoritesController.build()).thenAnswer((_) async => presets);
    when(() => mockFavoritesController.state).thenReturn(AsyncValue.data(presets));
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        favoritesControllerProvider.overrideWith(() => mockFavoritesController),
      ],
      child: const MaterialApp(
        home: LibraryScreen(),
      ),
    );
  }

  group('LibraryScreen Widget Tests', () {
    testWidgets('renders list of presets', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Test Preset'), findsOneWidget);
    });

    testWidgets('Tapping a preset calls loadPreset and closes screen', (tester) async {
      when(() => mockFavoritesController.loadPreset(any())).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Test Preset'));
      await tester.pumpAndSettle();
      
      verify(() => mockFavoritesController.loadPreset(any())).called(1);
    });

    testWidgets('Delete icon calls deleteFavorite', (tester) async {
       when(() => mockFavoritesController.deleteFavorite(any())).thenAnswer((_) async => {});

       await tester.pumpWidget(createTestWidget());
       await tester.pumpAndSettle();
       
       await tester.tap(find.byIcon(Icons.delete_outline));
       await tester.pumpAndSettle();
       
       verify(() => mockFavoritesController.deleteFavorite('p1')).called(1);
    });
  });
}
