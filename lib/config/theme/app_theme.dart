import 'package:flutter/material.dart';

class AppTheme {
  static Color colorApp = const Color(0xE7FF004C);

  static Color darkColorApp = const Color.fromARGB(255, 132, 1, 44);

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorApp,
        fontFamily: 'Gotham',
      );
}
