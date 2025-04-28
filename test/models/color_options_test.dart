import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearos/models/color_options.dart'; // Make sure this path is correct

void main() {
  testWidgets('ColorOptionPage displays colors and handles selection', (WidgetTester tester) async {
    // Test variables
    Color? selectedColor;

    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColorOptionPage(
            selectedColor: Colors.black,
            isLeftSide: true,
            onColorSelected: (color) {
              selectedColor = color;
            },
          ),
        ),
      ),
    );

    // Verify that all color options exist
    expect(find.byType(GestureDetector), findsNWidgets(6)); // 6 colors

    // Tap on the third color (green)
    final greenOption = find.byWidgetPredicate((widget) {
      return widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == Colors.green;
    });

    expect(greenOption, findsOneWidget);

    await tester.tap(greenOption);
    await tester.pumpAndSettle();

    // Verify that the callback was triggered and selectedColor is green
    expect(selectedColor, Colors.green);
  });
}
