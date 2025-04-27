import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:wearos/constants/apikey.dart';
import 'package:wearos/utilities/utils.dart';
import 'package:wearos/models/settings_provider.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';


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

  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;

  late Stream<StepCount> _stepCountStream;
  String _steps = '0';


  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _updateTime();
    _updateWeather();
    _getBatteryLevel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
      if (timer.tick % 30 == 0) {
        _getBatteryLevel();
      }
    });
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
    });
    _requestPermissions();
    _initPedometer();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.activityRecognition.request().isGranted) {
      print("Activity recognition permission granted");
    } else {
      print("Permission denied");
    }
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: true,
    );
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void _onStepCountError(error) {
    setState(() {
      _steps = 'N/A';
    });
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

  void _getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    if (mounted) {
      setState(() {
        _batteryLevel = level;
      });
    }
  }

  IconData _getBatteryIcon(int level, BatteryState state) {
    if (state == BatteryState.charging) {
      return Icons.battery_charging_full;
    } else if (level >= 90) {
      return Icons.battery_full;
    } else if (level >= 75) {
      return Icons.battery_6_bar;
    } else if (level >= 50) {
      return Icons.battery_5_bar;
    } else if (level >= 35) {
      return Icons.battery_4_bar;
    } else if (level >= 20) {
      return Icons.battery_2_bar;
    } else if (level >= 5) {
      return Icons.battery_alert;
    } else {
      return Icons.battery_0_bar;
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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left part: Weather info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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

                  const SizedBox(height: 20),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add battery icon here
                      Icon(
                        _getBatteryIcon(_batteryLevel, _batteryState),
                        size: 15,
                        color: settings.complicationColor,
                      ),
                      Text(
                        convertText(
                          _batteryLevel.toString(),
                          settings.isEnglish,
                        ),
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ]
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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

                  const SizedBox(height: 20),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.directions_walk,
                        size: 15,
                        color: settings.complicationColor,
                      ),
                      Text(
                        convertText(_steps, settings.isEnglish),
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
