import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mindweave/main.dart';
import 'package:mindweave/core/audio/audio_service_provider.dart';
import 'package:mindweave/core/supabase/supabase_client_provider.dart';
import 'package:mindweave/core/storage/storage_service.dart';
import 'mocks.dart';

void main() {
  setUpAll(() {
    registerTestFallbacks();
  });

  testWidgets('MindWeave smoke test', (WidgetTester tester) async {
    final mockAudioService = MockAudioService();
    final mockSupabaseClient = MockSupabaseClient();
    final mockStorageService = MockStorageService();

    // Stubbing basics
    when(() => mockAudioService.init()).thenAnswer((_) async => {});
    when(() => mockStorageService.get<int>(any(), any(), defaultValue: any(named: 'defaultValue')))
        .thenAnswer((_) async => 0);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
          supabaseClientProvider.overrideWithValue(mockSupabaseClient),
          storageServiceProvider.overrideWithValue(mockStorageService),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the title is present
    expect(find.text('MindWeave'), findsOneWidget);
  });
}
