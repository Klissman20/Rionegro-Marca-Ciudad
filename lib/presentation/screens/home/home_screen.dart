import 'package:flutter/material.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  static const String name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Rionegro Marca Ciudad',
            textAlign: TextAlign.center,
          ),
        ),
        titleTextStyle:
            TextStyle(color: AppTheme.colorApp, fontWeight: FontWeight.w800),
      ),
      body: const Center(child: Text('Home Screen')),
    );
  }
}
