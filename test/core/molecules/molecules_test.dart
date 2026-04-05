import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/molecules/molecules.dart';
import 'package:mindweave/core/models/brainwave_preset.dart';

void main() {
  group('BandBadge', () {
    testWidgets('should render with band and frequency', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BandBadge(band: BrainwaveBand.theta, frequency: 6.0),
          ),
        ),
      );

      expect(find.text('Theta • 6.0 Hz'), findsOneWidget);
    });

    testWidgets('should render inactive state correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BandBadge(band: BrainwaveBand.delta, isActive: false),
          ),
        ),
      );

      expect(find.text('Delta'), findsOneWidget);
    });

    testWidgets('should handle tap when onTap provided', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BandBadge(
              band: BrainwaveBand.alpha,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(BandBadge));
      expect(tapped, isTrue);
    });
  });

  group('ListItem', () {
    testWidgets('should render with icon, title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ListItem(
              icon: Icons.waves,
              title: 'Deep Focus',
              subtitle: '40 Hz - Peak concentration',
            ),
          ),
        ),
      );

      expect(find.text('Deep Focus'), findsOneWidget);
      expect(find.text('40 Hz - Peak concentration'), findsOneWidget);
      expect(find.byIcon(Icons.waves), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListItem(
              icon: Icons.music_note,
              title: 'Test Item',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListItem));
      expect(tapped, isTrue);
    });

    testWidgets('should show trailing widget when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ListItem(
              icon: Icons.settings,
              title: 'Settings',
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });
  });

  group('StatCard', () {
    testWidgets('should render with label and value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Sessions',
              value: '42',
              icon: Icons.calendar_today,
            ),
          ),
        ),
      );

      expect(find.text('Sessions'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('should apply accent color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              label: 'Focus Time',
              value: '12h',
              icon: Icons.timer,
              accentColor: Colors.purple,
            ),
          ),
        ),
      );

      expect(find.byType(StatCard), findsOneWidget);
    });
  });
}
