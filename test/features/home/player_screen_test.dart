import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindweave/features/home/player_screen.dart';
import 'package:mindweave/core/audio/audio_controller.dart';
import 'package:mindweave/core/audio/mixer_controller.dart';
import 'package:mindweave/core/audio/audio_state.dart';
import 'package:mindweave/core/audio/mixer_state.dart';
import 'package:mindweave/core/models/presets_provider.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';
import 'package:mindweave/core/monetization/monetization_controller.dart';
import 'package:mindweave/features/health/health_controller.dart';
import 'package:mindweave/features/streaks/streak_controller.dart';
import 'package:mindweave/core/session/user_session_controller.dart';
import 'package:mindweave/features/favorites/favorites_controller.dart';
import '../../mocks.dart';

class MockAudioController extends Mock implements AudioController {}
class MockMixerController extends Mock implements MixerController {}
class MockHealthController extends Mock implements HealthController {}
class MockStreakController extends Mock implements StreakController {}
class MockMonetizationController extends Mock implements MonetizationController {}
class MockUserSessionController extends Mock implements UserSessionController {}
class MockFavoritesController extends Mock implements FavoritesController {}

void main() {
  late MockAudioController mockAudioController;
  late MockMixerController mockMixerController;
  late MockHealthController mockHealthController;
  late MockStreakController mockStreakController;
  late MockMonetizationController mockMonetizationController;
  late MockUserSessionController mockUserSessionController;
  late MockFavoritesController mockFavoritesController;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockAudioController = MockAudioController();
    mockMixerController = MockMixerController();
    mockHealthController = MockHealthController();
    mockStreakController = MockStreakController();
    mockMonetizationController = MockMonetizationController();
    mockUserSessionController = MockUserSessionController();
    mockFavoritesController = MockFavoritesController();

    const audioState = AudioState(
      isPlaying: false,
      carrierFrequency: 200.0,
      beatFrequency: 10.0,
      volume: 0.5,
    );
    const mixerState = MixerState(backgroundVolume: 0.2, noiseType: NoiseType.none);

    when(() => mockAudioController.state).thenReturn(audioState);
    when(() => mockAudioController.build()).thenReturn(audioState);
    
    when(() => mockMixerController.state).thenReturn(mixerState);
    when(() => mockMixerController.build()).thenReturn(mixerState);
    
    when(() => mockHealthController.build()).thenAnswer((_) async => null);
    when(() => mockHealthController.state).thenReturn(const AsyncValue.data(null));
    
    when(() => mockStreakController.build()).thenAnswer((_) async => 5);
    when(() => mockStreakController.state).thenReturn(const AsyncValue.data(5));
    
    when(() => mockMonetizationController.state).thenReturn(false);
    when(() => mockMonetizationController.build()).thenReturn(false);

    when(() => mockUserSessionController.build()).thenReturn(null);
    
    when(() => mockFavoritesController.build()).thenAnswer((_) async => []);
    when(() => mockFavoritesController.state).thenReturn(const AsyncValue.data([]));
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        audioControllerProvider.overrideWith(() => mockAudioController),
        mixerControllerProvider.overrideWith(() => mockMixerController),
        monetizationControllerProvider.overrideWith(() => mockMonetizationController),
        presetsProvider.overrideWith((ref) => Future.value(<BrainwavePreset>[])),
        healthControllerProvider.overrideWith(() => mockHealthController),
        streakControllerProvider.overrideWith(() => mockStreakController),
        userSessionControllerProvider.overrideWith(() => mockUserSessionController),
        favoritesControllerProvider.overrideWith(() => mockFavoritesController),
      ],
      child: const MaterialApp(
        home: PlayerScreen(),
      ),
    );
  }

  group('PlayerScreen Widget Tests', () {
    testWidgets('renders MindWeave header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('MindWeave'), findsWidgets);
    });

    testWidgets('Play button calls togglePlay', (tester) async {
      when(() => mockAudioController.togglePlay()).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      
      final playButton = find.byIcon(Icons.play_arrow_rounded);
      await tester.tap(playButton);
      await tester.pump();
      
      verify(() => mockAudioController.togglePlay()).called(1);
    });
  });
}
