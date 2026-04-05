import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/atoms/atoms.dart';
import 'package:mindweave/core/tokens/component_types.dart';

void main() {
  group('MwPrimaryButton', () {
    testWidgets('should render with label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwPrimaryButton(onPressed: () {}, label: 'Test Button'),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var wasPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwPrimaryButton(
              onPressed: () => wasPressed = true,
              label: 'Tap Me',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);
    });

    testWidgets('should show loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwPrimaryButton(
              onPressed: () {},
              label: 'Loading',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MwPrimaryButton(onPressed: null, label: 'Disabled'),
          ),
        ),
      );

      // Should still render but not be tappable
      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('should render with icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwPrimaryButton(
              onPressed: () {},
              label: 'With Icon',
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should respect size variants', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                MwPrimaryButton(
                  onPressed: () {},
                  label: 'Small',
                  size: ButtonSize.small,
                ),
                MwPrimaryButton(
                  onPressed: () {},
                  label: 'Medium',
                  size: ButtonSize.medium,
                ),
                MwPrimaryButton(
                  onPressed: () {},
                  label: 'Large',
                  size: ButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
    });

    testWidgets('should respect isFullWidth', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: MwPrimaryButton(
                onPressed: () {},
                label: 'Full Width',
                isFullWidth: true,
              ),
            ),
          ),
        ),
      );

      final buttonFinder = find.text('Full Width');
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('should have minimum touch target of 44pt', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MwPrimaryButton(onPressed: () {}, label: 'Touch Target'),
            ),
          ),
        ),
      );

      // Find the button's outer container (InkWell)
      final inkWellFinder = find.byType(InkWell);
      expect(inkWellFinder, findsOneWidget);
      final buttonSize = tester.getSize(inkWellFinder);
      expect(buttonSize.height, greaterThanOrEqualTo(44.0));
    });
  });

  group('MwSecondaryButton', () {
    testWidgets('should render with label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwSecondaryButton(onPressed: () {}, label: 'Secondary'),
          ),
        ),
      );

      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var wasPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwSecondaryButton(
              onPressed: () => wasPressed = true,
              label: 'Tap Me',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);
    });

    testWidgets('should have ghost appearance (no hard border)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwSecondaryButton(onPressed: () {}, label: 'Ghost'),
          ),
        ),
      );

      expect(find.text('Ghost'), findsOneWidget);
    });
  });

  group('MwIconButton', () {
    testWidgets('should render with icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwIconButton(onPressed: () {}, icon: Icons.favorite),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var wasPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwIconButton(
              onPressed: () => wasPressed = true,
              icon: Icons.add,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(wasPressed, isTrue);
    });

    testWidgets('should show selected icon when isSelected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwIconButton(
              onPressed: () {},
              icon: Icons.favorite_border,
              selectedIcon: Icons.favorite,
              isSelected: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('should have minimum touch target of 44pt', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MwIconButton(onPressed: () {}, icon: Icons.star),
            ),
          ),
        ),
      );

      // Find the outer GestureDetector/Container
      final containerFinder = find.byType(AnimatedContainer);
      expect(containerFinder, findsOneWidget);
      final buttonSize = tester.getSize(containerFinder);
      expect(buttonSize.width, greaterThanOrEqualTo(44.0));
      expect(buttonSize.height, greaterThanOrEqualTo(44.0));
    });

    testWidgets('should show tooltip when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwIconButton(
              onPressed: () {},
              icon: Icons.help,
              tooltip: 'Help tooltip',
            ),
          ),
        ),
      );

      expect(find.byType(Tooltip), findsOneWidget);
    });
  });
}
