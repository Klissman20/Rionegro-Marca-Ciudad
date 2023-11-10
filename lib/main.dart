import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rionegro_marca_ciudad/config/router/app_router.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      title: 'RionegroMarcaCiudad',
    );
  }
}
