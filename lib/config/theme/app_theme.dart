import 'package:flutter/material.dart';

class AppTheme {
  static Color colorApp = const Color(0xFFE7004C);

  static Color colorApp1 = const Color(0xFF00B2E3);

  static Color colorApp2 = const Color(0xFFF5B335);

  static Color colorApp3 = const Color(0xFF45C2B1);

  static Color colorApp4 = const Color(0xFFBB77C9);

  static Color colorApp5 = const Color(0xFF006BA9);

  static Color darkColorApp = Color.fromARGB(255, 151, 0, 50);

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorApp,
        fontFamily: 'Gotham',
      );
}
