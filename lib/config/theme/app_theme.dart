import 'package:flutter/material.dart';

class AppTheme {
  static Color colorApp = const Color(0xFFE7004C);

  static Color darkColorApp = Color.fromARGB(255, 151, 0, 50);

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorApp,
        fontFamily: 'Gotham',
      );
}
