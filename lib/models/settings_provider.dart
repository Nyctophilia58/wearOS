import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isEnglish = true;
  bool is24HourFormat = false;
  String selectedTimezone = 'Asia/Dhaka';

  Color _backgroundColor = Colors.black;
  Color _complicationColor = Colors.white;
  Color _fontColor = Colors.white;

  bool get isEnglish => _isEnglish;
  Color get backgroundColor => _backgroundColor;
  Color get complicationColor => _complicationColor;
  Color get fontColor => _fontColor;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _isEnglish = prefs.getBool('isEnglish') ?? true;
    is24HourFormat = prefs.getBool('is24HourFormat') ?? false;
    selectedTimezone = prefs.getString('selectedTimezone') ?? 'Asia/Dhaka';

    int bgColorValue = prefs.getInt('backgroundColor') ?? Colors.black.value;
    int compColorValue = prefs.getInt('complicationColor') ?? Colors.white.value;
    int fontColorValue = prefs.getInt('fontColor') ?? Colors.white.value;

    _backgroundColor = Color(bgColorValue);
    _complicationColor = Color(compColorValue);
    _fontColor = Color(fontColorValue);

    notifyListeners();
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEnglish', _isEnglish);
    prefs.setBool('is24HourFormat', is24HourFormat);
    prefs.setString('selectedTimezone', selectedTimezone);
    prefs.setInt('backgroundColor', _backgroundColor.value);
    prefs.setInt('complicationColor', _complicationColor.value);
  }

  void toggleLanguage() {
    _isEnglish = !isEnglish;
    _saveSettings();
    notifyListeners();
  }

  void toggleTimeFormat() {
    is24HourFormat = !is24HourFormat;
    _saveSettings();
    notifyListeners();
  }

  void setLanguage(bool value) {
    _isEnglish = value;
    _saveSettings();
    notifyListeners();
  }

  void setTimezone(String timezone) {
    selectedTimezone = timezone;
    _saveSettings();
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    _saveSettings();
    notifyListeners();
  }

  void setComplicationColor(Color color) {
    _complicationColor = color;
    _saveSettings();
    notifyListeners();
  }

  void setFontColor(Color color) {
    _fontColor = color;
    _saveSettings();
    notifyListeners();
  }
}
