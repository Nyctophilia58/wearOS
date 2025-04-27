import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearos/models/color_options.dart'; // <-- change this to your file path

void main() {
  testWidgets('ColorOptionPage displays and selects colors correctly', (WidgetTester tester) async {
    Color? selectedColor;

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColorOptionPage(
            selectedColor: Colors.black,
            onColorSelected: (color) {
              selectedColor = color;
            },
          ),
        ),
      ),
    );

    // Find all GestureDetectors (each color option)
    final colorOptions = find.byType(GestureDetector);


    // There should be 5 color options
    expect(colorOptions, findsNWidgets(5));

    // Tap the second color (Red)
    await tester.tap(colorOptions.at(1));
    await tester.pumpAndSettle();

    // After tap, selectedColor should be Colors.red
    expect(selectedColor, equals(Colors.red));
  });
}
