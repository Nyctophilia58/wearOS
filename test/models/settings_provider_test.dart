import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wearos/models/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsProvider Tests', () {
    late SettingsProvider provider;

    setUp(() async {
      // Set empty prefs before each test
      SharedPreferences.setMockInitialValues({});
      provider = SettingsProvider();
      // wait for settings to load
      await Future.delayed(Duration(milliseconds: 100));
    });

    test('Initial values are correct', () {
      expect(provider.isEnglish, true);
      expect(provider.is24Hour, false);
      expect(provider.timezone, 'Asia/Dhaka');
      expect(provider.backgroundColor, Colors.black);
      expect(provider.complicationColor, Colors.white);
      expect(provider.fontColor, Colors.white);
    });

    test('toggleLanguage changes the language setting', () async {
      bool initialLanguage = provider.isEnglish;
      provider.toggleLanguage();
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.isEnglish, !initialLanguage);
    });

    test('toggleTimeFormat changes the time format setting', () async {
      bool initialFormat = provider.is24Hour;
      provider.toggleTimeFormat();
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.is24Hour, !initialFormat);
    });

    test('setLanguage sets the language', () async {
      provider.setLanguage(false);
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.isEnglish, false);
    });

    test('setTimezone updates the timezone', () async {
      provider.setTimezone('Europe/London');
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.timezone, 'Europe/London');
    });

    test('setBackgroundColor updates background color', () async {
      provider.setBackgroundColor(Colors.blue);
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.backgroundColor, Colors.blue);
    });

    test('setComplicationColor updates complication color', () async {
      provider.setComplicationColor(Colors.red);
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.complicationColor, Colors.red);
    });

    test('setFontColor updates font color', () async {
      provider.setFontColor(Colors.green);
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.fontColor, Colors.green);
    });

    test('Settings persist across instances', () async {
      provider.setLanguage(false);
      provider.setTimezone('Europe/Paris');
      provider.setBackgroundColor(Colors.purple);
      provider.setComplicationColor(Colors.orange);
      provider.setFontColor(Colors.yellow);
      provider.toggleTimeFormat();
      await Future.delayed(Duration(milliseconds: 100));

      // Create a new provider to simulate app restart
      var newProvider = SettingsProvider();
      await Future.delayed(Duration(milliseconds: 100));

      expect(newProvider.isEnglish, false);
      expect(newProvider.timezone, 'Europe/Paris');
      expect(newProvider.backgroundColor.value, Colors.purple.value);
      expect(newProvider.complicationColor.value, Colors.orange.value);
      expect(newProvider.fontColor.value, Colors.yellow.value);
      expect(newProvider.is24Hour, true);
    });
  });
}
