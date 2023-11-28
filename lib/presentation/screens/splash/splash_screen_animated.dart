import 'package:flutter/material.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '../../../config/theme/app_theme.dart';

class SplashScreenAnimated extends StatelessWidget {
  static const String name = 'splash_screen_animated';
  const SplashScreenAnimated({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Image.asset('assets/logo.png'),
        nextScreen: const LoginScreen(),
        splashTransition: SplashTransition.scaleTransition,
        animationDuration: const Duration(milliseconds: 400),
        nextRoute: LoginScreen.name,
        backgroundColor: AppTheme.colorApp,
        splashIconSize: 300.0);
  }
}
