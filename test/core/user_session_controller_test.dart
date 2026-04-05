import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindweave/core/audio/audio_controller.dart';
import 'package:mindweave/core/audio/audio_state.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';
import 'package:mindweave/core/models/user_session.dart';
import 'package:mindweave/core/repository/session_repository.dart';
import 'package:mindweave/core/monetization/monetization_controller.dart';
import 'package:mindweave/features/streaks/streak_controller.dart';
import 'package:mindweave/core/supabase/supabase_client_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../mocks.dart';

// Mock classes for dependencies
class MockSessionRepository extends Mock implements SessionRepositoryImpl {}

class MockMonetizationController extends MonetizationController {
  final void Function(int)? onRecordSession;

  MockMonetizationController({this.onRecordSession});

  @override
  bool build() {
    return false;
  }

  @override
  Future<void> recordSession(int durationSeconds) async {
    onRecordSession?.call(durationSeconds);
  }
}

class MockStreakController extends StreakController {
  final void Function()? onRefresh;

  MockStreakController({this.onRefresh});

  @override
  int build() {
    return 0;
  }

  @override
  Future<void> refreshStreak() async {
    onRefresh?.call();
  }
}

void main() {
  late ProviderContainer container;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late MockSessionRepository mockSessionRepository;
  late MockMonetizationController mockMonetizationController;
  late MockStreakController mockStreakController;

  setUpAll(() {
    registerTestFallbacks();
    // Register UserSession fallback for any() matcher
    registerFallbackValue(
      UserSession(
        id: 'test-id',
        userId: 'test-user',
        presetId: 'test-preset',
        durationSeconds: 60,
        startedAt: DateTime.now(),
        endedAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockSessionRepository = MockSessionRepository();
    mockMonetizationController = MockMonetizationController();
    mockStreakController = MockStreakController();

    // Setup auth mock
    when(() => mockSupabase.auth).thenReturn(mockAuth);

    container = ProviderContainer(
      overrides: [
        supabaseClientProvider.overrideWithValue(mockSupabase),
        sessionRepositoryProvider.overrideWithValue(mockSessionRepository),
        monetizationControllerProvider.overrideWith(
          () => mockMonetizationController,
        ),
        streakControllerProvider.overrideWith(() => mockStreakController),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('UserSessionController', () {
    test('Records a session when audio stops after 10+ seconds', () async {
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
        () => mockSessionRepository.saveSession(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockMonetizationController.recordSession(any()),
      ).thenAnswer((_) async {});
      when(() => mockStreakController.refreshStreak()).thenAnswer((_) async {});

      // Create audio state changes to simulate play then stop
      final preset = const BrainwavePreset(
        id: 'alpha',
        name: 'Alpha',
        band: BrainwaveBand.alpha,
        beatFrequency: 10.0,
        defaultCarrierFrequency: 200.0,
        description: 'Test preset',
        iconPath: 'assets/icons/test.png',
        accentColorValue: 0xFF000000,
      );

      // Simulate starting playback
      container.read(audioControllerProvider.notifier).state = AudioState(
        isPlaying: true,
        selectedPreset: preset,
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        volume: 0.8,
        timerDuration: null,
        remainingTime: null,
      );

      // Wait for session to be long enough (11 seconds)
      await Future.delayed(const Duration(seconds: 11));

      // Simulate stopping playback
      container.read(audioControllerProvider.notifier).state = AudioState(
        isPlaying: false,
        selectedPreset: preset,
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        volume: 0.8,
        timerDuration: null,
        remainingTime: null,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - verify session was saved
      verify(() => mockSessionRepository.saveSession(any())).called(1);
      verify(() => mockMonetizationController.recordSession(any())).called(1);
      verify(() => mockStreakController.refreshStreak()).called(1);
    });

    test('Does not record session if shorter than 10 seconds', () async {
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

      final preset = const BrainwavePreset(
        id: 'alpha',
        name: 'Alpha',
        band: BrainwaveBand.alpha,
        beatFrequency: 10.0,
        defaultCarrierFrequency: 200.0,
        description: 'Test preset',
        iconPath: 'assets/icons/test.png',
        accentColorValue: 0xFF000000,
      );

      // Simulate starting playback
      container.read(audioControllerProvider.notifier).state = AudioState(
        isPlaying: true,
        selectedPreset: preset,
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        volume: 0.8,
        timerDuration: null,
        remainingTime: null,
      );

      // Stop quickly (less than 10 seconds)
      await Future.delayed(const Duration(seconds: 5));

      // Simulate stopping playback
      container.read(audioControllerProvider.notifier).state = AudioState(
        isPlaying: false,
        selectedPreset: preset,
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        volume: 0.8,
        timerDuration: null,
        remainingTime: null,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - verify session was NOT saved (too short)
      verifyNever(() => mockSessionRepository.saveSession(any()));
    });

    test('Does not record session when user is not logged in', () async {
      // Arrange: No authenticated user
      when(() => mockAuth.currentUser).thenReturn(null);

      final preset = const BrainwavePreset(
        id: 'alpha',
        name: 'Alpha',
        band: BrainwaveBand.alpha,
        beatFrequency: 10.0,
        defaultCarrierFrequency: 200.0,
        description: 'Test preset',
        iconPath: 'assets/icons/test.png',
        accentColorValue: 0xFF000000,
      );

      // Simulate starting playback
      container.read(audioControllerProvider.notifier).state = AudioState(
        isPlaying: true,
        selectedPreset: preset,
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        volume: 0.8,
        timerDuration: null,
        remainingTime: null,
      );

      // Wait for session to be long enough
      await Future.delayed(const Duration(seconds: 11));

      // Simulate stopping playback
      container.read(audioControllerProvider.notifier).state = AudioState(
        isPlaying: false,
        selectedPreset: preset,
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        volume: 0.8,
        timerDuration: null,
        remainingTime: null,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - verify session was NOT saved (no user)
      verifyNever(() => mockSessionRepository.saveSession(any()));
    });

    test('Handles session recording errors gracefully', () async {
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
        () => mockSessionRepository.saveSession(any()),
      ).thenThrow(Exception('Save failed'));
      when(
        () => mockMonetizationController.recordSession(any()),
      ).thenAnswer((_) async {});
      when(() => mockStreakController.refreshStreak()).thenAnswer((_) async {});

      final preset = const BrainwavePreset(
        id: 'alpha',
        name: 'Alpha',
        band: BrainwaveBand.alpha,
        beatFrequency: 10.0,
        defaultCarrierFrequency: 200.0,
        description: 'Test preset',
        iconPath: 'assets/icons/test.png',
        accentColorValue: 0xFF000000,
      );

      // Simulate starting playback
      container.read(audioControllerProvider.notifier).state = AudioState(
        isPlaying: true,
        selectedPreset: preset,
        carrierFrequency: 200.0,
        beatFrequency: 10.0,
        volume: 0.8,
        timerDuration: null,
        remainingTime: null,
      );

      // Wait for session to be long enough
      await Future.delayed(const Duration(seconds: 11));

      // Simulate stopping playback - should not throw despite error
      expect(() async {
        container.read(audioControllerProvider.notifier).state = AudioState(
          isPlaying: false,
          selectedPreset: preset,
          carrierFrequency: 200.0,
          beatFrequency: 10.0,
          volume: 0.8,
          timerDuration: null,
          remainingTime: null,
        );
        await Future.delayed(const Duration(milliseconds: 100));
      }, returnsNormally);
    });
  });
}
