import 'package:flutter/material.dart';

class KTextStyle {
  static const TextStyle titleRexText = TextStyle(
    color: Colors.red,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle descriptionText = TextStyle(fontSize: 16.0);
}

class AppColors {
  static const Color primary = Color(0xFFB595FC);
  static const Color secondary = Color.fromARGB(255, 51, 124, 243);
  static const Color accent = Color.fromARGB(255, 124, 243, 51);
  static const Color sellColor = Color(0xFF5ED6AB);
  static const Color buyColor = Color(0xFFFF6467);

  // 다른 색상들도 추가 가능
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color background = Colors.white;
}

class KConstants {
  static const String isDarkModeKey = 'isDarkMode';
}
