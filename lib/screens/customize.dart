import 'package:flutter/material.dart';
import 'package:wearos/screens/settings.dart';
import 'package:provider/provider.dart';
import 'package:wearos/models/settings_provider.dart';

class CustomizeScreen extends StatelessWidget{
  const CustomizeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Stack(
          children: [
            Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: settings.backgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left part: Weather info
                  Expanded(
                    child: Container(
                      width: 40,
                      height: 40,
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
                            Icons.wb_cloudy,
                            size: 10,
                            color: settings.complicationColor,
                          ),
                          Text(
                            settings.isEnglish ? '17°C' : '১৭°সে.',
                            style: TextStyle(
                              color: settings.fontColor,
                              fontSize: 10,
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
                        settings.isEnglish ? '10' : '১০',
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        settings.isEnglish ? '34' : '৩৪',
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        settings.isEnglish ? '00' : '০০',
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        settings.isEnglish ? 'AM' : 'পূর্বাহ্ণ',
                        style: TextStyle(color: settings.fontColor, fontSize: 8),
                      ),
                    ],
                  ),
                  // Right part: Settings button and additional info
                  Expanded(
                    child: Container(
                      width: 40,
                      height: 40,
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
                            settings.isEnglish ? 'Sun' : 'রবি',
                            style: TextStyle(
                              color: settings.complicationColor,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            settings.isEnglish ? '14 Mar' : '১৪ মার্চ',
                            style: TextStyle(
                              color: settings.fontColor,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 40,
              bottom: -10,
              child: TextButton(
                // Navigate to the settings page
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                ),
                style: TextButton.styleFrom(
                  overlayColor: Colors.transparent,
                ),
                child: Text(
                  settings.isEnglish ? 'Customize' : 'কাস্টোমাইজ',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 10,
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

