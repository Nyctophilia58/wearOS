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
    "Font" : "ফন্ট",
    "Font Color" : "ফন্ট রং",
    "Complication Color" : "কমপ্লিকেশন রং",
  };

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildComplicationName("BackGround", 0, settings),
                  _buildComplicationName("Language", 1, settings),
                  _buildComplicationName("Font", 2, settings),
                  _buildComplicationName("Font Color", 3, settings),
                  _buildComplicationName("Complication Color", 4, settings),

                ],
              ),
            ),

            Positioned(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentPageIndex = index;
                          });
                        },
                        children: [
                          _buildComplicationPage("BackGround", 0, settings),
                          _buildComplicationPage("Language", 1, settings),
                          _buildComplicationPage("Font", 2, settings),
                          _buildComplicationPage("Font Color", 3, settings),
                          _buildComplicationPage("Complication Color", 4, settings),
                        ],
                      ),
                    ),
                  ),

                  if (_currentPageIndex == 0) ...[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 30,
                          child: ColorOptionPage(
                            onColorSelected: (color) {
                              settings.setBackgroundColor(color);
                            },
                          ),
                        )
                    ),
                  ],

                  if (_currentPageIndex == 1) ...[
                    Positioned(
                      top: 105,
                      left: 5,
                      // alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: (){
                            settings.setLanguage(false);
                          },
                          child: Text(
                            'Ban',
                            style: TextStyle(
                              color: settings.isEnglish ? Colors.white : Colors.greenAccent,
                              fontSize: 10,
                              fontWeight: settings.isEnglish ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                      ),
                    ),

                    Positioned(
                      top: 105,
                      right: 5,
                      child: GestureDetector(
                          onTap: (){
                            settings.setLanguage(true);
                          },
                          child: Text(
                            'Eng',
                            style: TextStyle(
                              color: settings.isEnglish? Colors.greenAccent : Colors.white,
                              fontSize: 10,
                              fontWeight: settings.isEnglish ? FontWeight.bold : FontWeight.normal,

                            ),
                          ),
                        ),
                      ),

                  ],

                  if(_currentPageIndex == 3) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 30,
                        child: ColorOptionPage(
                          onColorSelected: (color) {
                            settings.setFontColor(color);
                          },
                        ),
                      )
                    ),
                  ],

                  if (_currentPageIndex == 4)...[
                    Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 30,
                          child: ColorOptionPage(
                            onColorSelected: (color) {
                              settings.setComplicationColor(color);
                            },
                          ),
                        )
                    ),
                  ],
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
          color: Colors.blueGrey, // Use the selected color for the watch face
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
        width: 170,
        height: 170,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: settings.backgroundColor, // Use the selected color for the watch face
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
                      settings.isEnglish ? '17°C' : '${convertText('17', settings.isEnglish)}°সে.',
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
                  settings.isEnglish ? '10' : convertText('10', settings.isEnglish),
                  style: TextStyle(
                    color: settings.fontColor,
                    fontSize: 45,
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
                    fontSize: 45,
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
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
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
                        fontSize: 8
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}