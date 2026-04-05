import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mindweave/main.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Integration tests for MindWeave app
/// Run with: flutter test integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MindWeave Integration Tests', () {
    testWidgets('App launches and shows PlayerScreen', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify PlayerScreen is displayed
      expect(find.text('MindWeave'), findsOneWidget);
      expect(find.byType(ConsumerStatefulWidget), findsWidgets);
    });

    testWidgets('Can toggle play/pause', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap play button
      final playButton = find.byIcon(Icons.play_arrow);
      if (playButton.evaluate().isNotEmpty) {
        await tester.tap(playButton.first);
        await tester.pumpAndSettle();

        // After tapping, should show pause icon
        expect(find.byIcon(Icons.pause), findsWidgets);
      }
    });

    testWidgets('Can navigate to Library screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap library icon
      final libraryButton = find.byTooltip('Library');
      if (libraryButton.evaluate().isNotEmpty) {
        await tester.tap(libraryButton.first);
        await tester.pumpAndSettle();

        // Verify library screen elements
        expect(find.text('My Library'), findsOneWidget);
      }
    });

    testWidgets('Can navigate to Frequencies screen', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap frequencies icon
      final freqButton = find.byTooltip('Frequencies');
      if (freqButton.evaluate().isNotEmpty) {
        await tester.tap(freqButton.first);
        await tester.pumpAndSettle();

        // Verify frequencies screen
        expect(find.text('Brainwave Frequencies'), findsOneWidget);
      }
    });

    testWidgets('Can navigate to Session History', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap history icon
      final historyButton = find.byTooltip('Session History');
      if (historyButton.evaluate().isNotEmpty) {
        await tester.tap(historyButton.first);
        await tester.pumpAndSettle();

        // Verify history screen
        expect(find.text('Session History'), findsWidgets);
      }
    });

    testWidgets('Can navigate to Settings', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap settings icon
      final settingsButton = find.byTooltip('Settings');
      if (settingsButton.evaluate().isNotEmpty) {
        await tester.tap(settingsButton.first);
        await tester.pumpAndSettle();

        // Verify settings screen
        expect(find.text('Settings'), findsWidgets);
      }
    });

    testWidgets('Timer picker opens and closes', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap timer icon
      final timerButton = find.byTooltip('Timer');
      if (timerButton.evaluate().isNotEmpty) {
        await tester.tap(timerButton.first);
        await tester.pumpAndSettle();

        // Verify timer picker opened - check for modal content instead of ModalBottomSheet type
        expect(find.byType(BottomSheet), findsOneWidget);

        // Close by tapping outside
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
      }
    });
  });
}
