import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String name = 'register-screen';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(child: Center(child: Text('Register Screen'))));
  }
}
