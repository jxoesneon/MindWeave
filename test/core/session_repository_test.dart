import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/core/repository/session_repository.dart';
import 'package:mindweave/core/models/user_session.dart';
import '../mocks.dart';

void main() {
  group('SessionRepository Tests', () {
    late CustomMockSupabaseClient mockSupabase;
    late FakeGoTrueClient fakeAuth;
    late MockStorageService mockStorageService;
    late MockBox<Map> mockBox;
    late SessionRepositoryImpl repository;

    setUp(() {
      fakeAuth = FakeGoTrueClient();
      mockSupabase = CustomMockSupabaseClient(fakeAuth);
      mockStorageService = MockStorageService();
      mockBox = MockBox<Map>();
      registerTestFallbacks();

      // Default stubs
      when(() => mockSupabase.from(any())).thenReturn(MockPostgrestQueryBuilder());
      when(() => mockStorageService.openBox<Map>(any()))
          .thenAnswer((_) async => mockBox);

      repository = SessionRepositoryImpl(
        supabase: mockSupabase,
        storageService: mockStorageService,
      );
    });

    test(
      'calculateCurrentStreak should correctly count consecutive days',
      () async {
        final now = DateTime.now();
        final day1 = now;
        final day2 = now.subtract(const Duration(days: 1));
        final day3 = now.subtract(const Duration(days: 2));
        final day5 = now.subtract(const Duration(days: 4));

        final sessions = [
          UserSession(
            id: '1',
            userId: 'u1',
            presetId: 'p1',
            durationSeconds: 60,
            startedAt: day1,
          ),
          UserSession(
            id: '2',
            userId: 'u1',
            presetId: 'p1',
            durationSeconds: 60,
            startedAt: day2,
          ),
          UserSession(
            id: '3',
            userId: 'u1',
            presetId: 'p1',
            durationSeconds: 60,
            startedAt: day3,
          ),
          UserSession(
            id: '4',
            userId: 'u1',
            presetId: 'p1',
            durationSeconds: 60,
            startedAt: day5,
          ),
        ];

        // Mock getSessions to return our sessions
        // Since it's an implementation detail, we mock the Hive box values
        when(() => mockBox.values).thenReturn(sessions.map((s) => s.toJson()));

        // Mock Supabase to fail by making user unauthenticated
        fakeAuth.currentUser = null;

        final streak = await repository.calculateCurrentStreak();
        expect(streak, 3);
      },
    );

    test(
      'saveSession should save to box and attempt Supabase upsert',
      () async {
        final session = UserSession(
          id: '1',
          userId: 'u1',
          presetId: 'p1',
          durationSeconds: 60,
          startedAt: DateTime.now(),
        );

        when(() => mockBox.put(any(), any())).thenAnswer((_) async => {});

        fakeAuth.currentUser = FakeUser();

        final mockQueryBuilder = MockPostgrestQueryBuilder();
        when(
          () => mockSupabase.from(any()),
        ).thenAnswer((_) => mockQueryBuilder);
        when(() => mockQueryBuilder.upsert(any())).thenAnswer(
          (_) => FakePostgrestBuilder<List<Map<String, dynamic>>>([]),
        );

        await repository.saveSession(session);

        verify(() => mockBox.put(session.id, any())).called(1);
        verify(() => mockSupabase.from('user_sessions')).called(1);
      },
    );

    group('Streak Calculation edge cases', () {
      test('streak should be 0 if no sessions', () async {
        when(() => mockBox.values).thenReturn([]);
        final streak = await repository.calculateCurrentStreak();
        expect(streak, 0);
      });

      test('streak should be 1 if only session is today', () async {
        final session = UserSession(
          id: '1',
          userId: 'u1',
          presetId: 'p1',
          durationSeconds: 60,
          startedAt: DateTime.now(),
        );
        when(() => mockBox.values).thenReturn([session.toJson()]);
        final streak = await repository.calculateCurrentStreak();
        expect(streak, 1);
      });

      test('streak should be 0 if last session was 2 days ago', () async {
        final session = UserSession(
          id: '1',
          userId: 'u1',
          presetId: 'p1',
          durationSeconds: 60,
          startedAt: DateTime.now().subtract(const Duration(days: 2)),
        );
        when(() => mockBox.values).thenReturn([session.toJson()]);
        final streak = await repository.calculateCurrentStreak();
        expect(streak, 0);
      });
    });
  });
}
