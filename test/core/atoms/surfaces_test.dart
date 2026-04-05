import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/atoms/atoms.dart';
import 'package:mindweave/core/tokens/component_types.dart';

void main() {
  group('MwGlassContainer', () {
    testWidgets('should render child', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwGlassContainer(child: const Text('Glass Content')),
          ),
        ),
      );

      expect(find.text('Glass Content'), findsOneWidget);
    });

    testWidgets('should apply padding when provided', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwGlassContainer(
              padding: const EdgeInsets.all(20),
              child: const Text('Padded'),
            ),
          ),
        ),
      );

      expect(find.text('Padded'), findsOneWidget);
    });

    testWidgets('should apply margin when provided', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwGlassContainer(
              margin: const EdgeInsets.all(10),
              child: const Text('With Margin'),
            ),
          ),
        ),
      );

      expect(find.text('With Margin'), findsOneWidget);
    });

    testWidgets('should use ClipRRect for rounded corners', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(body: MwGlassContainer(child: const Text('Rounded'))),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });

  group('MwTonalContainer', () {
    testWidgets('should render child', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTonalContainer(child: const Text('Tonal Content')),
          ),
        ),
      );

      expect(find.text('Tonal Content'), findsOneWidget);
    });

    testWidgets('should use surfaceContainer as default tonal level', (
      tester,
    ) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTonalContainer(child: const SizedBox.shrink()),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(TonalLevel.surfaceContainer.color));
    });

    testWidgets('should apply different tonal levels', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                // ignore: prefer_const_constructors
                MwTonalContainer(
                  tonalLevel: TonalLevel.surfaceContainerLowest,
                  child: const Text('Lowest'),
                ),
                // ignore: prefer_const_constructors
                MwTonalContainer(
                  tonalLevel: TonalLevel.surfaceContainerLow,
                  child: const Text('Low'),
                ),
                // ignore: prefer_const_constructors
                MwTonalContainer(
                  tonalLevel: TonalLevel.surfaceContainer,
                  child: const Text('Default'),
                ),
                // ignore: prefer_const_constructors
                MwTonalContainer(
                  tonalLevel: TonalLevel.surfaceContainerHigh,
                  child: const Text('High'),
                ),
                // ignore: prefer_const_constructors
                MwTonalContainer(
                  tonalLevel: TonalLevel.surfaceContainerHighest,
                  child: const Text('Highest'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Lowest'), findsOneWidget);
      expect(find.text('Low'), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
      expect(find.text('Highest'), findsOneWidget);
    });

    testWidgets('should apply padding when provided', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTonalContainer(
              padding: const EdgeInsets.all(16),
              child: const Text('Padded'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, equals(const EdgeInsets.all(16)));
    });

    testWidgets('should apply margin when provided', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTonalContainer(
              margin: const EdgeInsets.all(8),
              child: const Text('With Margin'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.margin, equals(const EdgeInsets.all(8)));
    });
  });

  group('MwChip', () {
    testWidgets('should render with label', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(body: MwChip(label: 'Tag')),
        ),
      );

      expect(find.text('Tag'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      var wasTapped = false;
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwChip(label: 'Clickable', onTap: () => wasTapped = true),
          ),
        ),
      );

      await tester.tap(find.text('Clickable'));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });

    testWidgets('should show checkmark when selected', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(body: MwChip(label: 'Selected', isSelected: true)),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should show icon when provided and not selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwChip(label: 'With Icon', icon: Icons.tag),
          ),
        ),
      );

      expect(find.byIcon(Icons.tag), findsOneWidget);
    });

    testWidgets('should prioritize checkmark over icon when selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwChip(label: 'Priority', isSelected: true, icon: Icons.tag),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.tag), findsNothing);
    });

    testWidgets('should have pill shape by default', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(body: MwChip(label: 'Pill')),
        ),
      );

      // Chip uses InkWell with fullCircular border radius
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
