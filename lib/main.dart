import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/data/notifiers.dart';
import 'package:demo_flutter/view/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    // Initialize the isDarkModeNotifier with the saved preference
    initThemeMode();
  }

  void initThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isDarkMode = prefs.getBool(KConstants.isDarkModeKey);
    isDarkModeNotifier.value =
        isDarkMode ?? false; // Default to false if not set
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Crypto P2P Market',
          theme: ThemeData(
            fontFamily: 'Pretendard',
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightBlue,
              brightness: isDarkMode
                  ? Brightness.dark
                  : Brightness.light, // Will change when theme is toggled
            ),
          ),
          home: WelcomePage(),
        );
      },
    );
  }
}
