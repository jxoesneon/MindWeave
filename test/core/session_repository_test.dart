import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/core/repository/session_repository.dart';
import 'package:mindweave/core/models/user_session.dart';
import '../mocks.dart';

void main() {
  late SessionRepositoryImpl repository;
  late MockSupabaseClient mockSupabase;
  late FakeGoTrueClient fakeAuth;
  late MockStorageService mockStorageService;
  late MockBox<Map> mockBox;

  setUp(() {
    registerTestFallbacks();

    mockSupabase = MockSupabaseClient();
    fakeAuth = FakeGoTrueClient();
    mockStorageService = MockStorageService();
    mockBox = MockBox<Map>();

    // Setup auth
    when(() => mockSupabase.auth).thenReturn(fakeAuth);

    // Setup storage service to return mock box
    when(
      () => mockStorageService.openBox<Map>(any()),
    ).thenAnswer((_) async => mockBox);
    when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
    when(() => mockBox.values).thenReturn([]);

    repository = SessionRepositoryImpl(
      supabase: mockSupabase,
      storageService: mockStorageService,
    );
  });

  group('SessionRepository Tests', () {
    test(
      'calculateCurrentStreak should correctly count consecutive days',
      () async {
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));
        final twoDaysAgo = today.subtract(const Duration(days: 2));

        // Create sessions for today, yesterday, and two days ago
        final sessions = [
          UserSession(
            id: '1',
            userId: 'user-1',
            presetId: 'preset-1',
            durationSeconds: 600,
            startedAt: today,
          ),
          UserSession(
            id: '2',
            userId: 'user-1',
            presetId: 'preset-1',
            durationSeconds: 600,
            startedAt: yesterday,
          ),
          UserSession(
            id: '3',
            userId: 'user-1',
            presetId: 'preset-1',
            durationSeconds: 600,
            startedAt: twoDaysAgo,
          ),
        ];

        // Mock box to return the sessions
        when(
          () => mockBox.values,
        ).thenReturn(sessions.map((s) => s.toJson()).toList());

        final streak = await repository.calculateCurrentStreak();
        expect(streak, 3);
      },
    );

    test(
      'saveSession should save to box and attempt Supabase upsert',
      () async {
        fakeAuth.currentUser = FakeUser();
        final session = UserSession(
          id: 'test-session',
          userId: 'user-1',
          presetId: 'preset-1',
          durationSeconds: 600,
          startedAt: DateTime.now(),
        );

        // Setup mock for box put
        when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

        await repository.saveSession(session);

        // Verify local save happened
        verify(() => mockBox.put(session.id, any())).called(1);
      },
    );

    test('getSessions should return sessions from storage', () async {
      final sessions = [
        UserSession(
          id: '1',
          userId: 'user-1',
          presetId: 'preset-1',
          durationSeconds: 600,
          startedAt: DateTime.now(),
        ),
      ];

      when(
        () => mockBox.values,
      ).thenReturn(sessions.map((s) => s.toJson()).toList());

      final result = await repository.getSessions();
      expect(result.length, 1);
      expect(result[0].id, '1');
    });

    test('saveSession should handle missing user gracefully', () async {
      fakeAuth.currentUser = null;
      final session = UserSession(
        id: 'test-session',
        userId: 'user-1',
        presetId: 'preset-1',
        durationSeconds: 600,
        startedAt: DateTime.now(),
      );

      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // Should not throw
      await repository.saveSession(session);

      // Verify local save happened even without user
      verify(() => mockBox.put(session.id, any())).called(1);
    });

    group('Streak Calculation edge cases', () {
      test('streak should be 0 if no sessions', () async {
        when(() => mockBox.values).thenReturn([]);

        final streak = await repository.calculateCurrentStreak();
        expect(streak, 0);
      });

      test('streak should be 1 if only session is today', () async {
        final today = DateTime.now();
        final sessions = [
          UserSession(
            id: '1',
            userId: 'user-1',
            presetId: 'preset-1',
            durationSeconds: 600,
            startedAt: today,
          ),
        ];

        when(
          () => mockBox.values,
        ).thenReturn(sessions.map((s) => s.toJson()).toList());

        final streak = await repository.calculateCurrentStreak();
        expect(streak, 1);
      });

      test('streak should be 0 if last session was 2 days ago', () async {
        final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
        final sessions = [
          UserSession(
            id: '1',
            userId: 'user-1',
            presetId: 'preset-1',
            durationSeconds: 600,
            startedAt: twoDaysAgo,
          ),
        ];

        when(
          () => mockBox.values,
        ).thenReturn(sessions.map((s) => s.toJson()).toList());

        final streak = await repository.calculateCurrentStreak();
        expect(streak, 0);
      });
    });
  });
}
