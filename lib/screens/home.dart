import 'package:flutter/material.dart';
import 'package:wearos/screens/watchface.dart';
import 'package:wearos/screens/customize.dart';  // Add this import
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToCustomizeScreen() {
    HapticFeedback.vibrate();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomizeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: _navigateToCustomizeScreen,  // Detect long press
        child: WatchFace(),
      ),
    );
  }
}
