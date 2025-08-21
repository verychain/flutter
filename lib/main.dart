import 'package:demo_flutter/data/constants.dart';
import 'package:demo_flutter/data/notifiers.dart';
import 'package:demo_flutter/view/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          title: 'Verypool - Crypto P2P Market',
          theme: ThemeData(
            fontFamily: 'Pretendard',
            scaffoldBackgroundColor: Colors.white, // 앱 전체 배경색을 화이트로 지정
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
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
