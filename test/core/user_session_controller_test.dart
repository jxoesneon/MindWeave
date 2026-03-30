import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:audio_session/audio_session.dart';

import 'package:mindweave/core/supabase/supabase_client_provider.dart';
import 'package:mindweave/core/repository/session_repository.dart';
import 'package:mindweave/core/monetization/monetization_controller.dart';
import 'package:mindweave/features/streaks/streak_controller.dart';
import 'package:mindweave/core/audio/audio_controller.dart';
import 'package:mindweave/core/audio/audio_state.dart';
import '../mocks.dart';

// SoundHandle and AudioSource are extension types in flutter_soloud 2.0+
// and cannot be mocked by mocktail. Use constants for verification.
final dummySoundHandle = const SoundHandle(1);
// ignore: invalid_use_of_internal_member, prefer_const_constructors
final dummyAudioSource = AudioSource(const SoundHash(1));

class MockAudioSession extends Mock implements AudioSession {}

class MockMonetizationNotifier extends Mock implements MonetizationController {
  @override
  Future<void> recordSession(int durationSeconds) async => Future.value();
}

class MockStreakNotifier extends Mock implements StreakController {
  @override
  Future<void> refreshStreak() async => Future.value();
}

void main() {
  late CustomMockSupabaseClient mockSupabase;
  late FakeGoTrueClient fakeAuth;
  late MockUser mockUser;
  late MockSessionRepository mockSessionRepo;
  late MockMonetizationNotifier mockMonetization;
  late MockStreakNotifier mockStreak;
  late ProviderContainer container;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    fakeAuth = FakeGoTrueClient();
    mockSupabase = CustomMockSupabaseClient(fakeAuth);
    mockUser = MockUser();
    mockSessionRepo = MockSessionRepository();
    mockMonetization = MockMonetizationNotifier();
    mockStreak = MockStreakNotifier();

    // Setup Auth and and user
    fakeAuth.currentUser = mockUser;
    when(() => mockUser.id).thenReturn('u1');

    container = ProviderContainer(
      overrides: [
        supabaseClientProvider.overrideWithValue(mockSupabase),
        sessionRepositoryProvider.overrideWithValue(mockSessionRepo),
        monetizationControllerProvider.overrideWith(() => mockMonetization),
        streakControllerProvider.overrideWith(() => mockStreak),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('UserSessionController', () {
    test('Records a session when audio stops after 10+ seconds', () async {
      container.read(audioControllerProvider.notifier).state = const AudioState(
        isPlaying: true,
        volume: 0.5,
        carrierFrequency: 200,
        beatFrequency: 10,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      container.read(audioControllerProvider.notifier).state = const AudioState(
        isPlaying: false,
        volume: 0.5,
        carrierFrequency: 200,
        beatFrequency: 10,
      );
    });

    test('Does not record session if shorter than 10 seconds', () async {
      container.read(audioControllerProvider.notifier).state = const AudioState(
        isPlaying: true,
        volume: 0.5,
        carrierFrequency: 200,
        beatFrequency: 10,
      );
      container.read(audioControllerProvider.notifier).state = const AudioState(
        isPlaying: false,
        volume: 0.5,
        carrierFrequency: 200,
        beatFrequency: 10,
      );

      verifyNever(() => mockSessionRepo.saveSession(any()));
    });
  });
}
