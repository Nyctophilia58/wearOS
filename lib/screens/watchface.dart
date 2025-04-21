import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wear_plus/wear_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:wearos/constants/apikey.dart';
import 'package:wearos/utilities/utils.dart';
import 'package:wearos/models/settings_provider.dart';

class WatchFace extends StatefulWidget {
  const WatchFace({super.key});

  @override
  State<WatchFace> createState() => _WatchFaceState();
}

class _WatchFaceState extends State<WatchFace> {
  late tz.TZDateTime localTime;
  late Timer _timer;
  String temperature = '...';
  IconData weatherIcon = Icons.wb_sunny;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _updateTime();
    _updateWeather();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      localTime = tz.TZDateTime.now(tz.getLocation(settings.selectedTimezone));
    });
  }

  void _updateWeather() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final apiKey = api_key; // Replace with your actual API key

    var weatherData = await getWeatherData(settings.selectedTimezone, apiKey);

    if (mounted) {
      setState(() {
        temperature = weatherData['temperature'];
        weatherIcon = weatherData['weatherIcon'];
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    String date = DateFormat('dd').format(localTime);
    String dayOfWeek = getDayOfWeek(localTime, settings.isEnglish);
    String month = getMonth(localTime, settings.isEnglish);

    int hour = localTime.hour;
    String amPm = '';
    if (!settings.is24HourFormat) {
      amPm = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      hour = hour == 0 ? 12 : hour;
    }

    String formatAmPm = getAmPm(amPm, settings.isEnglish);
    String formattedHour = hour.toString().padLeft(2, '0');
    String formattedMinute = localTime.minute.toString().padLeft(2, '0');
    String formattedSecond = localTime.second.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      body: AmbientMode(
        builder: (context, mode, child) {
          if (mode == WearMode.ambient) {
            return const Center(
              child: FlutterLogo(size: 200.0),
            );
          } else {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left part: Weather info
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: settings.backgroundColor,
                        border: Border.all(
                          color: settings.complicationColor,
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            weatherIcon,
                            size: 15,
                            color: settings.complicationColor,
                          ),
                          Text(
                            convertText(temperature, settings.isEnglish),
                            style: TextStyle(
                              color: settings.fontColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Center part: Time and Date
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        convertText(formattedHour, settings.isEnglish),
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        convertText(formattedSecond, settings.isEnglish),
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        convertText(formattedMinute, settings.isEnglish),
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        settings.is24HourFormat ? '' : formatAmPm,
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 10
                        ),
                      ),
                    ],
                  ),
                  // Right part: Settings button and additional info
                  Expanded(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: settings.backgroundColor,
                        border: Border.all(
                          color: settings.complicationColor,
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayOfWeek,
                            style: TextStyle(
                              color: (dayOfWeek == 'Fri' || dayOfWeek == 'Sat' || dayOfWeek == 'শুক্র' || dayOfWeek == 'শনি')
                                  ? Colors.red[900]
                                  : settings.complicationColor,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${convertText(date, settings.isEnglish)} $month',
                            style: TextStyle(color: settings.fontColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
