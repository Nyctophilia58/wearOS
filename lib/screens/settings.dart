import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wearos/models/settings_provider.dart';
import 'package:wearos/utilities/utils.dart';
import '../models/color_options.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

  Map<String, String> names = {
    "BackGround" : "ব্যাকগ্রাউন্ড রং",
    "Language" : "ভাষা",
    "Font Color" : "ফন্ট রং",
    "Complication Color" : "কমপ্লিকেশন রং",
    "Show Battery" : ""
  };

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEFT SLOT: Show Color Picker (Background) or leave empty
                (_currentPageIndex == 0)
                    ? SizedBox(
                  width: 10,
                  child: ColorOptionPage(
                    onColorSelected: (color) {
                      settings.setBackgroundColor(color);
                    },
                    selectedColor: settings.backgroundColor,
                  ),
                )
                : (_currentPageIndex == 1)
                    ? SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => settings.setLanguage(false),
                        child: Text(
                          'Ban',
                          style: TextStyle(
                            color: settings.isEnglish ? Colors.white : Colors.greenAccent,
                            fontSize: 10,
                            fontWeight: settings.isEnglish ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                  : const SizedBox(width: 10), // keep layout aligned

                const SizedBox(width: 3), // keep layout aligned

                // CENTER: PageView
                SizedBox(
                  width: 150,
                  height: 150,
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    children: [
                      _buildComplicationPage("BackGround", 0, settings),
                      _buildComplicationPage("Language", 1, settings),
                      _buildComplicationPage("Font Color", 2, settings),
                      _buildComplicationPage("Complication Color", 3, settings),
                    ],
                  ),
                ),


                const SizedBox(width: 3), // keep layout aligned

                // RIGHT SLOT: Language toggle or color options or empty
                (_currentPageIndex == 1)
                  ? SizedBox(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () => settings.setLanguage(true),
                            child: Text(
                              'Eng',
                              style: TextStyle(
                                color: settings.isEnglish ? Colors.greenAccent : Colors.white,
                                fontSize: 10,
                                fontWeight: settings.isEnglish ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                        ),
                      ],
                    ),
                  )
                    : (_currentPageIndex == 2)
                    ? SizedBox(
                  width: 10,
                  child: ColorOptionPage(
                    onColorSelected: (color) {
                      settings.setFontColor(color);
                    },
                    selectedColor: settings.fontColor,
                  ),
                )
                    : (_currentPageIndex == 3)
                    ? SizedBox(
                  width: 10,
                  child: ColorOptionPage(
                    onColorSelected: (color) {
                      settings.setComplicationColor(color);
                    },
                    selectedColor: settings.complicationColor,
                  ),
                )
                    : const SizedBox(width: 10), // placeholder if none
              ],
            ),

            SizedBox(
              height: 27,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildComplicationName("BackGround", 0, settings),
                  _buildComplicationName("Language", 1, settings),
                  _buildComplicationName("Font Color", 2, settings),
                  _buildComplicationName("Complication Color", 3, settings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create the complication name row and update selected page
  Widget _buildComplicationName(String name, int pageIndex, settings) {
    // Only show the name if it's the active page
    if (_currentPageIndex == pageIndex) {
      return Text(
        settings.isEnglish ? name : (names[name] ?? name),
        style: TextStyle(
          color: Colors.yellow[900],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Container(); // Return an empty container for inactive pages
    }
  }

  // Helper function to create content for each complication
  Widget _buildComplicationPage(String content, int pageIndex, settings) {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: settings.backgroundColor, // Use the selected color for the watch face
        ),
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

                  const SizedBox(height: 20),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add battery icon here
                      Icon(
                        Icons.battery_3_bar,
                        size: 12,
                        color: settings.complicationColor,
                      ),
                      Text(
                        settings.isEnglish ? '68%' : '৬৮%',
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 10,
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
                  settings.isEnglish ? '10' : convertText('10', settings.isEnglish),
                  style: TextStyle(
                    color: settings.fontColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  settings.isEnglish ? '34' : convertText('34', settings.isEnglish),
                  style: TextStyle(
                    color: settings.fontColor,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  settings.isEnglish ? '00' : convertText('00', settings.isEnglish),
                  style: TextStyle(
                    color: settings.fontColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  settings.isEnglish ? 'AM' : getAmPm('AM', settings.isEnglish),
                  style: TextStyle(
                    color: settings.fontColor,
                    fontSize: 8
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
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        // heart rate icon
                        Icons.directions_walk,
                        size: 12,
                        color: settings.complicationColor,
                      ),
                      Text(
                        // heart rate value
                        settings.isEnglish ? '2845' : '২৮৪৫',
                        style: TextStyle(
                          color: settings.fontColor,
                          fontSize: 10,
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