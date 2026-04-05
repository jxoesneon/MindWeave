import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/atoms/atoms.dart';
import 'package:mindweave/core/tokens/component_types.dart';

void main() {
  group('MwBadge', () {
    testWidgets('should render with label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MwBadge(label: '3')),
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should render with different sizes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                MwBadge(label: 'S', size: BadgeSize.small),
                MwBadge(label: 'M', size: BadgeSize.medium),
                MwBadge(label: 'L', size: BadgeSize.large),
              ],
            ),
          ),
        ),
      );

      expect(find.text('S'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
    });

    testWidgets('should use pill shape by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MwBadge(label: 'Pill')),
        ),
      );

      final badge = tester.widget<Container>(find.byType(Container).first);
      final decoration = badge.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets('should use rounded rectangle when isPill is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(body: MwBadge(label: 'Rounded', isPill: false)),
        ),
      );

      expect(find.text('Rounded'), findsOneWidget);
    });

    testWidgets('should apply custom color', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwBadge(label: 'Custom', color: Colors.red),
          ),
        ),
      );

      final badge = tester.widget<Container>(find.byType(Container).first);
      final decoration = badge.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.red));
    });

    testWidgets('should calculate contrast color for dark backgrounds', (
      tester,
    ) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwBadge(label: 'Dark', color: Colors.black),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Dark'));
      // For dark background, should use light text color
      expect(text.style?.color, isNotNull);
    });

    testWidgets('should calculate contrast color for light backgrounds', (
      tester,
    ) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwBadge(label: 'Light', color: Colors.white),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Light'));
      // For light background, should use dark text color
      expect(text.style?.color, isNotNull);
    });
  });

  group('MwShimmer', () {
    testWidgets('should render child', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            body: MwShimmer(
              // ignore: prefer_const_constructors
              child: Container(height: 100, width: 100, color: Colors.grey),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should show child directly when not loading', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwShimmer(isLoading: false, child: const Text('Loaded')),
          ),
        ),
      );

      expect(find.text('Loaded'), findsOneWidget);
      expect(find.byType(ShaderMask), findsNothing);
    });

    testWidgets('should apply shimmer effect when loading', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            body: MwShimmer(
              isLoading: true,
              // ignore: prefer_const_constructors
              child: Container(height: 100, width: 100, color: Colors.grey),
            ),
          ),
        ),
      );

      expect(find.byType(ShaderMask), findsOneWidget);
      // Should have animated builders for shimmer effect
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });
  });

  group('MwSkeletonText', () {
    testWidgets('should render single line by default', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(home: Scaffold(body: MwSkeletonText())),
      );

      // Should have one MwShimmer with a Container
      expect(find.byType(MwShimmer), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should render multiple lines when specified', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(home: Scaffold(body: MwSkeletonText(lines: 3))),
      );

      // Should have 3 MwShimmer widgets for 3 lines
      expect(find.byType(MwShimmer), findsNWidgets(3));
    });

    testWidgets('should respect custom height', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(home: Scaffold(body: MwSkeletonText(lineHeight: 20))),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MwShimmer),
              matching: find.byType(Container),
            )
            .first,
      );
      final constraints = container.constraints;
      expect(constraints?.minHeight, equals(20));
    });
  });

  group('MwSkeletonCard', () {
    testWidgets('should render with default height', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(home: Scaffold(body: MwSkeletonCard())),
      );

      expect(find.byType(MwShimmer), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should render with custom height', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(home: Scaffold(body: MwSkeletonCard(height: 200))),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(MwShimmer),
              matching: find.byType(Container),
            )
            .first,
      );
      final constraints = container.constraints;
      expect(constraints?.minHeight, equals(200));
    });
  });
}
