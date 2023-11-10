import 'package:flutter/material.dart';

class AppTheme {
  static Color colorApp = Color(0xFFDB411F);

  static Color colorAppAlpha = const Color.fromARGB(0x99, 0xDB, 0x41, 0x1F);

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorApp,
        fontFamily: 'Roboto',
      );
}
