import 'dart:math';

import 'package:flutter/material.dart';

class ColorOptionPage extends StatelessWidget {
  static const double _dotSize = 10;
  static const double _curveRadius = 20; // Increase the curve radius to move the colors closer to the boundary
  static const double _angleStep = 14;
  static const double _startAngle = -35;
  static const double _selectedBorderWidth = 2;
  static const double _unselectedBorderWidth = 0.5;

  final Function(Color) onColorSelected;
  final Color selectedColor;
  final bool isLeftSide;
  final List<Color> colorOptions;

  const ColorOptionPage({
    super.key,
    required this.onColorSelected,
    required this.selectedColor,
    required this.isLeftSide,
    this.colorOptions = const [
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _dotSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < colorOptions.length; i++)
            _buildColorOption(colorOptions[i], i),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, int index) {
    final isSelected = color.value == selectedColor.value;
    final angle = (_startAngle + index * _angleStep) * (pi / 180);

    // Adjust the curve radius or apply additional offset for proper placement
    final dx = _curveRadius * (isLeftSide ? -1 : 1) * (1 - cos(angle));
    final dy = _curveRadius * cos(angle) * sin(angle);

    return Transform.translate(
      offset: Offset(dx, dy),
      child: GestureDetector(
        onTap: () => onColorSelected(color),
        child: Container(
          width: _dotSize,
          height: _dotSize,
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: isSelected ? _selectedBorderWidth : _unselectedBorderWidth,
            ),
          ),
        ),
      ),
    );
  }
}
