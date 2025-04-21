import 'package:flutter/material.dart';

class ColorOptionPage extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Color selectedColor;

  const ColorOptionPage({
    super.key,
    required this.onColorSelected,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildColorOption(Colors.black),
        SizedBox(height: 2),
        _buildColorOption(Colors.red),
        SizedBox(height: 2),
        _buildColorOption(Colors.green),
        SizedBox(height: 2),
        _buildColorOption(Colors.blue),
        SizedBox(height: 2),
        _buildColorOption(Colors.yellow),
      ],
    );
  }

  Widget _buildColorOption(Color color) {
    bool isSelected = color.value == selectedColor.value;

    return GestureDetector(
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
    );
  }
}
