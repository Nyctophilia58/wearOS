import 'package:bangla_converter/bangla_converter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


String getDayOfWeek(DateTime localTime, bool isEnglish) {
  final List<String> daysEnglish = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> daysBangla = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি'];

  int dayIndex = localTime.weekday % 7; // Adjust index (1=Monday in Dart)
  return isEnglish ? daysEnglish[dayIndex] : daysBangla[dayIndex];
}

String getMonth(DateTime localTime, bool isEnglish) {
  final List<String> monthsEnglish = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final List<String> monthsBangla = [
    'জানু', 'ফেব', 'মার্চ', 'এপ্রি', 'মে', 'জুন', 'জুল', 'আগ', 'সেপ', 'অক্টো', 'নভে', 'ডিসে'
  ];

  int monthIndex = localTime.month - 1; // Month is 1-based in Dart
  return isEnglish ? monthsEnglish[monthIndex] : monthsBangla[monthIndex];
}

Future<Map<String, dynamic>> getWeatherData(String timezone, String apiKey) async {
  try {
    final location = timezone.split('/')[1]; // Extract city from timezone
    final url = Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temp = data['main']['temp'];
      IconData weatherIcon;

      if (temp < 10) {
        weatherIcon = Icons.ac_unit;
      } else if (temp >= 10 && temp < 25) {
        weatherIcon = Icons.wb_cloudy;
      } else if (temp >= 25 && temp < 35) {
        weatherIcon = Icons.wb_sunny;
      } else {
        weatherIcon = Icons.local_fire_department;
      }

      return {'temperature': '${temp.toStringAsFixed(0)}°C', 'weatherIcon': weatherIcon};
    } else {
      throw Exception('Failed to fetch weather data');
    }
  } catch (e) {
    return {'temperature': 'N/A', 'weatherIcon': Icons.error};
  }
}


String getAmPm(amPm, bool isEnglish){
  return isEnglish ? amPm : (amPm == 'AM' ? 'পূর্বাহ্ন' : 'অপরাহ্ন');
}

String convertText(String text, bool isEnglish) {
  return isEnglish ? BanglaConverter.banToEng(text) : BanglaConverter.engToBan(text);
}
