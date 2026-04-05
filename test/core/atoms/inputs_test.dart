import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindweave/core/atoms/atoms.dart';

void main() {
  group('MwTextField', () {
    testWidgets('should render with label', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTextField(label: 'Email', hint: 'Enter your email'),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('should accept text input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTextField(label: 'Name', controller: controller),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'John Doe');
      expect(controller.text, equals('John Doe'));
    });

    testWidgets('should show error text when provided', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTextField(
              label: 'Password',
              errorText: 'Password is required',
            ),
          ),
        ),
      );

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should show helper text when provided', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTextField(
              label: 'Username',
              helperText: 'At least 3 characters',
            ),
          ),
        ),
      );

      expect(find.text('At least 3 characters'), findsOneWidget);
    });

    testWidgets('should render prefix icon when provided', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTextField(label: 'Search', prefixIcon: Icons.search),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should render suffix icon when provided', (tester) async {
      var wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwTextField(
              label: 'Password',
              suffixIcon: Icons.visibility,
              onSuffixTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });

    testWidgets('should obscure text when obscureText is true', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTextField(label: 'Password', obscureText: true),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      var changedText = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwTextField(
              label: 'Input',
              onChanged: (value) => changedText = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test');
      expect(changedText, equals('test'));
    });

    testWidgets('should call onSubmitted when submitted', (tester) async {
      var submittedText = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwTextField(
              label: 'Input',
              onSubmitted: (value) => submittedText = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'submit me');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submittedText, equals('submit me'));
    });

    testWidgets('should respect keyboardType', (tester) async {
      await tester.pumpWidget(
        // ignore: prefer_const_constructors
        MaterialApp(
          // ignore: prefer_const_constructors
          home: Scaffold(
            // ignore: prefer_const_constructors
            body: MwTextField(
              label: 'Number',
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, equals(TextInputType.number));
    });
  });

  group('MwSlider', () {
    testWidgets('should render with value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MwSlider(value: 0.5, onChanged: (value) {})),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('should call onChanged when value changes', (tester) async {
      double changedValue = 0.5;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwSlider(
              value: changedValue,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      // Verify the slider is rendered and onChanged callback is wired
      expect(find.byType(Slider), findsOneWidget);

      // Verify initial value is passed correctly
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, equals(0.5));
      expect(slider.onChanged, isNotNull);
    });

    testWidgets('should show label when provided with showLabels', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwSlider(
              value: 0.75,
              onChanged: (value) {},
              label: 'Volume',
              showLabels: true,
            ),
          ),
        ),
      );

      expect(find.text('Volume'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('should respect min and max values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwSlider(value: 50, min: 0, max: 100, onChanged: (value) {}),
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, equals(0));
      expect(slider.max, equals(100));
    });

    testWidgets('should respect divisions when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MwSlider(value: 0.5, divisions: 10, onChanged: (value) {}),
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.divisions, equals(10));
    });
  });
}
