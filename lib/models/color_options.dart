import 'dart:math';

import 'package:flutter/material.dart';

class ColorOptionPage extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Color selectedColor;
  final bool isLeftSide;

  const ColorOptionPage({
    super.key,
    required this.onColorSelected,
    required this.selectedColor,
    required this.isLeftSide,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildColorOption(Colors.black, 0),
          _buildColorOption(Colors.red, 1),
          _buildColorOption(Colors.green, 2),
          _buildColorOption(Colors.blue, 3),
          _buildColorOption(Colors.yellow, 4),
          _buildColorOption(Colors.purple, 5),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, int index) {
    bool isSelected = color.value == selectedColor.value;

    double radius = 20; // control how big the curve is
    double angleStep = 20; // degree between each dot
    double startAngle = -50; // starting angle to center curve nicely

    // Calculate actual angle for this index
    double angle = (startAngle + index * angleStep) * (3.1415926 / 180); // convert to radians

    // Determine x and y offset to make it a curve
    double dx = radius * (isLeftSide ? -1 : 1) * (1 - cos(angle));
    double dy = radius * sin(angle);

    return Transform.translate(
      offset: Offset(dx, dy),
      child: GestureDetector(
        onTap: () => onColorSelected(color),
        child: Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: isSelected ? 2 : 0.5,
            ),
          ),
        ),
      ),
    );
  }

}