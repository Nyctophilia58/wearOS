import 'package:flutter/material.dart';
import 'package:wearos/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:wearos/models/settings_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WearOS App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}