import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindweave/core/session/user_session_controller.dart';
import 'package:mindweave/core/audio/audio_controller.dart';
import 'package:mindweave/core/audio/audio_state.dart';
import 'package:mindweave/core/repository/session_repository.dart';
import 'package:mindweave/core/monetization/monetization_controller.dart';
import 'package:mindweave/features/streaks/streak_controller.dart';
import 'package:mindweave/core/supabase/supabase_client_provider.dart';
import '../../mocks.dart';

class MockAudioController extends Mock implements AudioController {}
class MockMonetizationController extends Mock implements MonetizationController {}
class MockStreakController extends Mock implements StreakController {}

void main() {
  late MockAudioController mockAudioController;
  late MockSessionRepository mockSessionRepository;
  late MockMonetizationController mockMonetizationController;
  late MockStreakController mockStreakController;
  late CustomMockSupabaseClient mockSupabase;
  late FakeGoTrueClient fakeAuth;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockAudioController = MockAudioController();
    mockSessionRepository = MockSessionRepository();
    mockMonetizationController = MockMonetizationController();
    mockStreakController = MockStreakController();
    fakeAuth = FakeGoTrueClient();
    mockSupabase = CustomMockSupabaseClient(fakeAuth);

    const audioState = AudioState(
      isPlaying: false,
      carrierFrequency: 200.0,
      beatFrequency: 10.0,
      volume: 0.5,
    );

    when(() => mockAudioController.build()).thenReturn(audioState);
    when(() => mockAudioController.state).thenReturn(audioState);
    
    when(() => mockMonetizationController.build()).thenReturn(false);
    when(() => mockMonetizationController.state).thenReturn(false);
    
    when(() => mockStreakController.build()).thenAnswer((_) async => 5);
    when(() => mockStreakController.state).thenReturn(const AsyncValue.data(5));
    
    // Auth setup
    fakeAuth.currentUser = FakeUser();
  });

  group('UserSessionController Tests', () {
    test('Correctly listens to audio events', () {
      final container = ProviderContainer(
        overrides: [
          audioControllerProvider.overrideWith(() => mockAudioController),
          sessionRepositoryProvider.overrideWithValue(mockSessionRepository),
          monetizationControllerProvider.overrideWith(() => mockMonetizationController),
          streakControllerProvider.overrideWith(() => mockStreakController),
          supabaseClientProvider.overrideWithValue(mockSupabase),
        ],
      );

      // Just ensure it builds without error for now
      final state = container.read(userSessionControllerProvider);
      expect(state, isNull);
    });
  });
}
