import 'package:flutter/material.dart';

class ColorOptionPage extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorOptionPage({super.key, required this.onColorSelected});

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
    return GestureDetector(
      onTap: () {
        onColorSelected(color); // Callback to update color in parent widget
      },
      child: Container(
        width: 10, // Smaller size for color options
        height: 10, // Smaller size for color options
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: Colors.white,
            width: 0.1,
          ),

        ),
      ),
    );
  }
}
