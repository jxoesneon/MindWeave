import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/features/community/community_presets_controller.dart';
import 'package:mindweave/core/supabase/supabase_client_provider.dart';
import '../mocks.dart';

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockPostgrestQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;

  setUpAll(() {
    registerTestFallbacks();
  });

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockQueryBuilder = MockPostgrestQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();

    // Default Supabase stubs
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
    when(
      () => mockFilterBuilder.limit(any()),
    ).thenAnswer((_) => FakePostgrestBuilder<List<Map<String, dynamic>>>([]));
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [supabaseClientProvider.overrideWithValue(mockSupabaseClient)],
    );
  }

  test(
    'CommunityPresetsController builds with empty list when no public presets',
    () async {
      final container = createContainer();

      final result = await container.read(
        communityPresetsControllerProvider.future,
      );
      expect(result, isEmpty);
    },
  );

  test('CommunityPresetsController returns public presets correctly', () async {
    final presetsJson = [
      {
        'id': '1',
        'user_id': 'u1',
        'name': 'Chill',
        'carrier_frequency': 100.0,
        'beat_frequency': 4.0,
        'is_public': true,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    when(() => mockFilterBuilder.limit(any())).thenAnswer(
      (_) => FakePostgrestBuilder<List<Map<String, dynamic>>>(presetsJson),
    );

    final container = createContainer();
    final result = await container.read(
      communityPresetsControllerProvider.future,
    );

    expect(result.length, 1);
    expect(result[0].name, 'Chill');
  });
}
